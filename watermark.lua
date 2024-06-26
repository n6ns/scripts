--[[
    jewblaster / 1002714043808755782 / github.com/n6ns
    https://tenor.com/view/paste-pasted-gif-24644317
]]

local rs = game:GetService("RunService")
local viewport = workspace.CurrentCamera.ViewportSize

local watermark = {
    accent = Color3.fromRGB(55, 175, 225),
    outline = Color3.fromRGB(50, 50, 50),
    inline = Color3.fromRGB(20, 20, 20),
    textcolor = Color3.fromRGB(255, 255, 255),
    textborder = Color3.fromRGB(0, 0, 0),
    text = "$$$ crimdeaglehaxx $$$ | ping: %d | fps: %d",
    visible = true,
    font = 3,
    textsize = 12,
    position = "topleft", -- topleft topright bottomleft bottomright
}

local function createDrawing(type, props)
    local obj = Drawing.new(type)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

local watermark_text = createDrawing("Text", {
    Font = watermark.font,
    Size = watermark.textsize,
    Outline = true,
    Color = watermark.textcolor,
    OutlineColor = watermark.textborder,
    ZIndex = 61,
    Visible = watermark.visible
})

local elements = {
    createDrawing("Square", {
        Filled = true,
        ZIndex = 60,
        Color = watermark.inline,
        Visible = watermark.visible
    }),
    createDrawing("Square", {
        Filled = true,
        ZIndex = 61,
        Color = watermark.accent,
        Visible = watermark.visible
    }),
    createDrawing("Square", {
        Thickness = 1,
        Filled = false,
        ZIndex = 59,
        Color = watermark.outline,
        Visible = watermark.visible
    })
}

local function calculatePosition(size)
    local position
    if typeof(watermark.position) == "Vector2" then
        position = watermark.position
    else
        local x, y
        if watermark.position:find("right") then
            x = viewport.X - size.X - 15
        else
            x = 15
        end
        if watermark.position:find("bottom") then
            y = viewport.Y - size.Y - 15
        else
            y = 15
        end
        position = Vector2.new(x, y)
    end
    return position
end

local function updatePosition(size)
    local position = calculatePosition(size)
    watermark_text.Position = position + Vector2.new(4, 3)
    for _, elem in ipairs(elements) do elem.Position = position end
end

local function updateSize()
    local textBoundsX = watermark_text.TextBounds.X
    local size = Vector2.new(textBoundsX + 7, 18)
    elements[1].Size = size
    elements[2].Size = Vector2.new(size.X, 2)
    elements[3].Size = size
    return size
end

local fps = 0
local lastTime = tick()
local frameCount = 0

rs.RenderStepped:Connect(function()
    local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())

    frameCount = frameCount + 1
    local currentTime = tick()
    local deltaTime = currentTime - lastTime
    if deltaTime >= 0.5 then
        fps = math.floor(frameCount / deltaTime)
        frameCount = 0
        lastTime = currentTime
    end

    watermark_text.Text = string.format(watermark.text, ping, fps)
    local size = updateSize()
    updatePosition(size)
end)

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    viewport = workspace.CurrentCamera.ViewportSize
    local size = updateSize()
    updatePosition(size)
end)
