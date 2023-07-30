#!/bin/bash

# Array of dependencies
dependencies=("curl" "unzip" "wget" "awk" "tr" "sort" "head" "cp" "find" "cut" "grep" "sed")

# Function to check if a command is available
check_dependency() {
    local command="$1"
    if ! command -v "$command" >/dev/null 2>&1; then
        echo "$command is not installed"
        return 1
    fi
}

# Check dependencies
for dependency in "${dependencies[@]}"; do
    check_dependency "$dependency" || missing_dependencies=true
done

# Print missing dependencies and abort if any are missing
if [ "$missing_dependencies" = true ]; then
    echo "Please install the missing dependencies and try again."
    exit 1
fi

# Function to retrieve the latest BDS version
get_latest_version() {
    local api_url="https://ssk.taiyu.workers.dev/zh-hans/download/server/bedrock"
    local latest_version=$(curl -s "$api_url" | grep -oE 'bedrock-server-[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort -V | head -n1 | awk -F"-" '{print $NF}')
    echo "$latest_version"
}

# Function to download the BDS server
download_bds() {
    local version="$1"
    local download_url="https://minecraft.azureedge.net/bin-linux/bedrock-server-$version.zip"
    local download_location="$(dirname "$0")/bedrock-server-$version.zip"
    echo "Downloading Minecraft BDS version $version..."

    # Use wget to download the file and display progress
    wget -q --show-progress -O "$download_location" "$download_url"

    echo "Download complete."
}

# Function to extract the BDS server
extract_bds() {
    local version="$1"
    local zip_file="$(dirname "$0")/bedrock-server-$version.zip"
    local extraction_dir="$(dirname "$0")/bedrock-server-$version"
    echo "Extracting Minecraft BDS version $version..."
    unzip -q "$zip_file" -d "$extraction_dir"
    echo "Extraction complete."
}

# Function to copy world, development_behavior_packs, and development_resource_packs folders
copy_folders() {
    local old_version_dir="$1"
    local new_version_dir="$2"
    echo "Copying worlds and development packs folders..."
    if [ -d "$old_version_dir/worlds" ]; then
        cp -r "$old_version_dir/worlds" "$new_version_dir/"
    fi
    if [ -d "$old_version_dir/development_behavior_packs" ]; then
        cp -r "$old_version_dir/development_behavior_packs" "$new_version_dir/"
    fi
    if [ -d "$old_version_dir/development_resource_packs" ]; then
        cp -r "$old_version_dir/development_resource_packs" "$new_version_dir/"
    fi
    echo "Copying complete."
}

# Function to compare and update server.properties
update_server_properties() {
    local old_version_dir="$1"
    local new_version_dir="$2"
    local old_properties="$old_version_dir/server.properties"
    local new_properties="$new_version_dir/server.properties"

    echo
    echo "Comparing server.properties..."

    # Read the old properties file line by line
    while IFS='=' read -r old_key old_value <&3; do
        # Check if the line is not a comment
        if [[ "$old_key" != "#"* ]]; then
            # Get the corresponding line in the new properties file
            new_line=$(grep -E "^\s*$old_key=" "$new_properties")

            # Extract the value from the new line
            new_value=$(echo "$new_line" | cut -d'=' -f2)

            # Compare the values
            if [[ "$old_value" != "$new_value" ]]; then
                echo
                echo "Difference found:"
                echo "Old: $old_key=$old_value"
                echo "New: $new_line"
                echo

                read -p "Apply this change? (y/n): " choice

                if [[ $choice == [Yy] ]]; then
                    # Replace the line in the new properties file
                    if [ -n "$new_line" ]; then
                        sed -i "s|$(echo "$new_line" | sed 's/[\/&]/\\&/g')|$old_key=$old_value|" "$new_properties"
                    else
                        echo "$old_key=$old_value" >> "$new_properties"
                    fi


                    echo "Change applied."
                else
                    echo "Change not applied."
                fi
            fi
        fi
    done 3< <(grep -v '^#' "$old_properties" | grep -v '^\s*$')

    echo
    echo "Server properties update complete."
}

# Main script
latest_version=$(get_latest_version)
if [ -z "$latest_version" ]; then
    echo "Failed to retrieve the latest version. Please try again later."
    exit 1
fi

# Determine old version and new version directories
old_version_dir=$(find . -type d -name 'bedrock-server-*' | sort -V | tail -n1)
new_version_dir="$(dirname "$0")/bedrock-server-$latest_version"

# Check if old version directory exists
if [ -n "$old_version_dir" ]; then
    echo "Found old version directory: $old_version_dir"
    old_version="$(basename "$old_version_dir" | sed 's/bedrock-server-//')"

    # Check if old and new version are the same
    if [ "$old_version" == "$latest_version" ]; then
        echo "Old version and new version are the same. Aborting."
        exit 1
    fi
fi

# Download the new BDS server
download_bds "$latest_version"

# Extract the new BDS server
extract_bds "$latest_version"

# Copy folders from old version directory
if [ -n "$old_version_dir" ]; then
    copy_folders "$old_version_dir" "$new_version_dir"
    # Compare and update server.properties
    update_server_properties "$old_version_dir" "$new_version_dir"
fi
