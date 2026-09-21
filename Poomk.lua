--// NONNOI MOBILE FLIGHT
--// Premium Mobile UI + Smooth Flight
--// Speed Default: 1000
--// Route Loop + Respawn Handling

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local CONFIG = {
    Speed = 1000,

    HoverTime = 5,

    Points = {
        Vector3.new(-53.2, 84.6, 817.5),
        Vector3.new(-48.9, 40.2, 8815.4),
        Vector3.new(-53.1, -355.8, 9482.5),
        Vector3.new(-55.5, -356.3, 9505.6),
    },

    HoverDistance = 1.5,

    UI = {
        Width = 300,
        Height = 285,
    }
}

--==================================================
-- STATE
--==================================================

local State = {
    Running = false,
    Destroyed = false,

    Cycle = 0,

    Character = nil,
    Humanoid = nil,
    Root = nil,

    Connections = {},

    FlightConnection = nil,
    CharacterConnection = nil,

    Speed = CONFIG.Speed,
}

--==================================================
-- CLEANUP CONNECTION
--==================================================

local function AddConnection(connection)
    if connection then
        table.insert(State.Connections, connection)
    end

    return connection
end

local function Disconnect(connection)
    if connection then
        pcall(function()
            connection:Disconnect()
        end)
    end
end

local function DisconnectAll()
    for _, connection in ipairs(State.Connections) do
        Disconnect(connection)
    end

    table.clear(State.Connections)

    Disconnect(State.FlightConnection)
    State.FlightConnection = nil

    Disconnect(State.CharacterConnection)
    State.CharacterConnection = nil
end

--==================================================
-- CHARACTER
--==================================================

local function GetCharacter()
    local character = LocalPlayer.Character

    if not character or not character.Parent then
        return nil
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not root then
        return nil
    end

    if humanoid.Health <= 0 then
        return nil
    end

    return character, humanoid, root
end

local function WaitForCharacter(cycle)
    while not State.Destroyed and State.Running and State.Cycle == cycle do
        local character, humanoid, root = GetCharacter()

        if character and humanoid and root then
            State.Character = character
            State.Humanoid = humanoid
            State.Root = root

            return character, humanoid, root
        end

        task.wait(0.15)
    end

    return nil
end

--==================================================
-- UI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NONNOI_MobileFlight"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(CONFIG.UI.Width, CONFIG.UI.Height)
Main.Position = UDim2.new(0.5, -150, 0.5, -142)
Main.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(139, 92, 246)
MainStroke.Transparency = 0.35
MainStroke.Thickness = 1.2
MainStroke.Parent = Main

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(17, 12, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 7, 13))
})
Gradient.Rotation = 90
Gradient.Parent = Main

--==================================================
-- HEADER
--==================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 54)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -110, 1, 0)
Title.Position = UDim2.fromOffset(16, 0)
Title.BackgroundTransparency = 1
Title.Text = "NONNOI  •  FLIGHT"
Title.TextColor3 = Color3.fromRGB(245, 240, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -110, 0, 16)
Subtitle.Position = UDim2.fromOffset(17, 30)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "MOBILE PREMIUM"
Subtitle.TextColor3 = Color3.fromRGB(145, 110, 220)
Subtitle.Font = Enum.Font.GothamMedium
Subtitle.TextSize = 9
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

-- Minimize

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(34, 34)
Minimize.Position = UDim2.new(1, -82, 0, 10)
Minimize.BackgroundColor3 = Color3.fromRGB(28, 21, 42)
Minimize.Text = "—"
Minimize.TextColor3 = Color3.fromRGB(230, 220, 255)
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 17
Minimize.AutoButtonColor = false
Minimize.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 9)
MinCorner.Parent = Minimize

--==================================================
-- STATUS
--==================================================

