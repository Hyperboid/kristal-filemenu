---@class ModlandFilePreview : StateClass
---@field menu FileSelectMenu
---@field data SaveData
---@overload fun(menu: FileSelectMenu): ModlandFilePreview
local ModlandFilePreview, super = Class(StateClass)

function ModlandFilePreview:init(menu)
    self.menu = menu
    self.font = Assets.getFont("main")
end

function ModlandFilePreview:registerEvents()
    self:registerEvent("enter", self.onEnter)
    self:registerEvent("leave", self.onLeave)
    self:registerEvent("pause", self.onPause)
    self:registerEvent("resume", self.onResume)
    self:registerEvent("keypressed", self.onKeyPressed)
    self:registerEvent("update", self.update)
    self:registerEvent("draw", self.draw)
end

function ModlandFilePreview:onKeyPressed(key)
    if Input.isCancel(key) and #self.menu.state_manager.state_stack > 0 then
        Assets.playSound("ui_cancel")
        self.menu:popState()
    elseif Input.isConfirm(key) then
        Assets.playSound("ui_select")
        if self.selected_x == 1 and self.selected_y == 1 then
            self:enterGame()
        elseif self.selected_x == 2 and self.selected_y == 1 then
            self.menu:pushState("FILENAME")
        end
    elseif Input.is(key,"left") then
        self.selected_x = Utils.clampWrap(self.selected_x - 1, 1, 2)
        if self.selected_y == 1 then Assets.playSound("ui_move") end
    elseif Input.is(key,"right") then
        self.selected_x = Utils.clampWrap(self.selected_x + 1, 1, 2)
        if self.selected_y == 1 then Assets.playSound("ui_move") end
    elseif Input.is(key,"up") then
        Assets.playSound("ui_move")
        self.selected_y = Utils.clampWrap(self.selected_y - 1, 1, 2)
    elseif Input.is(key,"down") then
        Assets.playSound("ui_move")
        self.selected_y = Utils.clampWrap(self.selected_y + 1, 1, 2)
    end
end

function ModlandFilePreview:draw()
    love.graphics.print(self.data.name, 140, 125)
    love.graphics.print(self.data.room_name, 140, 160)

    local hours = math.floor(self.data.playtime / 3600)
    local minutes = math.floor(self.data.playtime / 60 % 60)
    local seconds = math.floor(self.data.playtime % 60)
    local time_text = string.format("%d:%02d:%02d", hours, minutes, seconds)
    love.graphics.print(time_text, 500 - self.font:getWidth(time_text), 124)
    Draw.setColor(self.selected_x == 1 and self.selected_y == 1 and COLORS.yellow or COLORS.white)
    love.graphics.print("Continue",170,210)
    Draw.setColor(self.selected_x == 2 and self.selected_y == 1 and COLORS.yellow or COLORS.white)
    love.graphics.print("Reset", 390, 210)
    Draw.setColor(self.selected_y == 2 and COLORS.yellow or COLORS.white)
    love.graphics.print("Settings", 264, 250)

    -- if Assets.getTexture("utref") then
    --     Draw.setColor(COLORS.white(Utils.clampMap(math.sin(RUNTIME*math.pi*.5), -1,1,0.2,.8)))
    --     Draw.draw(Assets.getTexture("utref"))
    -- end
end

function ModlandFilePreview:onResume()
    self.menu.heart.visible = false
end

function ModlandFilePreview:onPause()
    self.menu.heart.visible = true
end

---@param data SaveData
---@param slot integer
function ModlandFilePreview:onEnter(_, data, slot)
    self.selected_x = 1
    self.selected_y = 1
    self.data = data
    self.slot = slot
    self:onResume()
    local music = self:getMusic()
    self.resume_music = false
    self.music = Music()
    if music and music ~= Game.world.music.current then
        self.resume_music = Game.world.music:isPlaying()
        Game.world.music:pause()
        self.music:play(music)
    end
end

function ModlandFilePreview:enterGame()
    self.music:remove()
    if self.data then
        Game:load(self.data, self.slot, true)
    else
        Game.playtime = 0
        Game.save_id = self.menu.file_select.selected_y
        Game.save_name = Game.save_name
        Game.world:loadMap(Kristal.getLibConfig("afilemenu", "map"))
    end
    Kristal.callEvent("afmPostInit", not self.data)
end

function ModlandFilePreview:getMusic()
    if self.data and self.data.flags and (self.data.flags.menu_music ~= nil) then
        return self.data.flags.menu_music
    end
    return nil
end

function ModlandFilePreview:onLeave()
    self:onPause()
    self.music:remove()
    if self.resume_music then
        Game.world.music:resume()
    end
end

return ModlandFilePreview