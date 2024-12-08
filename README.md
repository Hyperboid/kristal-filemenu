Just another in-mod file menu. To add a background, just make an object class called `FileSelectBackground`. See `scripts/objects/FileSelectBackground.lua` for an example.

In your mod.json, make sure to set `map` to `"fileselect"` and `useSaves` to `false`.

# Library options

`map`: The map that is loaded into when starting a new file.  
`music`: The music that plays on the menu. Defaults to "AUDIO_DRONE".  
`style`: Either "DEVICE" or "normal", determines the appearance of the menu. Defaults to "DEVICE".  

# Known issues
- No state between save selection and loading (like Deltatraveler)
- Example FileSelectBackground is cut off
- Missing some interactions on the DEVICE style ~~(e.g. threat level)~~