local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(1, -24, 0, 42)
StatusFrame.Position = UDim2.fromOffset(12, 58)
StatusFrame.BackgroundColor3 = Color3.fromRGB(18, 14, 28)
StatusFrame.BorderSizePixel = 0
StatusFrame.Parent = Main

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 10)
StatusCorner.Parent = StatusFrame

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.fromOffset(8, 8)
StatusDot.Position = UDim2.fromOffset(13, 17)
StatusDot.BackgroundColor3 = Color3.fromRGB(110, 90, 140)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusFrame

local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = StatusDot

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -35, 1, 0)
StatusText.Position = UDim2.fromOffset(29, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "พร้อมใช้งาน"
StatusText.TextColor3 = Color3.fromRGB(210, 205, 220)
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextSize = 12
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = StatusFrame

local function SetStatus(text, running)
    if State.Destroyed then
        return
    end

    StatusText.Text = text

    if running then
        StatusDot.BackgroundColor3 = Color3.fromRGB(120, 255, 170)
    else
        StatusDot.BackgroundColor3 = Color3.fromRGB(110, 90, 140)
    end
end

--==================================================
-- SPEED
--==================================================

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -24, 0, 20)
SpeedLabel.Position = UDim2.fromOffset(12, 108)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "FLIGHT SPEED"
SpeedLabel.TextColor3 = Color3.fromRGB(150, 140, 170)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 10
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = Main

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(1, -24, 0, 38)
SpeedBox.Position = UDim2.fromOffset(12, 129)
SpeedBox.BackgroundColor3 = Color3.fromRGB(22, 17, 34)
SpeedBox.BorderSizePixel = 0
SpeedBox.Text = tostring(State.Speed)
SpeedBox.PlaceholderText = "ความเร็ว"
SpeedBox.TextColor3 = Color3.fromRGB(240, 235, 250)
SpeedBox.PlaceholderColor3 = Color3.fromRGB(100, 90, 115)
SpeedBox.Font = Enum.Font.GothamBold
SpeedBox.TextSize = 13
SpeedBox.ClearTextOnFocus = false
SpeedBox.Parent = Main

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 9)
SpeedCorner.Parent = SpeedBox

local SpeedStroke = Instance.new("UIStroke")
SpeedStroke.Color = Color3.fromRGB(60, 45, 85)
SpeedStroke.Thickness = 1
SpeedStroke.Parent = SpeedBox

AddConnection(SpeedBox.FocusLost:Connect(function()
    local value = tonumber(SpeedBox.Text)

    if value then
        value = math.clamp(value, 50, 5000)

        State.Speed = value
        SpeedBox.Text = tostring(value)
    else
        SpeedBox.Text = tostring(State.Speed)
    end
end))

--==================================================
-- BUTTONS
--==================================================

local StartButton = Instance.new("TextButton")
StartButton.Size = UDim2.new(0.5, -18, 0, 40)
StartButton.Position = UDim2.fromOffset(12, 177)
StartButton.BackgroundColor3 = Color3.fromRGB(123, 78, 220)
StartButton.BorderSizePixel = 0
StartButton.Text = "START"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.Font = Enum.Font.GothamBold
StartButton.TextSize = 12
StartButton.AutoButtonColor = false
StartButton.Parent = Main

local StartCorner = Instance.new("UICorner")
StartCorner.CornerRadius = UDim.new(0, 10)
StartCorner.Parent = StartButton

local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(0.5, -18, 0, 40)
StopButton.Position = UDim2.new(0.5, 6, 0, 177)
StopButton.BackgroundColor3 = Color3.fromRGB(31, 24, 42)
StopButton.BorderSizePixel = 0
StopButton.Text = "STOP"
StopButton.TextColor3 = Color3.fromRGB(190, 180, 205)
StopButton.Font = Enum.Font.GothamBold
StopButton.TextSize = 12
StopButton.AutoButtonColor = false
StopButton.Parent = Main

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 10)
StopCorner.Parent = StopButton

--==================================================
-- MENU SECTION
--==================================================

