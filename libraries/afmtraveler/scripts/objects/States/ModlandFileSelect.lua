---@class ModlandFileSelect : ModlandFileSelect
local ModlandFileSelect, super = Class("ModlandFileSelect")

function ModlandFileSelect:onSelectFile(button, slot)
    if button.data then
        self.menu:pushState("FILEPREVIEW", button, slot)
    else
        self.menu:pushState("FILESTART", button, slot)
    end
end

return ModlandFileSelect