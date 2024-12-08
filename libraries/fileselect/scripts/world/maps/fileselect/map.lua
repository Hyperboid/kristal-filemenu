local map, super = Class(Map)

function map:init(world,data)
    super.init(self,world,data)
    self.menu = FileSelectMenu()
    self.music = Kristal.callEvent("getFileSelectMusic") or Kristal.getLibConfig("fileselect", "music")
    self.menustyle = Kristal.callEvent("getFileSelectStyle") or Kristal.getLibConfig("fileselect", "style")
end

function map:onEnter()
    self.world:openMenu(self.menu)
    if FileSelectBackground then
        self.world:spawnObject(FileSelectBackground(self.menu), WORLD_LAYERS["below_ui"])
    end
end

return map
