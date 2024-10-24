# Wallpaper Combination Maker for Ubuntu

This is used to create multiple spanned wallpaper to set in ubuntu.

# Features

- Generate image combining 2 images.
- Generate multiple combinations of given images.
- Automatically generate image when new images added in the source folder.
- Skip already generated files.
- Automatically remove generated combinations of a source file if it is removed from the source folder.
- Autostart on startup
- Options to increase variety (will create more files).

# Todo

- Combine multiple image instead of only 2 images.
- Create combinations for varying resolutions.

# Install

> Note: `ImageMagick` and `inotify-tools` required.

Add wallpapers in `Source` folder. Then run following command to autostart. **Read Note below before running autostart**

```sh
chmod +x watcher_autostart_enable.sh
./watcher_autostart_enable.sh
```

# Uninstall

```sh
chmod +x watcher_autostart_disable.sh
./watcher_autostart_enable.sh
```

Then if you want, manually delete the parent folder (It will delete all of the wallpapers and combined images)

# Note

- The more wallpaper the more time it will take to generate combined images.
- If using for the first time, run `generate_combinations.sh` once before enabling autostart. It will create image combinations initially.
- Use `Variety` or other apps to automatically switch between generated wallpapers.
