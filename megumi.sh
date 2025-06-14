#!/bin/bash

# Megumi Configuration File
# This file contains sensitive configuration data
# DO NOT commit this file to version control!

# Telegram Bot Configuration
export TELEGRAM_BOT_TOKEN=" " # Fill with your bot token

# Multiple Telegram Groups Configuration
# Format: "GROUP_NAME:CHAT_ID"
# Add as many groups as needed
TELEGRAM_GROUPS=(
#  Fill this with your group name & Group ID (To know getCHId, please see getCHId.sh)
#  Example
# "Kanagawa Group:-100113134"
)

# Export the array for use in build script
export TELEGRAM_GROUPS

# Legacy support - use first group as default if old script is used
export TELEGRAM_CH_ID=$(echo "${TELEGRAM_GROUPS[0]}" | cut -d':' -f2)

echo "🌸 Megumi configuration loaded successfully!"
echo "📱 Configured groups: ${#TELEGRAM_GROUPS[@]}"