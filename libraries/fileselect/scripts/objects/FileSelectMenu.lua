---@class FileSelectMenu: Object
local FileSelectMenu, super = Class(Object)

function FileSelectMenu:init()
    super.init(self)
    self.state_manager = StateManager("", self, true)
    self.file_select = ModlandFileSelect(self)
    self.file_namer = ModlandFileNamer(self)
    self.state_manager:addState("FILESELECT", self.file_select)
    self.state_manager:addState("FILENAME", self.file_namer)
    self.font = Assets.getFont("main")
    
    self.heart = Sprite("player/heart_menu")
    self.heart.visible = true
    self.heart:setOrigin(0.5, 0.5)
    self.heart:setScale(2, 2)
    self.heart:setColor(Kristal.getSoulColor())
    self.heart.layer = 100
    self:addChild(self.heart)
end

function FileSelectMenu:onAddToStage()
    -- self.state_manager:setState("FILESELECT")
    self.state_manager:setState("FILESELECT")
end

function FileSelectMenu:draw()
    love.graphics.setFont(self.font)
    super.draw(self)
    self.file_select.mod = self.file_select.mod or Mod.info
    self.state_manager:draw()
end

function FileSelectMenu:update()
    super.update(self)
    self.state_manager:update()
    if self.heart.visible then
        if (math.abs((self.heart_target_x - self.heart.x)) <= 2) then
            self.heart.x = self.heart_target_x
        end
        if (math.abs((self.heart_target_y - self.heart.y)) <= 2) then
            self.heart.y = self.heart_target_y
        end
        self.heart.x = self.heart.x + ((self.heart_target_x - self.heart.x) / 2) * DTMULT
        self.heart.y = self.heart.y + ((self.heart_target_y - self.heart.y) / 2) * DTMULT
    end
end

function FileSelectMenu:loadGame(id)
    local path = "saves/" .. Mod.info.id .. "/file_" .. id .. ".json"
    local fade = true
    if love.filesystem.getInfo(path) then
        local data = JSON.decode(love.filesystem.read(path))
        Game:load(data, id, fade)
    else
        Game:load(nil, id, fade)
    end
end

function FileSelectMenu:onKeyPressed(key, is_repeat)
    self.state_manager:call("keypressed", key, is_repeat)
end

function FileSelectMenu:onKeyReleased(key)
    self.state_manager:call("keyreleased", key)
end

return FileSelectMenu