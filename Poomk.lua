-- Coordinate UI + Copy
-- รองรับ executor ที่มี setclipboard()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "CoordinateUI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 125)
frame.Position = UDim2.new(0, 20, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(12, 9, 20)
frame.BackgroundTransparency = 0.08
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(150, 80, 255)
stroke.Thickness = 2
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 28)
title.Position = UDim2.new(0, 10, 0, 7)
title.BackgroundTransparency = 1
title.Text = "◈  PLAYER POSITION"
title.TextColor3 = Color3.fromRGB(190, 140, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local coords = Instance.new("TextLabel")
coords.Size = UDim2.new(1, -20, 0, 42)
coords.Position = UDim2.new(0, 10, 0, 36)
coords.BackgroundTransparency = 1
coords.Text = "X: 0.0   Y: 0.0   Z: 0.0"
coords.TextColor3 = Color3.fromRGB(235, 235, 245)
coords.Font = Enum.Font.GothamMedium
coords.TextSize = 14
coords.TextXAlignment = Enum.TextXAlignment.Left
coords.Parent = frame

local copy = Instance.new("TextButton")
copy.Size = UDim2.new(1, -20, 0, 34)
copy.Position = UDim2.new(0, 10, 1, -42)
copy.BackgroundColor3 = Color3.fromRGB(125, 65, 220)
copy.Text = "COPY COORDINATES"
copy.TextColor3 = Color3.fromRGB(255, 255, 255)
copy.Font = Enum.Font.GothamBold
copy.TextSize = 13
copy.BorderSizePixel = 0
copy.Parent = frame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 9)
copyCorner.Parent = copy

local function getPosition()
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        return nil
    end

    local p = root.Position

    return string.format(
        "X: %.1f | Y: %.1f | Z: %.1f",
        p.X, p.Y, p.Z
    )
end

task.spawn(function()
    while task.wait(0.05) do
        local position = getPosition()

        if position then
            coords.Text = position
        else
            coords.Text = "Waiting for character..."
        end
    end
end)

copy.MouseButton1Click:Connect(function()
    local position = getPosition()

    if not position then
        copy.Text = "POSITION NOT FOUND"
        task.wait(1)
        copy.Text = "COPY COORDINATES"
        return
    end

    if setclipboard then
        setclipboard(position)
        copy.Text = "✓ COPIED!"
    else
        copy.Text = "CLIPBOARD NOT SUPPORTED"
    end

    task.wait(1)
    copy.Text = "COPY COORDINATES"
end)
