---@class ModlandOptions : MainMenuOptions
local ModlandOptions, super = Class(MainMenuOptions)

function ModlandOptions:onKeyPressed(key)
    if Input.isCancel(key) then
        Assets.stopAndPlaySound("ui_move")
        Kristal.saveConfig()
        self.menu:popState()
        return
    end
    local page = self.pages[self.selected_page]
    local options = self.options[page].options
    local max_option = #options + 1
    if Input.isConfirm(key) then
        Assets.stopAndPlaySound("ui_select")

        if self.selected_option == max_option then
            -- "Back" button
            Kristal.saveConfig()
            self.menu:popState()
            return
        end
    end
    super.onKeyPressed(self,key)
end

function ModlandOptions:draw()
    local canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
    super.draw(self)
    Draw.popCanvas()

    Draw.setColor(PALETTE["filemenu_settings"])
    Draw.draw(canvas, 0, 0)
end

return ModlandOptions