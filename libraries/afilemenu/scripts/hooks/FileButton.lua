local FileButton, super = Class(FileButton)

-- if true then return FileButton end

function FileButton:drawCoolRectangle(x, y, w, h)
    if Game.world.map.menustyle == "DEVICE" then
        love.graphics.setLineWidth(1)
        love.graphics.setLineStyle("rough")
        -- Set the color
        Draw.setColor(self:getDrawColor())
        love.graphics.rectangle("line", x, y, w, h)
    else
        super.drawCoolRectangle(self, x, y, w, h)
    end
end

return FileButton