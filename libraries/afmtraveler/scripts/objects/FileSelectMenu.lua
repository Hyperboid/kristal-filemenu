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

return FileSelectMenu