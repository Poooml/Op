local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local CONFIG = {
    Speed = 1000,
    LoopTime = 11,
    Waypoints = {
        Vector3.new(-53.2, 84.6, 817.5),
        Vector3.new(-48.9, 40.2, 8815.4),
        Vector3.new(-53.1, -355.8, 9482.5),
        Vector3.new(-55.5, -356.3, 9505.6)
    }
}

local Running = false
local Generation = 0
local Dragging = false
local DragStart
local StartPosition

local OldGui = PlayerGui:FindFirstChild("PremiumFlyUI")
if OldGui then
    OldGui:Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "PremiumFlyUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(290, 390)
Main.Position = UDim2.new(0, 18, 0.5, -195)
Main.BackgroundColor3 = Color3.fromRGB(12, 13, 20)
Main.BackgroundTransparency = 0.04
Main.BorderSizePixel = 0
Main.Parent = Gui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(105, 125, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.2
MainStroke.Parent = Main

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 27, 43)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 16, 27)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 10, 16))
})
MainGradient.Rotation = 90
MainGradient.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, -20, 0, 62)
Header.Position = UDim2.fromOffset(10, 8)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Icon = Instance.new("TextLabel")
Icon.Size = UDim2.fromOffset(42, 42)
Icon.Position = UDim2.fromOffset(2, 8)
Icon.BackgroundColor3 = Color3.fromRGB(65, 75, 190)
Icon.Text = "✈"
Icon.TextColor3 = Color3.fromRGB(255, 255, 255)
Icon.Font = Enum.Font.GothamBold
Icon.TextSize = 21
Icon.Parent = Header

Instance.new("UICorner", Icon).CornerRadius = UDim.new(0, 12)

local IconGradient = Instance.new("UIGradient")
IconGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(95, 115, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(65, 45, 170))
})
IconGradient.Rotation = 45
IconGradient.Parent = Icon

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -125, 0, 25)
Title.Position = UDim2.fromOffset(54, 6)
Title.BackgroundTransparency = 1
Title.Text = "PREMIUM FLY"
Title.TextColor3 = Color3.fromRGB(245, 247, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -125, 0, 20)
Subtitle.Position = UDim2.fromOffset(54, 31)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "MOBILE FLIGHT CONTROL"
Subtitle.TextColor3 = Color3.fromRGB(130, 140, 175)
Subtitle.Font = Enum.Font.GothamMedium
Subtitle.TextSize = 9
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.fromOffset(34, 34)
MinButton.Position = UDim2.new(1, -70, 0, 10)
MinButton.BackgroundColor3 = Color3.fromRGB(35, 37, 53)
MinButton.Text = "−"
MinButton.TextColor3 = Color3.fromRGB(220, 225, 255)
MinButton.Font = Enum.Font.GothamBold
MinButton.TextSize = 19
MinButton.AutoButtonColor = false
MinButton.Parent = Header

Instance.new("UICorner", MinButton).CornerRadius = UDim.new(0, 10)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(34, 34)
CloseButton.Position = UDim2.new(1, -32, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(62, 30, 43)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 190, 205)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 19
CloseButton.AutoButtonColor = false
CloseButton.Parent = Header

Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 10)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -24, 1, -82)
Content.Position = UDim2.fromOffset(12, 76)
Content.BackgroundTransparency = 1
Content.Parent = Main

local function CreateLabel(text, y)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Position = UDim2.fromOffset(0, y)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(175, 183, 210)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Content
    return Label
end

local function CreateBox(y, value, accent)
    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(1, 0, 0, 42)
    Box.Position = UDim2.fromOffset(0, y)
    Box.BackgroundColor3 = Color3.fromRGB(25, 27, 40)
    Box.BorderSizePixel = 0
    Box.Text = tostring(value)
    Box.TextColor3 = Color3.fromRGB(240, 243, 255)
    Box.PlaceholderColor3 = Color3.fromRGB(100, 105, 125)
    Box.Font = Enum.Font.GothamBold
    Box.TextSize = 14
    Box.ClearTextOnFocus = false
    Box.Parent = Content

    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 11)

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = accent
    Stroke.Thickness = 1
    Stroke.Transparency = 0.45
    Stroke.Parent = Box

    return Box
