---@class FileSelectMenu : FileSelectMenu
local FileSelectMenu, super = Class("FileSelectMenu")

function FileSelectMenu:initStateclasses()
    super.initStateclasses(self)
    self.file_preview = ModlandFilePreview(self)
    self.file_start = ModlandFileStartScreen(self)
    self.file_namer = ModlandUnderFileNamer(self)
end

function FileSelectMenu:initStates()
    super.initStates(self)
    self.state_manager:addState("FILEPREVIEW", self.file_preview)
    self.state_manager:addState("FILESTART", self.file_start)
end

function FileSelectMenu:onAddToStage()
    if not (Kristal.getSaveFile(1) or Kristal.getSaveFile(2) or Kristal.getSaveFile(3)) then
        self:setState("FILESTART", Kristal.getSaveFile(1), 1)
    else
        super.onAddToStage(self)
    end
end

return FileSelectMenu