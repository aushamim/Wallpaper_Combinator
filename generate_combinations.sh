#!/bin/bash

parent_folder="$(dirname "$(realpath "$0")")"


source_folder="$parent_folder/Source"
output_folder="$parent_folder/Combined_Images"


main_log_file="$parent_folder/activities.log"
log_file="$parent_folder/combined_images.log"
tmp_log_file="$parent_folder/combined_images_tmp.log"


monitor_width=1920
monitor_height=1080
num_monitors=2
increase_variety=false


# Calculate combined width for the images based on monitor count
combined_width=$((monitor_width * num_monitors))
combined_height="$monitor_height"


mkdir -p "$output_folder"
touch "$main_log_file"
touch "$log_file"
touch "$tmp_log_file"

log() {
    echo "$1" | tee -a "$main_log_file"
}

log ""
log "$(date)"
log "---"

# Get all image files in the source folder (quote to handle spaces)
mapfile -t image_files < <(find "$source_folder" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \))


if [ ${#image_files[@]} -lt 2 ]; then
    log "[+] Not enough images to combine."
    exit 1
fi


log "[+] Creating combinations"

if [[ $increase_variety = true ]] then
  log "[+] Increased Variety"
  for ((i = 0; i < ${#image_files[@]}; i++)); do
    for ((j = 0; j < ${#image_files[@]}; j++)); do
        # Skip combining an image with itself
        if [ $i -ne $j ]; then
            img1="${image_files[$i]}"
            img2="${image_files[$j]}"
            
            output_filename="$output_folder/Combined_$(basename "$img1" | sed 's/\.[^.]*$//')_$(basename "$img2" | sed 's/\.[^.]*$//').jpg"
            echo "$output_filename" >> "$tmp_log_file"

            if grep -q "$output_filename" "$log_file"; then
                log "[ ] Skipping already combined images: \"$output_filename\""
                continue
            fi

            convert "$img1" -resize "${monitor_width}x${combined_height}^" -gravity center -extent "${monitor_width}x${combined_height}" temp1.jpg
            convert "$img2" -resize "${monitor_width}x${combined_height}^" -gravity center -extent "${monitor_width}x${combined_height}" temp2.jpg
            
            convert temp1.jpg temp2.jpg +append "$output_filename"

            echo "$output_filename" >> "$log_file"

            rm temp1.jpg temp2.jpg

            log "[ ] Combined \"$img1\" and \"$img2\" into \"$output_filename\""
        fi
    done
  done
else
  for ((i = 0; i < ${#image_files[@]} - 1; i++)); do
    for ((j = i + 1; j < ${#image_files[@]}; j++)); do
        # Skip combining an image with itself
        if [ $i -ne $j ]; then
            img1="${image_files[$i]}"
            img2="${image_files[$j]}"
            
            output_filename="$output_folder/Combined_$(basename "$img1" | sed 's/\.[^.]*$//')_$(basename "$img2" | sed 's/\.[^.]*$//').jpg"
            echo "$output_filename" >> "$tmp_log_file"

            if grep -q "$output_filename" "$log_file"; then
                log "[ ] Skipping already combined images: \"$output_filename\""
                continue
            fi

            convert "$img1" -resize "${monitor_width}x${combined_height}^" -gravity center -extent "${monitor_width}x${combined_height}" temp1.jpg
            convert "$img2" -resize "${monitor_width}x${combined_height}^" -gravity center -extent "${monitor_width}x${combined_height}" temp2.jpg
            
            convert temp1.jpg temp2.jpg +append "$output_filename"

            echo "$output_filename" >> "$log_file"

            rm temp1.jpg temp2.jpg

            log "[ ] Combined \"$img1\" and \"$img2\" into \"$output_filename\""
        fi
    done
  done
fi


log "[+] All combinations generated in \"$output_folder\"."

# Cleaning combinations whose source is removed
log "[+] Cleaning up deleted images"

sort "$log_file" -o "$log_file"
sort "$tmp_log_file" -o "$tmp_log_file"
comm -23 "$log_file" "$tmp_log_file" > to_clean.log

while IFS= read -r file; do
  if [[ -f "$file" ]]; then
    log "Deleting $file"
    rm "$file"
  else
    log "File not found: $file"
  fi
done < to_clean.log


mv "$tmp_log_file" "$log_file"
rm "to_clean.log"

log "[+] Cleaning complete"
