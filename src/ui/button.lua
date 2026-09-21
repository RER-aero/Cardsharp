local Button = {}
local FontRenderer = require("src.render.font_renderer")

function Button.new(text, x, y, width, height, image, quad, scalex, scaley)
    return {
        text = text,
        x = x,
        y = y,
        width = width,
        height = height,
        image = image,
        quad = quad,
        scalex = scalex,
        scaley = scaley
    }
end

function Button.draw(button)
    if button.image then
        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.draw(
            button.image,
            button.quad,
            button.x,
            button.y,
            0,
            button.scalex or 1,
            button.scaley or 1
        )
    else
        love.graphics.setColor(0.55, 0.30, 0.12, 1)

        love.graphics.rectangle(
            "fill",
            button.x,
            button.y,
            button.width,
            button.height
        )
    end

    love.graphics.setColor(1, 1, 1, 1)

    if button.text then
        local textScale = 4
        FontRenderer.print(
            button.text,
            button.x,
            button.y,
            textScale
        )
    end
end

function Button.isHovered(button, mouseX, mouseY)
    if not button then
        return false
    end
    return mouseX >= button.x
        and mouseX <= button.x + button.width
        and mouseY >= button.y
        and mouseY <= button.y + button.height
end

return Button