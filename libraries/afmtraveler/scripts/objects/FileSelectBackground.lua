---@class FileSelectBackground : FileSelectBackground
---@field data SaveData?
local FileSelectBackground, super = Class("FileSelectBackground")

function FileSelectBackground:onStateChange(old,new, ...)
    if new == "FILESELECT" or new == "FILEPREVIEW" then
        self.visible = true
    elseif new == "FILESTART" then
        self.visible = false
    end
    if old == "FILEPREVIEW" then
        self.data = nil
    end
    if new == "FILEPREVIEW" then
        self.data = ...
    end
end

function FileSelectBackground:draw()
    if self.data then
        self:drawSavePreview()
    else
        super.draw(self)
    end
end

function FileSelectBackground:drawSavePreview()
    love.graphics.print(Utils.dump(self.data))
    
end


return FileSelectBackground