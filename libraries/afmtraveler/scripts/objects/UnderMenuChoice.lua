---@class UnderMenuChoice : GonerChoice
local UnderMenuChoice, super = Class(GonerChoice)

function UnderMenuChoice:init(x,y,choices,on_complete,on_select)
    super.init(self,x,y,choices,on_complete,on_select)
    self.state="CHOICE"
    self.alpha = 1
    self.shaky = false
    self.soul.visible = false
    self.selected_x = 1
    self.shake_rng = love.math.newRandomGenerator()
end

function UnderMenuChoice:moveSelection(...)
    super.moveSelection(self,...)
    Assets.stopAndPlaySound("ui_move")
end

function UnderMenuChoice:draw()
    Object.draw(self)

    love.graphics.setFont(self.font)
    for y, row in ipairs(self.choices) do
        for x, choice in ipairs(row) do
            love.graphics.push()
            local shaky = choice.shaky
            if shaky == nil then shaky = self.shaky end
            if shaky then
                love.graphics.translate(self.shake_rng:random(-1,1),0)
                love.graphics.translate(0,self.shake_rng:random(-1,1))
            end
            local text = self:getChoiceText(choice, x, y)

            local tx = (choice[2] or 0)
            local ty = (choice[3] or 0)

            if not self:isHidden(choice, x, y) then
                if self.selected_x == x and self.selected_y == y then
                    Draw.setColor(1, 1, 0, self.alpha)
                    love.graphics.print(text, tx, ty)
                else
                    Draw.setColor(1, 1, 1, self.alpha)
                    love.graphics.print(text, tx, ty)
                end
            end
            love.graphics.pop()
        end
    end
end

function UnderMenuChoice:finish(callback)

    local choice = self:getChoice(self.selected_x, self.selected_y)
    self.choice = choice[1]
    self.choice_x = self.selected_x
    self.choice_y = self.selected_y

    if callback then
        self.on_complete = callback
    end
    if self.on_complete then
        self.on_complete()
    end
    self:remove()
end

return UnderMenuChoice