end

CreateLabel("⚡  FLIGHT SPEED", 0)
local SpeedBox = CreateBox(23, CONFIG.Speed, Color3.fromRGB(90, 125, 255))

CreateLabel("🔄  LOOP TIME", 78)
local LoopBox = CreateBox(101, CONFIG.LoopTime, Color3.fromRGB(170, 105, 255))

local Hint = Instance.new("TextLabel")
Hint.Size = UDim2.new(1, 0, 0, 18)
Hint.Position = UDim2.fromOffset(0, 146)
Hint.BackgroundTransparency = 1
Hint.Text = "ปรับค่าได้ตามต้องการ • วินาที"
Hint.TextColor3 = Color3.fromRGB(105, 112, 140)
Hint.Font = Enum.Font.Gotham
Hint.TextSize = 10
Hint.TextXAlignment = Enum.TextXAlignment.Left
Hint.Parent = Content

CreateLabel("●  STATUS", 171)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 42)
Status.Position = UDim2.fromOffset(0, 195)
Status.BackgroundColor3 = Color3.fromRGB(22, 24, 35)
Status.BorderSizePixel = 0
Status.Text = "READY"
Status.TextColor3 = Color3.fromRGB(145, 190, 255)
Status.Font = Enum.Font.GothamBold
Status.TextSize = 12
Status.Parent = Content

Instance.new("UICorner", Status).CornerRadius = UDim.new(0, 11)

local StartButton = Instance.new("TextButton")
StartButton.Size = UDim2.new(0.49, -4, 0, 43)
StartButton.Position = UDim2.fromOffset(0, 248)
StartButton.BackgroundColor3 = Color3.fromRGB(38, 150, 91)
StartButton.BorderSizePixel = 0
StartButton.Text = "▶  START"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.Font = Enum.Font.GothamBold
StartButton.TextSize = 13
StartButton.AutoButtonColor = false
StartButton.Parent = Content

Instance.new("UICorner", StartButton).CornerRadius = UDim.new(0, 11)

local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(0.49, -4, 0, 43)
StopButton.Position = UDim2.new(0.51, 4, 0, 248)
StopButton.BackgroundColor3 = Color3.fromRGB(170, 52, 67)
StopButton.BorderSizePixel = 0
StopButton.Text = "■  STOP"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.Font = Enum.Font.GothamBold
StopButton.TextSize = 13
StopButton.AutoButtonColor = false
StopButton.Parent = Content

Instance.new("UICorner", StopButton).CornerRadius = UDim.new(0, 11)

local DeleteButton = Instance.new("TextButton")
DeleteButton.Size = UDim2.new(1, 0, 0, 38)
DeleteButton.Position = UDim2.fromOffset(0, 300)
DeleteButton.BackgroundColor3 = Color3.fromRGB(42, 29, 38)
DeleteButton.BorderSizePixel = 0
DeleteButton.Text = "REMOVE MENU"
DeleteButton.TextColor3 = Color3.fromRGB(225, 155, 170)
DeleteButton.Font = Enum.Font.GothamBold
DeleteButton.TextSize = 11
DeleteButton.AutoButtonColor = false
DeleteButton.Parent = Content

Instance.new("UICorner", DeleteButton).CornerRadius = UDim.new(0, 10)

local MiniButton = Instance.new("TextButton")
MiniButton.Size = UDim2.fromOffset(58, 58)
MiniButton.Position = UDim2.new(0, 18, 0.5, -29)
MiniButton.BackgroundColor3 = Color3.fromRGB(50, 65, 175)
MiniButton.BorderSizePixel = 0
MiniButton.Text = "✈"
MiniButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniButton.Font = Enum.Font.GothamBold
MiniButton.TextSize = 25
MiniButton.AutoButtonColor = false
MiniButton.Visible = false
MiniButton.Parent = Gui

