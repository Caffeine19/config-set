# Backup macOS Application Icons
# Usage: backup_app_icons [destination_directory]

backup_app_icons() {
    local date_suffix=$(date +"%Y-%m-%d")
    local dest_dir="${1:-$HOME/Desktop/AppIcons_${date_suffix}}"
    local apps_dir="/Applications"
    local success_count=0
    local fail_count=0

    # Create destination directory if it doesn't exist
    if [[ ! -d "$dest_dir" ]]; then
        mkdir -p "$dest_dir"
        echo "📁 Created destination directory: $dest_dir"
    fi

    echo "🔍 Scanning applications in $apps_dir..."
    echo ""

    # Get list of all .app bundles
    local app_list=("$apps_dir"/*.app(N))

    if [[ ${#app_list[@]} -eq 0 ]]; then
        echo "⚠️ No applications found in $apps_dir"
        return 1
    fi

    echo "💫 Found ${#app_list[@]} applications"
    echo "========================━"
    echo ""

    for app_path in "${app_list[@]}"; do
        local app_name="${app_path:t:r}"  # Get basename without .app extension
        local info_plist="$app_path/Contents/Info.plist"
        local resources_dir="$app_path/Contents/Resources"

        # Try to get icon name from Info.plist
        if [[ -f "$info_plist" ]]; then
            local icon_file=$(/usr/libexec/PlistBuddy -c "Print :CFBundleIconFile" "$info_plist" 2>/dev/null)
            
            if [[ -n "$icon_file" ]]; then
                # Add .icns extension if not present
                [[ "$icon_file" != *.icns ]] && icon_file="${icon_file}.icns"
                
                local icon_path="$resources_dir/$icon_file"
                
                if [[ -f "$icon_path" ]]; then
                    cp "$icon_path" "$dest_dir/${app_name}.icns"
                    echo "🍀 $app_name"
                    ((success_count++))
                    continue
                fi
            fi
        fi

        # Fallback: search for any .icns file in Resources
        if [[ -d "$resources_dir" ]]; then
            local first_icns=$(find "$resources_dir" -maxdepth 1 -name "*.icns" -type f | head -1)
            if [[ -n "$first_icns" ]]; then
                cp "$first_icns" "$dest_dir/${app_name}.icns"
                echo "🍀 $app_name (fallback icon)"
                ((success_count++))
                continue
            fi
        fi

        # No icon found
        echo "⚠️ $app_name - Icon not found"
        ((fail_count++))
    done

    echo ""
    echo "========================"
    echo "📊 Summary:"
    echo "🍀 Successfully extracted: $success_count"
    echo "⚠️ Failed: $fail_count"
    echo "📁 Icons saved to: $dest_dir"
}

# List all applications without extracting icons
list_apps() {
    local apps_dir="/Applications"
    echo "💫 Applications in $apps_dir:"
    echo ""
    
    for app in "$apps_dir"/*.app(N); do
        echo "  • ${app:t:r}"
    done
}
