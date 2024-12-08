local MFileButton, super = Class(Object)

function MFileButton:init(data, x,y)
    super.init(self,x,y, 422,82)
    self.font = Assets.getFont("main")
    data = data or {}
    self.name = data.name or "[EMPTY]"
    self.time = data.playtime or "--:--"
    self.area = data.room_name or "------------"
end

function MFileButton:getDrawColor()
    if Game.world.map.menustyle == "DEVICE" then
        if self.selected then
            return Utils.unpackColor{ 0, 1, 0 }
        end
        return Utils.unpackColor{ 0, 0.5, 0 }
    end
    return super.getDrawColor(self)
end

function MFileButton:draw()
    love.graphics.setFont(self.font)
    -- Draw the transparent background
    Draw.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, self.width, self.height)

    -- Draw the rectangle outline
    Draw.setColor(self:getDrawColor())
    Draw.coolRectangle(0, 0, self.width, self.height)

    -- Draw text inside the button rectangle
    Draw.pushScissor()
    Draw.scissor(0, 0, self.width, self.height)

    if not self.prompt then
        -- Draw the name shadow
        Draw.setColor(0, 0, 0)
        love.graphics.print(self.name, 50 + 2, 10 + 2)
        -- Draw the name
        Draw.setColor(self:getDrawColor())
        love.graphics.print(self.name, 50, 10)

        -- Draw the time shadow
        local time_x = self.width-64-self.font:getWidth(self.time) + 2
        Draw.setColor(0, 0, 0)
        love.graphics.print(self.time, time_x + 2, 10 + 2)
        -- Draw the time
        Draw.setColor(self:getDrawColor())
        love.graphics.print(self.time, time_x, 10)
    else
        -- Draw the prompt shadow
        Draw.setColor(0, 0, 0)
        love.graphics.print(self.prompt, 50 + 2, 10 + 2)
        -- Draw the prompt
        Draw.setColor(self:getDrawColor())
        love.graphics.print(self.prompt, 50, 10)
    end

    if not self.choices then
        -- Draw the area shadow
        Draw.setColor(0, 0, 0)
        love.graphics.print(self.area, 50 + 2, 44 + 2)
        -- Draw the area
        Draw.setColor(self:getDrawColor())
        love.graphics.print(self.area, 50, 44)
    else
        -- Draw the shadow for choice 1
        Draw.setColor(0, 0, 0)
        love.graphics.print(self.choices[1], 70+2, 44+2)
        -- Draw choice 1
        if self.selected_choice == 1 then
            Draw.setColor(1, 1, 1)
        else
            Draw.setColor(PALETTE["filemenu_deselected"])
        end
        love.graphics.print(self.choices[1], 70, 44)

        -- Draw the shadow for choice 2
        Draw.setColor(0, 0, 0)
        love.graphics.print(self.choices[2], 250+2, 44+2)
        -- Draw choice 2
        if self.selected_choice == 2 then
            Draw.setColor(1, 1, 1)
        else
            Draw.setColor(PALETTE["filemenu_deselected"])
        end
        love.graphics.print(self.choices[2], 250, 44)
    end

    Draw.popScissor()
end

return MFileButton