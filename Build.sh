#!/bin/bash

MODULES_DIR="Modules"
BUILD_DIR="Build"

# Check if megumi.sh exists and load configuration
TELEGRAM_ENABLED=false
if [ -f "megumi.sh" ]; then
    source megumi.sh
    TELEGRAM_ENABLED=true
fi

mkdir -p "$BUILD_DIR"

welcome() {
    clear
    echo "---------------------------------"
    echo "      Yamada Module Builder      "
    echo "---------------------------------"
    echo ""
}

success() {
    echo "---------------------------------"
    echo "    Build Process Completed      "
    printf "     Ambatukam : %s seconds\n" "$SECONDS"
    echo "---------------------------------"
}

# Function to send file to Telegram
send_to_telegram() {
    local file_path="$1"
    local caption="$2"
    
    if [ -z "$TELEGRAM_BOT_TOKEN" ]; then
        echo "Error: TELEGRAM_BOT_TOKEN is not set in megumi.sh!"
        return 1
    fi
    
    if [ -z "$TELEGRAM_CH_ID" ]; then
        echo "Error: TELEGRAM_CH_ID is not set in megumi.sh!"
        return 1
    fi
    
    echo "Uploading $(basename "$file_path") to Telegram..."
    
    # Send document to Telegram
    response=$(curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendDocument" \
        -F "chat_id=$TELEGRAM_CH_ID" \
        -F "document=@$file_path" \
        -F "caption=$caption")
    
    # Check if upload was successful
    if echo "$response" | grep -q '"ok":true'; then
        echo "✓ Successfully uploaded $(basename "$file_path")"
        return 0
    else
        echo "✗ Failed to upload $(basename "$file_path")"
        echo "Response: $response"
        return 1
    fi
}

# Function to prompt for Telegram posting
prompt_telegram_post() {
    echo ""
    read -p "Post to testing group? (y/N): " POST_TO_TELEGRAM
    POST_TO_TELEGRAM=${POST_TO_TELEGRAM,,}  # Convert to lowercase
    
    if [[ "$POST_TO_TELEGRAM" == "y" || "$POST_TO_TELEGRAM" == "yes" ]]; then
        return 0
    else
        return 1
    fi
}

build_modules() {
    rm -rf "$BUILD_DIR"/*

    read -p "Enter Version (e.g., V1.0): " VERSION

    while true; do
        read -p "Enter Build Type (LAB/RELEASE): " BUILD_TYPE
        BUILD_TYPE=${BUILD_TYPE^^}
        if [[ "$BUILD_TYPE" == "LAB" || "$BUILD_TYPE" == "RELEASE" ]]; then
            break
        fi
        echo "Invalid input. Please enter LAB or RELEASE."
    done

    cd "$MODULES_DIR" || exit 1
    MODULE_ID=$(grep "^id=" "module.prop" | cut -d'=' -f2 | tr -d '[:space:]')

    # Fix: Use sed without attempting to preserve permissions
    # Create a temporary file for the sed operation
    if [ -f "module.prop" ]; then
        cp "module.prop" "module.prop.tmp"
        sed "s/^version=.*$/version=$VERSION/" "module.prop.tmp" > "module.prop"
        rm "module.prop.tmp"
    fi

    if [ -f "customize.sh" ]; then
        cp "customize.sh" "customize.sh.tmp"
        sed "s/^ui_print \"Version : .*$/ui_print \"Version : $VERSION\"/" "customize.sh.tmp" > "customize.sh"
        rm "customize.sh.tmp"
    fi

    ZIP_NAME="${MODULE_ID}-${VERSION}-${BUILD_TYPE}.zip"
    ZIP_PATH="../$BUILD_DIR/$ZIP_NAME"
    zip -q -r "$ZIP_PATH" ./*
    echo "Created: $ZIP_NAME"

    cd ..

    # Check if Telegram is enabled
    if [ "$TELEGRAM_ENABLED" = true ]; then
        # Prompt for Telegram posting
        if prompt_telegram_post; then
            echo ""
            echo "Uploading to Telegram channel..."
            
            # Create a summary message
            SUMMARY_MESSAGE="🚀 *Yamada Module Build Complete*%0A%0A"
            SUMMARY_MESSAGE+="📦 *Module:* $MODULE_ID%0A"
            SUMMARY_MESSAGE+="🏷️ *Version:* $VERSION%0A"
            SUMMARY_MESSAGE+="🔧 *Build Type:* $BUILD_TYPE%0A%0A"
            SUMMARY_MESSAGE+="File uploading below... ⬇️"
            
            # Send summary message first
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CH_ID" \
                -d "text=$SUMMARY_MESSAGE" \
                -d "parse_mode=Markdown" > /dev/null
            
            # Upload the zip file
            if [ -f "$BUILD_DIR/$ZIP_NAME" ]; then
                caption="📱 $MODULE_ID - $VERSION ($BUILD_TYPE)"
                
                if send_to_telegram "$BUILD_DIR/$ZIP_NAME" "$caption"; then
                    echo ""
                    echo "✅ Upload successful!"
                    
                    # Send completion message
                    COMPLETION_MESSAGE="✅ *Upload Complete!*%0A%0AModule uploaded successfully to the testing group."
                    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                        -d "chat_id=$TELEGRAM_CH_ID" \
                        -d "text=$COMPLETION_MESSAGE" \
                        -d "parse_mode=Markdown" > /dev/null
                else
                    echo ""
                    echo "❌ Upload failed!"
                    
                    # Send failure message
                    FAILURE_MESSAGE="❌ *Upload Failed*%0A%0AThere was an issue uploading the module to the testing group."
                    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                        -d "chat_id=$TELEGRAM_CH_ID" \
                        -d "text=$FAILURE_MESSAGE" \
                        -d "parse_mode=Markdown" > /dev/null
                fi
            else
                echo "Error: ZIP file not found at $BUILD_DIR/$ZIP_NAME"
            fi
        else
            echo "Skipping Telegram upload."
        fi
    else
        echo ""
        echo "Post to telegram disabled, please setup megumi.sh and set TELEGRAM_CH_ID"
    fi
}

welcome
SECONDS=0  # Start timing
build_modules
success