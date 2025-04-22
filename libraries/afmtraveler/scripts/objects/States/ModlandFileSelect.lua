---@class ModlandFileSelect : ModlandFileSelect
local ModlandFileSelect, super = Class("ModlandFileSelect")

function ModlandFileSelect:onSelectFile(button, slot)
    if button.data then
        self.menu:pushState("FILEPREVIEW", button.data, slot)
    else
        self.menu:pushState("FILESTART", button.data, slot)
    end
end

return ModlandFileSelect