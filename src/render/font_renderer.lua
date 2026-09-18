
local FontRenderer = {}

local fontSheet = love.graphics.newImage("assets/ui/font.png")

local characters = {
    "A", "B", "C", "D", "E", "F", "G", "H",
    "I", "J", "K", "L", "M", "N", "O", "P",

    "Q", "R", "S", "T", "U", "V", "W", "X",
    "Y", "Z", ".", "!", "?", ":", ";", "'",

    "/", "\\", "-", "|", "1", "2", "3", "4", "5",
    "6", "7", "8", "9", "0", ",", "$"
}

local quads = {}

for i, character in ipairs(characters) do
    local index = i - 1
    local column = index % 16
    local row = math.floor(index / 16)

    quads[character] = love.graphics.newQuad(
        column * 8,
        row * 11,
        8,
        11,
        fontSheet:getWidth(),
        fontSheet:getHeight()
    )
end
local function wrapText(text, maxCharacters)
    if not maxCharacters then
        return { text }
    end

    local lines = {}

    for paragraph in text:gmatch("[^\n]+") do
        local currentLine = ""

        for word in paragraph:gmatch("%S+") do
            local testLine

            if currentLine == "" then
                testLine = word
            else
                testLine = currentLine .. " " .. word
            end

            if #testLine > maxCharacters and currentLine ~= "" then
                table.insert(lines, currentLine)
                currentLine = word
            else
                currentLine = testLine
            end
        end

        if currentLine ~= "" then
            table.insert(lines, currentLine)
        end
    end

    return lines
end
function FontRenderer.print(t, x, y, scale, spacing, maxCharacters)
local text = t:upper()
    scale = scale or 1
    spacing = spacing or 0

    local lines

    if maxCharacters then
        lines = wrapText(text, maxCharacters)
    else
        lines = {}
        for line in text:gmatch("[^\n]*") do
            table.insert(lines, line)
        end
    end

    local lineHeight = 11 * scale

    for lineIndex, line in ipairs(lines) do
        for i = 1, #line do
            local character = line:sub(i, i)
            local quad = quads[character]

            if quad then
                love.graphics.draw(
                    fontSheet,
                    quad,
                    x + (i - 1) * (8 + spacing) * scale,
                    y + (lineIndex - 1) * lineHeight,
                    0,
                    scale,
                    scale
                )
            end
        end
    end
end
return FontRenderer