local MenuTitle = Instance.new("TextLabel")
MenuTitle.Size = UDim2.new(1, -24, 0, 18)
MenuTitle.Position = UDim2.fromOffset(12, 224)
MenuTitle.BackgroundTransparency = 1
MenuTitle.Text = "MENU"
MenuTitle.TextColor3 = Color3.fromRGB(150, 140, 170)
MenuTitle.Font = Enum.Font.GothamBold
MenuTitle.TextSize = 10
MenuTitle.TextXAlignment = Enum.TextXAlignment.Left
MenuTitle.Parent = Main

local DeleteButton = Instance.new("TextButton")
DeleteButton.Size = UDim2.new(1, -24, 0, 30)
DeleteButton.Position = UDim2.fromOffset(12, 246)
DeleteButton.BackgroundColor3 = Color3.fromRGB(35, 19, 30)
DeleteButton.BorderSizePixel = 0
DeleteButton.Text = "ลบเมนู"
DeleteButton.TextColor3 = Color3.fromRGB(255, 130, 160)
DeleteButton.Font = Enum.Font.GothamBold
DeleteButton.TextSize = 11
DeleteButton.AutoButtonColor = false
DeleteButton.Parent = Main

local DeleteCorner = Instance.new("UICorner")
DeleteCorner.CornerRadius = UDim.new(0, 9)
DeleteCorner.Parent = DeleteButton

--==================================================
-- SMALL BUTTON
--==================================================

local SmallButton = Instance.new("TextButton")
SmallButton.Name = "SmallButton"
SmallButton.Size = UDim2.fromOffset(48, 48)
SmallButton.Position = Main.Position
SmallButton.BackgroundColor3 = Color3.fromRGB(19, 13, 31)
SmallButton.BorderSizePixel = 0
SmallButton.Text = "N"
SmallButton.TextColor3 = Color3.fromRGB(190, 140, 255)
SmallButton.Font = Enum.Font.GothamBlack
SmallButton.TextSize = 17
SmallButton.Visible = false
SmallButton.AutoButtonColor = false
SmallButton.Parent = ScreenGui

local SmallCorner = Instance.new("UICorner")
SmallCorner.CornerRadius = UDim.new(0, 12)
SmallCorner.Parent = SmallButton

local SmallStroke = Instance.new("UIStroke")
SmallStroke.Color = Color3.fromRGB(139, 92, 246)
SmallStroke.Thickness = 1.3
SmallStroke.Parent = SmallButton

--==================================================
-- DRAG SYSTEM
--==================================================

local function MakeDraggable(frame, handle)
    local dragging = false
    local dragStart
    local startPosition

    local inputChanged

    AddConnection(handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = frame.Position

            local changedConnection

            changedConnection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    Disconnect(changedConnection)
                end
            end)

            AddConnection(changedConnection)
        end
    end))

    AddConnection(UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end))
end

MakeDraggable(Main, Header)
MakeDraggable(SmallButton, SmallButton)

--==================================================
-- MINIMIZE
--==================================================

AddConnection(Minimize.MouseButton1Click:Connect(function()
    SmallButton.Position = Main.Position

    Main.Visible = false
    SmallButton.Visible = true
end))

AddConnection(SmallButton.MouseButton1Click:Connect(function()
    Main.Position = SmallButton.Position

    SmallButton.Visible = false
    Main.Visible = true
end))

--==================================================
-- FLIGHT MOVEMENT
--==================================================

local function StopFlightConnection()
    Disconnect(State.FlightConnection)
    State.FlightConnection = nil
end

local function MoveToPoint(root, target, cycle, pointNumber)
    if not root or not root.Parent then
        return false
    end

    SetStatus("กำลังไปจุดที่ " .. pointNumber, true)

    local finished = false
    local success = false

    StopFlightConnection()

    State.FlightConnection = RunService.Heartbeat:Connect(function(dt)
        if State.Destroyed
            or not State.Running
            or State.Cycle ~= cycle then

            finished = true
            success = false
            return
        end

        if not root.Parent then
            finished = true
            success = false
            return
        end

        local current = root.Position
        local offset = target - current
        local distance = offset.Magnitude

        if distance <= CONFIG.HoverDistance then
            root.AssemblyLinearVelocity = Vector3.zero
            finished = true
            success = true
            return
        end

        local direction = offset.Unit
        local step = math.min(State.Speed * dt, distance)

        local nextPosition = current + direction * step

        root.CFrame = CFrame.lookAt(
            nextPosition,
            nextPosition + direction
        )

        root.AssemblyLinearVelocity = Vector3.zero
    end)

    while not finished
        and not State.Destroyed
        and State.Running
        and State.Cycle == cycle do

        task.wait()
    end

    StopFlightConnection()

    return success
