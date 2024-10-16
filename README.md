# This is just source code so I don't get in trouble

A ROBLOX Plugin that allows you to playback videos for free by splitting up JPG's or PNG's in many ImageLabels.

- It comes in two variants, one with more stable playback but larger memory usage (Stable) and an experimental one with 90% improvement in performance but comes at the cost of stuttering playback (Latest)

---

- Currently this works with PNG's and JPEG! If ROBLOX supported AVIF I would switch to that since it's basically the same to AV1.
- The Plugin (Module comes with the plugin) is available at: https://create.roblox.com/store/asset/18735535757, or you can just use it locally by extracting it from here

## Goals:
- Make a "algorithm" in which Python detects duplicate or similar frames, combines them all in one and then via a config file it tells Lua to wait a set amount of time when on that frame. This will drastically decrease the image count and the size.
- Find a way to "stream" images rather than uploading massive amounts of images in Roblox manually.
- Instead of having hunderds of separate images stored in the game, we will have only one and with a config script it's rbxassetid will be changed. This will significantly reduce the memory usage. ( DONE! Use latest to use this feature, there might be slight issues however .)

## Disclaimer:
- All good things eventually end. Well my time has come, I no longer work in ROBLOX related issues. This repository is no longer maintained, unless ROBLOX breaks compatibility with the plugin. Thanks for the support.
