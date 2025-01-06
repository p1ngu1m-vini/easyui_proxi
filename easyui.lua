EasyUI = { buttons = {} }

function EasyUI:createButton(properties)
    local button = {
        x = properties.x or 0,
        y = properties.y or 0,
        width = properties.width or 100,
        height = properties.height or 50,
        text = properties.text or "Button",
        bgColor = properties.bgColor or tocolor(50, 50, 50, 200),
        hoverColor = properties.hoverColor or tocolor(70, 70, 70, 200),
        textColor = properties.textColor or tocolor(255, 255, 255, 255),
        borderRadius = properties.borderRadius or 5,
        onClick = properties.onClick,
        onMouseEnter = properties.onMouseEnter,
        onMouseLeave = properties.onMouseLeave,
        disabled = properties.disabled or false,
        alpha = properties.alpha or 255,
        pressColor = properties.pressColor or tocolor(30, 30, 30, 200),
        shadowColor = properties.shadowColor or tocolor(0, 0, 0, 100),
        isHovered = false,
        isPressed = false,
        isLoading = properties.isLoading or false,
        loadingColor = properties.loadingColor or tocolor(255, 215, 0, 200),
        icon = properties.icon or nil,
    }

    table.insert(self.buttons, button)
end

function EasyUI:render()
    local mx, my = getCursorPosition()
    if mx and my then
        local screenWidth, screenHeight = guiGetScreenSize()
        mx, my = mx * screenWidth, my * screenHeight
    end

    for _, button in ipairs(self.buttons) do
        if not button.disabled then
            button.isHovered = mx >= button.x and mx <= button.x + button.width and my >= button.y and my <= button.y + button.height

            local currentColor = button.isPressed and button.pressColor or (button.isHovered and button.hoverColor or button.bgColor)
            if button.isLoading then
                currentColor = button.loadingColor
            end

            if button.isHovered then
                dxDrawRectangle(button.x + 2, button.y + 2, button.width, button.height, button.shadowColor)
            end

            dxDrawRectangle(button.x, button.y, button.width, button.height, currentColor, true, true, button.borderRadius)

            if button.icon then
                dxDrawImage(button.x + button.width / 2 - 16, button.y + button.height / 2 - 16, 32, 32, button.icon)
            end
            dxDrawText(button.text, button.x, button.y, button.x + button.width, button.y + button.height, button.textColor, 1.5, "default-bold", "center", "center")
        end
    end
end

function EasyUI:handleClick(button, state)
    if button == "left" then
        local mx, my = getCursorPosition()
        if mx and my then
            local screenWidth, screenHeight = guiGetScreenSize()
            mx, my = mx * screenWidth, my * screenHeight

            for _, btn in ipairs(self.buttons) do
                if not btn.disabled and mx >= btn.x and mx <= btn.x + btn.width and my >= btn.y and my <= btn.y + btn.height then
                    if state == "down" then
                        btn.isPressed = true
                        if btn.onClick then btn.onClick() end
                    elseif state == "up" then
                        btn.isPressed = false
                    end
                end
            end
        end
    end
end

function EasyUI:disableButton(index)
    if self.buttons[index] then self.buttons[index].disabled = true end
end

function EasyUI:enableButton(index)
    if self.buttons[index] then self.buttons[index].disabled = false end
end

function EasyUI:setLoading(index, state)
    if self.buttons[index] then
        self.buttons[index].isLoading = state
    end
end

function EasyUI:triggerMouseEnter(index)
    if self.buttons[index] and self.buttons[index].onMouseEnter then
        self.buttons[index].onMouseEnter()
    end
end

function EasyUI:triggerMouseLeave(index)
    if self.buttons[index] and self.buttons[index].onMouseLeave then
        self.buttons[index].onMouseLeave()
    end
end