local map, super = Class(Map)

function map:init(world,data)
    super.init(self,world,data)
    self.menu = FileSelectMenu()
    self.music = Kristal.getLibConfig("fileselect", "music")
end

function map:onEnter()
    self.world:openMenu(self.menu)
    if FileSelectBackground then
        self.world:spawnObject(FileSelectBackground(self.menu), WORLD_LAYERS["below_ui"])
    end
end

return map
