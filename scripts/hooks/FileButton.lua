local FileButton, super = Class(FileButton)

function FileButton:getDrawColor()
    local copy = self.color[3] < 0.7 -- TODO: detect better
    local delete = Utils.equal(self.color, {1, 0, 0})
    if delete then
        return Utils.unpackColor{1,0,0}
    end
    if copy then return PALETTE["filemenu_copy"] end
    if self.selected then
        return PALETTE["filemenu_selected"]
    end
    return PALETTE["filemenu_deselected"]
    -- return Utils.unpackColor{ 0, 0.5, 0 }
    -- return super.super.getDrawColor(self)
end

return FileButton
