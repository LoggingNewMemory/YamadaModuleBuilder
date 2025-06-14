#!/bin/bash

# Source the megumi configuration
source ./megumi.sh

# Telegram Group ID Fetcher for KatouMegumiFiles
BOT_TOKEN="$TELEGRAM_BOT_TOKEN"
GROUP_USERNAME="KanagawaGroup" # Change into your group name

# Remove @ symbol if present
GROUP_USERNAME=$(echo "$GROUP_USERNAME" | sed 's/^@//')

# Make API call to get chat info
RESPONSE=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getChat?chat_id=@${GROUP_USERNAME}")

# Check if request was successful
if echo "$RESPONSE" | grep -q '"ok":true'; then
    # Extract group ID using grep and sed
    GROUP_ID=$(echo "$RESPONSE" | grep -o '"id":[^,]*' | head -1 | sed 's/"id"://')
    
    echo "Group ID for @${GROUP_USERNAME}: $GROUP_ID"
else
    echo "Error: Unable to fetch group information"
    echo "Response: $RESPONSE"
    echo ""
    echo "Possible reasons:"
    echo "1. Invalid bot token"
    echo "2. Bot is not a member of the group"
    echo "3. Group username is incorrect"
    echo "4. Group is private"
fi