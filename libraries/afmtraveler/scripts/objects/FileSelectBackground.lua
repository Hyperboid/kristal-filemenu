---@class FileSelectBackground : FileSelectBackground
---@field data SaveData?
local FileSelectBackground, super = Class("FileSelectBackground")

function FileSelectBackground:onStateChange(old,new, ...)
    if new == "FILESELECT" or new == "FILEPREVIEW" then
        self.visible = true
        if new == "FILESELECT" then
            self.data = nil
        end
    elseif new == "FILESTART" then
        self.visible = false
    end
    if new == "FILEPREVIEW" then
        self.data = ... or self.data
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
    -- TODO: undertale
    
end


return FileSelectBackground