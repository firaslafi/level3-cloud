#!/bin/bash

# Path to your STACKIT JSON key
KEY_PATH="$HOME/sa-key.json"

if [ -f "$KEY_PATH" ]; then
    export STACKIT_SERVICE_ACCOUNT_KEY=$(cat "$KEY_PATH")
    echo "✅ STACKIT_SERVICE_ACCOUNT_KEY has been exported."
else
    echo "❌ Error: Key file not found at $KEY_PATH"
fi