end

--==================================================
-- HOVER BETWEEN POINT 3 / 4
--==================================================

local function HoverBetweenPoints(root, cycle)
    if not root or not root.Parent then
        return false
    end

    SetStatus("กำลังวนระหว่างจุด 3 ↔ 4", true)

    local point3 = CONFIG.Points[3]
    local point4 = CONFIG.Points[4]

    local startTime = os.clock()
    local target = point3
    local success = true

    StopFlightConnection()

    State.FlightConnection = RunService.Heartbeat:Connect(function(dt)
        if State.Destroyed
            or not State.Running
            or State.Cycle ~= cycle then

            success = false
            return
        end

        if os.clock() - startTime >= CONFIG.HoverTime then
            return
        end

        if not root.Parent then
            success = false
            return
        end

        local current = root.Position
        local offset = target - current
        local distance = offset.Magnitude

        if distance <= CONFIG.HoverDistance then
            if target == point3 then
                target = point4
            else
                target = point3
            end

            return
        end

        local direction = offset.Unit
        local step = math.min(State.Speed * dt, distance)

        local nextPosition = current + direction * step

        root.CFrame = CFrame.lookAt(
            nextPosition,
            nextPosition + direction
        )

        root.AssemblyLinearVelocity = Vector3.zero
    end)

    while os.clock() - startTime < CONFIG.HoverTime
        and State.Running
        and not State.Destroyed
        and State.Cycle == cycle do

        task.wait(0.05)
    end

    StopFlightConnection()

    return success
end

--==================================================
-- RESPAWN
--==================================================

local function ResetCharacter(cycle)
    if not State.Running
        or State.Destroyed
        or State.Cycle ~= cycle then

        return false
    end

    SetStatus("รีเซ็ตตัวละคร...", true)

    local humanoid = State.Humanoid

    if humanoid and humanoid.Parent then
        pcall(function()
            humanoid.Health = 0
        end)
    end

    return true
end

--==================================================
-- ONE ROUTE
--==================================================

local function RunRoute(cycle)
    local character, humanoid, root = WaitForCharacter(cycle)

    if not character then
        return false
    end

    for index = 1, #CONFIG.Points do

        if not State.Running
            or State.Destroyed
            or State.Cycle ~= cycle then

            return false
        end

        -- ตรวจสอบ Character ปัจจุบัน
        if not character.Parent
            or not humanoid.Parent
            or humanoid.Health <= 0
            or not root.Parent then

            return false
        end

        local target = CONFIG.Points[index]

        local reached = MoveToPoint(
            root,
            target,
            cycle,
            index
        )

        if not reached then
            return false
        end

        -- จุด 4
        if index == 4 then

            local hovered = HoverBetweenPoints(
                root,
                cycle
            )

            if not hovered then
                return false
            end
        end
    end

    return ResetCharacter(cycle)
end

--==================================================
-- START SYSTEM
--==================================================

local function StartSystem()
    if State.Destroyed then
        return
    end

    -- ป้องกัน Start ซ้ำ
    if State.Running then
        return
    end

    State.Running = true
    State.Cycle += 1

    local myCycle = State.Cycle

    SetStatus("กำลังเตรียมตัวละคร...", true)

    task.spawn(function()

        while State.Running
            and not State.Destroyed
            and State.Cycle == myCycle do

            local routeFinished = RunRoute(myCycle)

            if not State.Running
                or State.Destroyed
                or State.Cycle ~= myCycle then

                break
            end

            if routeFinished then
     
