---@class ModlandFileSelect : MainMenuFileSelect
---@field menu FileSelectMenu
---@overload fun(menu: FileSelectMenu): ModlandFileSelect
local ModlandFileSelect, super = Class(MainMenuFileSelect)

function ModlandFileSelect:init(menu)
    super.init(self,menu)
end

function ModlandFileSelect:setState(state, result_text)
    self:setResultText(result_text)
    self.state = state
end

function ModlandFileSelect:onEnter()
    self.mod = Mod.info
    super.onEnter(self)
    self.bottom_row_heart = { 80, 250, 376 }
    self.bottom_options[2] = {false, {"config", "Config"}, false}
    self.bottom_options[1][3] = {"modlist", "Mod Select"}
    if Kristal.getLibConfig("afilemenu", "previousChapter") then
        self.bottom_options[2][1] = {"completion", self.menu.chapter_name.select}
    end
    if Kristal.getLibConfig("afilemenu", "chapterSelect") then
        self.bottom_options[2][3] = self.bottom_options[1][3]
        self.bottom_options[1][3] = {"chapters", "Chapter Select"}
    end
    if Game.world.map.menustyle == "DEVICE" then
        for _, row in ipairs(self.bottom_options) do
            for _, col in ipairs(row) do
                if col then
                    col[2] = col[2]:upper()
                end
            end
        end
    end
    self.threat = 0
end

function ModlandFileSelect:onLeave()
    -- self.menu:removeChild(self.container)
    self.container:remove()
    self.container = nil
end

-- function ModlandFileSelect:onKeyPressed(key, is_repeat)
-- end

function ModlandFileSelect:update()
    if self.result_timer > 0 then
        self.result_timer = Utils.approach(self.result_timer, 0, DT)
        if self.result_timer == 0 then
            self.result_text = nil
        end
    end

    self:updateSelected()

    self.menu.heart_target_x, self.menu.heart_target_y = self:getHeartPos()
end

function ModlandFileSelect:drawHeader()
    local mod_name = string.upper(self.mod.chaptername or self.mod.name or self.mod.id)
    if Game.world.map.menustyle == "DEVICE" then
        Draw.setColor(0,.5,0)
    else
        Draw.setColor(1,1,1)
    end
    Draw.printShadow(mod_name, 16, 8)

    if Game.world.map.menustyle == "DEVICE" then
        Draw.setColor(0,1,0)
    end

    Draw.printShadow(self:getTitle(), 80, 60)

end

function ModlandFileSelect:getSelectedFile()
    return self.files[self.selected_y]
end

function ModlandFileSelect:updateSelected()
    for i, file in ipairs(self.files) do
        if i == self.selected_y or (self.state == "COPY" and self.copied_button == file) then
            file.selected = true
        else
            file.selected = false
        end
    end
end

function ModlandFileSelect:getText(string)
    string = super.getText(self,string)
    if type(string) ~= "string" then return string end
    if Game.world.map.menustyle ~= "DEVICE" then
        return string
    end
    local gtable = {
        ["Please select a file."] = "",
        ["Choose a file to copy."] = "CHOOSE THE ONE TO COPY.",
        ["Choose a file to copy to."] = "CHOOSE THE TARGET FOR THE REFLECTION.",
        ["Choose a file to erase."] = "CHOOSE THE ONE TO ERASE.",
        ["You can't copy there."] = "IT IS IMMUNE TO ITS OWN IMAGE.",
        ["Start"] = "BEGIN",
        ["Cancel"] = "        CANCEL"
    }
    return gtable[string] or gtable[string:upper()] or string:upper()
end

function ModlandFileSelect:processExtraButton(id)
    if id == "config" then
        self.menu:pushState("OPTIONS")
    elseif id == "chapters" then
        Game.fader:fadeOut(function ()
            self:swapIntoMod(Kristal.getLibConfig("afilemenu", "chapterSelect"))
        end, {speed = 0.5, music = 10/30})
        Game.state = "EXIT"
    elseif id == "modlist" then
        Game:returnToMenu()
    elseif id == "completion" then
        self.menu:pushState("COMPLETION")
    else
        super.processExtraButton(self,id)
    end
end

function ModlandFileSelect:swapIntoMod(mod)
    Gamestate.switch({})
    -- Clear the mod
    Kristal.clearModState()

    -- Reload mods and return to memu
    Kristal.loadAssets("", "mods", "", function ()
        Kristal.loadMod(mod)
    end)

    Kristal.DebugSystem:refresh()
    -- End input if it's open
    if not Kristal.Console.is_open then
        TextInput.endInput()
    end
end

return ModlandFileSelect