---@class UnderMenuKeyboard : Object
---@overload fun(...) : UnderMenuKeyboard
local UnderMenuKeyboard, super = Class(Object)

-- For japanese support in the future maybe
UnderMenuKeyboard.MODES = {
    ["default"] = GonerKeyboard.MODES["lowercase"],
}

function UnderMenuKeyboard:init(limit, mode, callback, key_callback)
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

    self.limit = limit or -1
    self.mode = nil

    self.callback = callback
    self.key_callback = key_callback

    self.allow_empty = false

    self.choicer = UnderMenuChoice()
    self.choicer.shaky = true
    self.choicer:setSoulOffset(0, -4)
    self.choicer:setWrap(true)
    self.choicer.soul.alpha = 0.5
    self.choicer.soul_speed = 0.5
    self.choicer.teleport = true
    self.choicer.cancel_repeat = true
    self.choicer.on_select = function(choice, x, y)
        self:onSelect(choice, x, y)
        return false
    end
    self.choicer.on_cancel = function(choice, x, y)
        self:undoCharacter()
    end
    self.choicer.on_complete = function(choice, x, y)
        self:onComplete(self.text)
    end
    self:addChild(self.choicer)

    self:setMode(mode or "default")

    self.choicer:resetSoulPosition()

    self.font = Assets.getFont("main")

    self.text = ""
    self.fade_out = false
    self.done = false
end

function UnderMenuKeyboard:setMode(mode)
    if type(mode) == "string" then
        mode = UnderMenuKeyboard.MODES[mode]
    end

    -- Fill out defaults
    self.mode = Utils.copy(UnderMenuKeyboard.MODES["default"])
    Utils.merge(self.mode, mode)

    local choices = self:createKeyboardChoices(self.mode)
    self.choicer:setChoices(choices, 1, 1)
end

function UnderMenuKeyboard:createKeyboardChoices(mode)
    local key_choices = {}
    for y, row in ipairs(mode.keyboard) do
        local choice_row = {}
        table.insert(key_choices, choice_row)
        for x, key in ipairs(row) do
            local choice = {key, mode.x + (x - 1) * mode.step_x, mode.y + (y - 1) * mode.step_y}
            if (#key > 1) then choice.shaky = false end
            table.insert(choice_row, choice)
        end
    end
    return key_choices
end

function UnderMenuKeyboard:update()
    super.update(self)

    self.alpha = self.choicer.alpha
end

function UnderMenuKeyboard:onSelect(key, x, y)
    if self.key_callback then
        local result = self.key_callback(key, x, y, self)

        if result then
            return
        end
    end

    if key == "BACK" then
        self:undoCharacter()
    elseif key == "END" then
        self:finish()
    elseif #key > 1 then
        Kristal.Console:warn("Unknown command: " .. key)
    else
        self:addCharacter(key)
    end
end

function UnderMenuKeyboard:onComplete(text)
    if self.callback then
        self.callback(text, self)
    end
    self.done = true
    self:remove()
end

function UnderMenuKeyboard:undoCharacter()
    if #self.text > 0 then
        self.text = self.text:sub(1, #self.text - 1)
    end
end

function UnderMenuKeyboard:addCharacter(key)
    if self.limit < 0 or #self.text < self.limit then
        self.text = self.text .. key
    end
end

function UnderMenuKeyboard:finish()
    if self.fade_out then return end

    if self.allow_empty or self.text ~= "" then
        self.fade_out = true
        self.choicer:finish()
    end
end

function UnderMenuKeyboard:draw()
    super.draw(self)

    love.graphics.setFont(self.font)

    if self.limit >= 0 and #self.text >= self.limit then
        Draw.setColor(1, 1, 0, self.alpha)
    else
        Draw.setColor(1, 1, 1, self.alpha)
    end

    local w = self.font:getWidth(self.text)

    love.graphics.print(self.text, (SCREEN_WIDTH / 2) - (w / 2), self.mode.name_y)
end

function UnderMenuKeyboard:onAddToStage(stage)
    super.onAddToStage(self,stage)
    Input.clear("confirm")
end

return UnderMenuKeyboard