Instance.new("UICorner", MiniButton).CornerRadius = UDim.new(0, 17)

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(125, 150, 255)
MiniStroke.Thickness = 1.5
MiniStroke.Parent = MiniButton

local function SetStatus(text, color)
    Status.Text = text
    Status.TextColor3 = color
end

local function GetCharacter()
    local Character = Player.Character
    if not Character then
        return nil, nil
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local Root = Character:FindFirstChild("HumanoidRootPart")

    if Humanoid and Root and Humanoid.Health > 0 then
        return Humanoid, Root
    end

    return nil, nil
end

local function Freeze(Root)
    if Root then
        Root.AssemblyLinearVelocity = Vector3.zero
        Root.AssemblyAngularVelocity = Vector3.zero
    end
end

local function MoveTo(Root, Target, Gen)
    while Running and Generation == Gen do
        if not Root or not Root.Parent then
            return false
        end

        local Position = Root.Position
        local Offset = Target - Position
        local Distance = Offset.Magnitude

        if Distance <= 1 then
            Root.CFrame = CFrame.new(Target)
            Freeze(Root)
            return true
        end

        local DeltaTime = RunService.Heartbeat:Wait()
        local Step = math.min(CONFIG.Speed * DeltaTime, Distance)

        Root.CFrame = CFrame.new(Position + Offset.Unit * Step)
        Freeze(Root)
    end

    return false
end

local function LoopBetween(Root, PointA, PointB, Duration, Gen)
    local StartTime = os.clock()

    while Running and Generation == Gen do
        if not Root or not Root.Parent then
            return false
        end

        local Elapsed = os.clock() - StartTime

        if Elapsed >= Duration then
            return true
        end

        local Alpha = (math.sin(Elapsed * math.pi * 2 / 1.2) + 1) / 2

        Root.CFrame = CFrame.new(
            PointA:Lerp(PointB, Alpha)
        )

        Freeze(Root)

        RunService.Heartbeat:Wait()
    end

    return false
end

