# This is just source code so I don't get in trouble

A simple python script that slices .mp4 footage in .png files.

- Currently this works with PNG's and JPEG! If ROBLOX supported AVIF I would switch to that since it's basically the same to AV1.
- The Plugin (Module comes with the plugin) is available at: https://create.roblox.com/store/asset/18735535757, or you can just use it locally by extracting it from here

## Goals:
- Make a "algorithm" in which Python detects duplicate or similar frames, combines them all in one and then via a config file it tells Lua to wait a set amount of time when on that frame. This will drastically decrease the image count and the size.
- Find a way to "stream" images rather than uploading massive amounts of images in Roblox manually.
- Implement "Lazy Loading" when playing back images.
- Instead of having hunderds of separate images stored in the game, we will have only one and with a config script it's rbxassetid will be changed. This will significantly reduce the memory usage. ( DONE! Use latest to use this feature, there might be slight issues however .)