local function FlightLoop(Gen)
    while Running and Generation == Gen do
        local Humanoid
        local Root

        repeat
            if not Running or Generation ~= Gen then
                return
            end

            Humanoid, Root = GetCharacter()

            if not Root then
                SetStatus(
                    "WAITING FOR CHARACTER",
                    Color3.fromRGB(255, 200, 120)
                )
                task.wait(0.2)
            end
        until Root

        local Dead = false

        local DeathConnection = Humanoid.Died:Connect(function()
            Dead = true
        end)

        for Index, Waypoint in ipairs(CONFIG.Waypoints) do
            if not Running or Generation ~= Gen or Dead then
                break
            end

            SetStatus(
                "FLYING  •  " .. Index .. "/" .. #CONFIG.Waypoints,
                Color3.fromRGB(125, 195, 255)
            )

            if not MoveTo(Root, Waypoint, Gen) then
                break
            end

            if Index == #CONFIG.Waypoints then
                SetStatus(
                    "LOOPING  •  " .. CONFIG.LoopTime .. " SEC",
                    Color3.fromRGB(195, 150, 255)
                )

                LoopBetween(
                    Root,
                    CONFIG.Waypoints[#CONFIG.Waypoints - 1],
                    CONFIG.Waypoints[#CONFIG.Waypoints],
                    CONFIG.LoopTime,
                    Gen
                )
            end
        end

        DeathConnection:Disconnect()

        if not Running or Generation ~= Gen then
            break
        end

        if Dead then
            SetStatus(
                "RESPAWNING...",
                Color3.fromRGB(255, 170, 180)
            )

            repeat
                task.wait(0.2)
            until Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")

            task.wait(0.5)
        else
            SetStatus(
                "RESETTING...",
                Color3.fromRGB(255, 195, 120)
            )

            if Humanoid and Humanoid.Health > 0 then
                Humanoid.Health = 0
            end

            task.wait(1)
        end
    end

    if Running then
        SetStatus(
            "READY",
            Color3.fromRGB(145, 190, 255)
        )
    end
end

local function ApplySettings()
    local Speed = tonumber(SpeedBox.Text)
    local LoopTime = tonumber(LoopBox.Text)

    if Speed then
        CONFIG.Speed = math.clamp(Speed, 1, 5000)
    end

    if LoopTime then
        CONFIG.LoopTime = math.clamp(LoopTime, 1, 300)
    end

    SpeedBox.Text = tostring(CONFIG.Speed)
    LoopBox.Text = tostring(CONFIG.LoopTime)

    SpeedBox.TextColor3 = Color3.fromRGB(200, 255, 200)
    LoopBox.TextColor3 = Color3.fromRGB(200, 255, 200)
end

SpeedBox.FocusLost:Connect(ApplySettings)
LoopBox.FocusLost:Connect(ApplySettings)

local function Start()
    if Running then
        SetStatus(
            "ALREADY RUNNING",
            Color3.fromRGB(255, 200, 120)
        )
        return
    end

    ApplySettings()

    Running = true
    Generation += 1

    local Gen = Generation

    SetStatus(
        "STARTING...",
        Color3.fromRGB(150, 255, 190)
    )

    task.spawn(function()
        local Success, ErrorMessage = pcall(function()
            FlightLoop(Gen)
        end)

        if not Success then
            Running = false
            SetStatus(
                "ERROR",
                Color3.fromRGB(255, 120, 130)
            )
            warn(ErrorMessage)
        end
    end)
end

local function Stop()
    Running = false
    Generation += 1

    local _, Root = GetCharacter()
    Freeze(Root)

    SetStatus(
        "STOPPED",
        Color3.fromRGB(255, 195, 120)
    )
end

local function RemoveMenu()
    Running = false
    Generation += 1

    Gui:Destroy()
end

StartButton.MouseButton1Click:Connect(Start)
StopButton.MouseButton1Click:Connect(Stop)
DeleteButton.MouseButton1Click:Connect(RemoveMenu)

local function Minimize()
    MiniButton.Position = UDim2.fromOffset(
        Main.AbsolutePosition.X,
        Main.AbsolutePosition.Y
    )

    Main.Visible = false
    MiniButton.Visible = true
end

local function Maximize()
    MiniButton.Visible = false
    Main.Visible = true
end

MinButton.MouseButton1Click:Connect(Minimize)
CloseButton.MouseButton1Click:Connect(Minimize)
MiniButton.MouseButton1Click:Connect(Maximize)

Header.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Dragging then
        return
    end

    if Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch then

        local Delta = Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = false
    end
end)

local function PressEffect(Button)
    Button.MouseButton1Down:Connect(function()
        TweenService:Create(
            Button,
            TweenInfo.new(0.08),
            {
                Size = Button.Size - UDim2.fromOffset(2, 2)
            }
        ):Play()
    end)

    Button.MouseButton1Up:Connect(function()
        TweenService:Create(
            Button,
            TweenInfo.new(0.08),
            {
                Size = Button.Size + UDim2.fromOffset(2, 2)
            }
        ):Play()
    end)
end

PressEffect(StartButton)
PressEffect(StopButton)
PressEffect(DeleteButton)
PressEffect(MinButton)
PressEffect(CloseButton)
PressEffect(MiniButton)

ตอนนี้ช่องด้านบนคือ FLIGHT SPEED และช่องถัดไปคือ LOOP TIME โดยค่าเริ่มต้นเป็น "1000" และ "11" วินาที สามารถพิมพ์ค่าใหม่แล้วกดออกจากช่องเพื่อใช้ค่าใหม่ได้ทันที

ถ้าต้องการ ผมสามารถทำต่อให้เป็น UI แบบ Premium จริง ๆ มีแถบ Slider ลากปรับ Speed/Loop แทนการพิมพ์ตัวเลข ซึ่งจะเหมาะกับมือถือกว่า.
