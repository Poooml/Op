local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local MENU_WIDTH = 250
local MENU_HEIGHT = 300
local HEADER_HEIGHT = 28

local PINK = Color3.fromRGB(255, 0, 128)
local DARK = Color3.fromRGB(13, 14, 18)
local OFF = Color3.fromRGB(55, 55, 60)
local WHITE = Color3.fromRGB(235, 235, 235)
local GRAY = Color3.fromRGB(160, 160, 160)

local Old = PlayerGui:FindFirstChild("DripAPK")
if Old then
	Old:Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "DripAPK"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

-- ============================================================
-- LOGIN
-- ============================================================
local LoginFrame = Instance.new("Frame")
LoginFrame.Name = "LoginFrame"
LoginFrame.Size = UDim2.fromOffset(220, 145)
LoginFrame.Position = UDim2.new(0.5, -110, 0.5, -72)
LoginFrame.BackgroundColor3 = DARK
LoginFrame.BorderSizePixel = 0
LoginFrame.Active = true
LoginFrame.ZIndex = 10
LoginFrame.Parent = Gui

local LoginCorner = Instance.new("UICorner")
LoginCorner.CornerRadius = UDim.new(0, 6)
LoginCorner.Parent = LoginFrame

local LoginHeader = Instance.new("Frame")
LoginHeader.Size = UDim2.new(1, 0, 0, 28)
LoginHeader.BackgroundColor3 = PINK
LoginHeader.BorderSizePixel = 0
LoginHeader.ZIndex = 11
LoginHeader.Parent = LoginFrame

local LoginHeaderCorner = Instance.new("UICorner")
LoginHeaderCorner.CornerRadius = UDim.new(0, 6)
LoginHeaderCorner.Parent = LoginHeader

local LoginHeaderFix = Instance.new("Frame")
LoginHeaderFix.Size = UDim2.new(1, 0, 0, 7)
LoginHeaderFix.Position = UDim2.new(0, 0, 1, -7)
LoginHeaderFix.BackgroundColor3 = PINK
LoginHeaderFix.BorderSizePixel = 0
LoginHeaderFix.ZIndex = 11
LoginHeaderFix.Parent = LoginHeader

local LoginTitle = Instance.new("TextLabel")
LoginTitle.Size = UDim2.new(1, 0, 1, 0)
LoginTitle.BackgroundTransparency = 1
LoginTitle.Text = "DRIP APK"
LoginTitle.TextColor3 = WHITE
LoginTitle.TextSize = 13
LoginTitle.Font = Enum.Font.GothamBold
LoginTitle.ZIndex = 12
LoginTitle.Parent = LoginHeader

local LoginText = Instance.new("TextLabel")
LoginText.Size = UDim2.new(1, -20, 0, 25)
LoginText.Position = UDim2.fromOffset(10, 37)
LoginText.BackgroundTransparency = 1
LoginText.Text = "Enter Number"
LoginText.TextColor3 = WHITE
LoginText.TextSize = 12
LoginText.Font = Enum.Font.Gotham
LoginText.ZIndex = 11
LoginText.Parent = LoginFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Name = "KeyBox"
KeyBox.Size = UDim2.new(1, -20, 0, 32)
KeyBox.Position = UDim2.fromOffset(10, 63)
KeyBox.BackgroundColor3 = Color3.fromRGB(28, 29, 35)
KeyBox.BorderSizePixel = 0
KeyBox.Text = ""
KeyBox.PlaceholderText = "5+ numbers"
KeyBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 105)
KeyBox.TextColor3 = WHITE
KeyBox.TextSize = 13
KeyBox.Font = Enum.Font.Gotham
KeyBox.ClearTextOnFocus = false
KeyBox.TextEditable = true
KeyBox.Active = true
KeyBox.Selectable = true
KeyBox.ZIndex = 20
KeyBox.Parent = LoginFrame

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 4)
KeyCorner.Parent = KeyBox

local LoginButton = Instance.new("TextButton")
LoginButton.Size = UDim2.new(1, -20, 0, 30)
LoginButton.Position = UDim2.fromOffset(10, 103)
LoginButton.BackgroundColor3 = PINK
LoginButton.BorderSizePixel = 0
LoginButton.Text = "LOGIN"
LoginButton.TextColor3 = WHITE
LoginButton.TextSize = 12
LoginButton.Font = Enum.Font.GothamBold
LoginButton.AutoButtonColor = false
LoginButton.Active = true
LoginButton.Selectable = true
LoginButton.ZIndex = 20
LoginButton.Parent = LoginFrame

local LoginButtonCorner = Instance.new("UICorner")
LoginButtonCorner.CornerRadius = UDim.new(0, 4)
LoginButtonCorner.Parent = LoginButton

local LoginStatus = Instance.new("TextLabel")
LoginStatus.Size = UDim2.new(1, -20, 0, 18)
LoginStatus.Position = UDim2.fromOffset(10, 132)
LoginStatus.BackgroundTransparency = 1
LoginStatus.Text = ""
LoginStatus.TextColor3 = PINK
LoginStatus.TextSize = 9
LoginStatus.Font = Enum.Font.Gotham
LoginStatus.ZIndex = 20
LoginStatus.Parent = LoginFrame

KeyBox:GetPropertyChangedSignal("Text"):Connect(function()
	local Text = KeyBox.Text
	local NumbersOnly = Text:gsub("%D", "")
	if Text ~= NumbersOnly then
		KeyBox.Text = NumbersOnly
	end
end)

KeyBox.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.Touch then
		KeyBox:CaptureFocus()
	end
end)

-- ============================================================
-- MAIN MENU
-- ============================================================
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(MENU_WIDTH, MENU_HEIGHT)
Main.Position = UDim2.new(0.5, -MENU_WIDTH / 2, 0.5, -MENU_HEIGHT / 2)
Main.BackgroundColor3 = DARK
Main.BorderSizePixel = 0
Main.Visible = false
Main.Active = true
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 3)
MainCorner.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, HEADER_HEIGHT)
Header.BackgroundColor3 = PINK
Header.BorderSizePixel = 0
Header.Active = true
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 3)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 8)
HeaderFix.Position = UDim2.new(0, 0, 1, -8)
HeaderFix.BackgroundColor3 = PINK
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -45, 1, 0)
Title.Position = UDim2.fromOffset(8, 0)
Title.BackgroundTransparency = 1
Title.Text = "DRIP APK"
Title.TextColor3 = WHITE
Title.TextSize = 13
Title.Font = Enum.Font.Gotham
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = Header

local Arrow = Instance.new("TextButton")
Arrow.Size = UDim2.fromOffset(28, HEADER_HEIGHT)
Arrow.Position = UDim2.new(1, -28, 0, 0)
Arrow.BackgroundTransparency = 1
Arrow.Text = "▼"
Arrow.TextColor3 = WHITE
Arrow.TextSize = 13
Arrow.Font = Enum.Font.GothamBold
Arrow.Active = true
Arrow.Selectable = true
Arrow.Parent = Header

local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Size = UDim2.new(1, 0, 1, -HEADER_HEIGHT)
Content.Position = UDim2.fromOffset(0, HEADER_HEIGHT)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = PINK
Content.CanvasSize = UDim2.fromOffset(0, 0)
Content.Parent = Main

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 7)
Padding.PaddingBottom = UDim.new(0, 7)
Padding.PaddingLeft = UDim.new(0, 7)
Padding.PaddingRight = UDim.new(0, 7)
Padding.Parent = Content

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 4)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Parent = Content

-- ============================================================
-- STATE
-- ============================================================
local States = {
	["Enable Functions"] = false,
	["Aimbot Pro"] = false,
	["ESP Line"] = false,
	["ESP Box"] = false,
	["ESP Name"] = false,
	["ESP Health"] = false,
	["Third Person"] = false,
}

local ThirdPersonSettings = {
	Distance = 15,
	Height = 5,
}

local AimbotSettings = {
	FOV = 150,
	Smoothness = 0.15,
	MaxDistance = 250,
}

-- Camera rotation for mobile third person
local CamYaw = 0
local CamPitch = 0.2
local TouchRotating = false
local LastTouchPos = nil
local Sensitivity = 0.008

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -14, 0, 22)
Status.BackgroundTransparency = 1
Status.Text = "Status: Ready"
Status.TextColor3 = GRAY
Status.TextSize = 11
Status.Font = Enum.Font.Gotham
Status.Parent = Content

-- ============================================================
-- ESP
-- ============================================================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "DRIP_ESP"
ESPFolder.Parent = Gui

local ESPObjects = {}

-- Aimbot FOV indicator (uses the existing menu style; no extra toggle).
local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "AimbotFOV"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.fromScale(0.5, 0.5)
FOVCircle.Size = UDim2.fromOffset(AimbotSettings.FOV * 2, AimbotSettings.FOV * 2)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 0
FOVCircle.Visible = false
FOVCircle.ZIndex = 2
FOVCircle.Parent = Gui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircle

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = PINK
FOVStroke.Thickness = 1
FOVStroke.Transparency = 0.15
FOVStroke.Parent = FOVCircle

local function UpdateFOVCircle()
	FOVCircle.Size = UDim2.fromOffset(AimbotSettings.FOV * 2, AimbotSettings.FOV * 2)
	FOVCircle.Visible = States["Aimbot Pro"] and States["Enable Functions"]
end

local function RemoveESP(Target)
	local Data = ESPObjects[Target]
	if Data then
		if Data.Box then Data.Box:Destroy() end
		if Data.Billboard then Data.Billboard:Destroy() end
		if Data.HealthGui then Data.HealthGui:Destroy() end
		if Data.Line then Data.Line:Destroy() end
		ESPObjects[Target] = nil
	end
end

local function CreateESP(Target)
	if Target == Player then return end

	local Character = Target.Character
	if not Character then return end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	local Root = Character:FindFirstChild("HumanoidRootPart")
	if not Humanoid or not Root then return end

	RemoveESP(Target)

	local Box = Instance.new("Frame")
	Box.Name = "ESPBox2D"
	Box.BackgroundTransparency = 1
	Box.BorderSizePixel = 0
	Box.Visible = false
	Box.ZIndex = 4
	Box.Parent = Gui

	local BoxStroke = Instance.new("UIStroke")
	BoxStroke.Color = PINK
	BoxStroke.Thickness = 1.5
	BoxStroke.Transparency = 0
	BoxStroke.Parent = Box

	local Billboard = Instance.new("BillboardGui")
	Billboard.Name = "ESPName"
	Billboard.Adornee = Root
	Billboard.Size = UDim2.fromOffset(180, 45)
	Billboard.StudsOffset = Vector3.new(0, 3.2, 0)
	Billboard.AlwaysOnTop = true
	Billboard.MaxDistance = 100000
	Billboard.Enabled = States["ESP Name"] and States["Enable Functions"]
	Billboard.Parent = ESPFolder

	local NameLabel = Instance.new("TextLabel")
	NameLabel.Size = UDim2.new(1, 0, 0, 20)
	NameLabel.BackgroundTransparency = 1
	NameLabel.Text = Target.DisplayName
	NameLabel.TextColor3 = WHITE
	NameLabel.TextStrokeTransparency = 0
	NameLabel.TextSize = 13
	NameLabel.Font = Enum.Font.GothamBold
	NameLabel.Parent = Billboard

	local DistanceLabel = Instance.new("TextLabel")
	DistanceLabel.Size = UDim2.new(1, 0, 0, 18)
	DistanceLabel.Position = UDim2.fromOffset(0, 18)
	DistanceLabel.BackgroundTransparency = 1
	DistanceLabel.TextColor3 = PINK
	DistanceLabel.TextStrokeTransparency = 0
	DistanceLabel.TextSize = 10
	DistanceLabel.Font = Enum.Font.Gotham
	DistanceLabel.Parent = Billboard

	local HealthGui = Instance.new("BillboardGui")
	HealthGui.Name = "ESPHealth"
	HealthGui.Adornee = Root
	HealthGui.Size = UDim2.fromOffset(70, 7)
	HealthGui.StudsOffset = Vector3.new(0, 2.55, 0)
	HealthGui.AlwaysOnTop = true
	HealthGui.MaxDistance = 100000
	HealthGui.Enabled = States["ESP Health"] and States["Enable Functions"]
	HealthGui.Parent = ESPFolder

	local HealthBackground = Instance.new("Frame")
	HealthBackground.Size = UDim2.fromScale(1, 1)
	HealthBackground.BackgroundColor3 = OFF
	HealthBackground.BorderSizePixel = 0
	HealthBackground.Parent = HealthGui

	local HealthFill = Instance.new("Frame")
	HealthFill.Size = UDim2.fromScale(1, 1)
	HealthFill.BackgroundColor3 = Color3.fromRGB(80, 255, 120)
	HealthFill.BorderSizePixel = 0
	HealthFill.Parent = HealthBackground

	local Line = Instance.new("Frame")
	Line.Name = "ESPLine"
	Line.AnchorPoint = Vector2.new(0.5, 0.5)
	Line.BackgroundColor3 = PINK
	Line.BorderSizePixel = 0
	Line.Visible = false
	Line.ZIndex = 5
	Line.Parent = Gui

	ESPObjects[Target] = {
		Box = Box,
		Billboard = Billboard,
		NameLabel = NameLabel,
		DistanceLabel = DistanceLabel,
		HealthGui = HealthGui,
		HealthFill = HealthFill,
		Line = Line
	}
end

local function WorldToScreen(WorldPos)
	local Viewport = Camera:WorldToViewportPoint(WorldPos)
	return Vector2.new(Viewport.X, Viewport.Y), Viewport.Z > 0
end

local function UpdateESP()
	local MyCharacter = Player.Character
	local MyRoot = MyCharacter and MyCharacter:FindFirstChild("HumanoidRootPart")
	local ScreenSize = Camera.ViewportSize
	local Center = Vector2.new(ScreenSize.X / 2, ScreenSize.Y / 2)

	for _, Target in ipairs(Players:GetPlayers()) do
		if Target ~= Player then
			if not ESPObjects[Target] then
				CreateESP(Target)
			end

			local Data = ESPObjects[Target]
			local Character = Target.Character

			if Data and Character then
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")
				local Root = Character:FindFirstChild("HumanoidRootPart")

				if Humanoid and Root and Humanoid.Health > 0 then
					local Enabled = States["Enable Functions"]

					Data.Billboard.Enabled = States["ESP Name"] and Enabled
					Data.HealthGui.Enabled = States["ESP Health"] and Enabled

					if MyRoot then
						local Distance = (MyRoot.Position - Root.Position).Magnitude
						Data.DistanceLabel.Text = math.floor(Distance) .. " studs"
					end

					local Health = math.clamp(
						Humanoid.Health / math.max(Humanoid.MaxHealth, 1),
						0, 1
					)

					Data.HealthFill.Size = UDim2.new(Health, 0, 1, 0)

					-- 2D ESP box based on the character's screen-space bounding box.
					if Data.Box then
						if States["ESP Box"] and Enabled then
							local BoxCFrame, BoxSize = Character:GetBoundingBox()
							local Half = BoxSize * 0.5
							local Corners = {
								Vector3.new(-Half.X, -Half.Y, -Half.Z),
								Vector3.new(-Half.X, -Half.Y,  Half.Z),
								Vector3.new(-Half.X,  Half.Y, -Half.Z),
								Vector3.new(-Half.X,  Half.Y,  Half.Z),
								Vector3.new( Half.X, -Half.Y, -Half.Z),
								Vector3.new( Half.X, -Half.Y,  Half.Z),
								Vector3.new( Half.X,  Half.Y, -Half.Z),
								Vector3.new( Half.X,  Half.Y,  Half.Z),
							}
							local MinX, MinY = math.huge, math.huge
							local MaxX, MaxY = -math.huge, -math.huge
							local AnyVisible = false
							for _, Corner in ipairs(Corners) do
								local Screen, OnScreen = WorldToScreen((BoxCFrame * CFrame.new(Corner)).Position)
								if OnScreen then AnyVisible = true end
								MinX, MinY = math.min(MinX, Screen.X), math.min(MinY, Screen.Y)
								MaxX, MaxY = math.max(MaxX, Screen.X), math.max(MaxY, Screen.Y)
							end
							if AnyVisible and MaxX > MinX and MaxY > MinY then
								Data.Box.Position = UDim2.fromOffset(MinX, MinY)
								Data.Box.Size = UDim2.fromOffset(MaxX - MinX, MaxY - MinY)
								Data.Box.Visible = true
							else
								Data.Box.Visible = false
							end
						else
							Data.Box.Visible = false
						end
					end

					if Health > 0.5 then
						Data.HealthFill.BackgroundColor3 = Color3.fromRGB(80, 255, 120)
					elseif Health > 0.25 then
						Data.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 210, 80)
					else
						Data.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
					end

					-- ESP Line: converge every line to one point at the top-center.
					if States["ESP Line"] and Enabled then
						local ToPos, OnScreen = WorldToScreen(Root.Position)
						local TopOrigin = Vector2.new(ScreenSize.X * 0.5, 8)

						if OnScreen and ToPos.Y >= 0 and ToPos.Y <= ScreenSize.Y then
							local Diff = ToPos - TopOrigin
							local Length = Diff.Magnitude
							local Angle = math.atan2(Diff.Y, Diff.X)

							Data.Line.Visible = true
							Data.Line.Size = UDim2.fromOffset(Length, 2)
							Data.Line.Position = UDim2.fromOffset(TopOrigin.X + Diff.X * 0.5, TopOrigin.Y + Diff.Y * 0.5)
							Data.Line.Rotation = math.deg(Angle)
						else
							Data.Line.Visible = false
						end
					else
						Data.Line.Visible = false
					end

				else
					if Data.Line then Data.Line.Visible = false end
					if Data.Box then Data.Box.Visible = false end
				end
			end
		end
	end
end

Players.PlayerAdded:Connect(function(Target)
	Target.CharacterAdded:Connect(function()
		task.wait(0.5)
		CreateESP(Target)
	end)
end)

Players.PlayerRemoving:Connect(function(Target)
	RemoveESP(Target)
end)

for _, Target in ipairs(Players:GetPlayers()) do
	if Target ~= Player then
		Target.CharacterAdded:Connect(function()
			task.wait(0.5)
			CreateESP(Target)
		end)
	end
end

-- ============================================================
-- THIRD PERSON CAMERA (Mobile friendly - free rotate)
-- ============================================================
local CameraConnection = nil
local OriginalCameraType = nil

local function ApplyThirdPerson()
	local Character = Player.Character
	if not Character then return end

	local Root = Character:FindFirstChild("HumanoidRootPart")
	if not Root then return end

	Camera.CameraType = Enum.CameraType.Scriptable

	local Distance = ThirdPersonSettings.Distance
	local Height = ThirdPersonSettings.Height

	-- Free look with yaw / pitch
	local Offset = CFrame.Angles(0, CamYaw, 0) * CFrame.Angles(CamPitch, 0, 0) * CFrame.new(0, 0, Distance)
	local TargetPos = Root.Position + Vector3.new(0, Height * 0.3, 0)
	local CameraPos = (CFrame.new(TargetPos) * Offset).Position

	Camera.CFrame = CFrame.new(CameraPos, TargetPos)
	Camera.Focus = CFrame.new(TargetPos)
end

local function EnableThirdPerson()
	if CameraConnection then return end

	OriginalCameraType = Camera.CameraType

	-- Initialize yaw from current camera
	local Look = Camera.CFrame.LookVector
	CamYaw = math.atan2(-Look.X, -Look.Z)
	CamPitch = 0.2

	CameraConnection = RunService.RenderStepped:Connect(function()
		if States["Third Person"] and States["Enable Functions"] then
			ApplyThirdPerson()
		end
	end)
end

local function DisableThirdPerson()
	if CameraConnection then
		CameraConnection:Disconnect()
		CameraConnection = nil
	end

	if OriginalCameraType then
		Camera.CameraType = OriginalCameraType
		OriginalCameraType = nil
	else
		Camera.CameraType = Enum.CameraType.Custom
	end
end

-- Touch rotation for mobile
-- Right-side swipe controls the third-person camera. The left side remains free for movement.
local TouchRotateInput = nil

UserInputService.TouchStarted:Connect(function(Input, GameProcessed)
	if not (States["Third Person"] and States["Enable Functions"]) then return end

	local StartPos = Input.Position
	local Viewport = Camera.ViewportSize
	if StartPos.X < Viewport.X * 0.45 then return end

	-- Do not rotate while the user is interacting with the menu.
	if Main and Main.Visible then
		local Pos = Main.AbsolutePosition
		local Size = Main.AbsoluteSize
		if StartPos.X >= Pos.X and StartPos.X <= Pos.X + Size.X
			and StartPos.Y >= Pos.Y and StartPos.Y <= Pos.Y + Size.Y then
			return
		end
	end

	TouchRotateInput = Input
	TouchRotating = true
	LastTouchPos = StartPos
end)

UserInputService.TouchEnded:Connect(function(Input)
	if Input == TouchRotateInput then
		TouchRotateInput = nil
		TouchRotating = false
		LastTouchPos = nil
	end
end)

UserInputService.TouchMoved:Connect(function(Input)
	if Input ~= TouchRotateInput then return end
	if not (States["Third Person"] and States["Enable Functions"]) then return end

	local CurrentPos = Input.Position
	if LastTouchPos then
		local Delta = CurrentPos - LastTouchPos
		CamYaw = CamYaw - Delta.X * Sensitivity
		CamPitch = math.clamp(CamPitch - Delta.Y * Sensitivity, -1.2, 1.2)
	end
	LastTouchPos = CurrentPos
end)

-- Desktop mouse support.
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	if GameProcessed then return end
	if not (States["Third Person"] and States["Enable Functions"]) then return end
	if Input.UserInputType == Enum.UserInputType.MouseButton2 then
		TouchRotating = true
		LastTouchPos = Input.Position
	end
end)

UserInputService.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton2 then
		TouchRotating = false
		LastTouchPos = nil
	end
end)

UserInputService.InputChanged:Connect(function(Input)
	if not TouchRotating then return end
	if not (States["Third Person"] and States["Enable Functions"]) then return end
	if Input.UserInputType == Enum.UserInputType.MouseMovement and LastTouchPos then
		local Delta = Input.Position - LastTouchPos
		CamYaw = CamYaw - Delta.X * Sensitivity
		CamPitch = math.clamp(CamPitch - Delta.Y * Sensitivity, -1.2, 1.2)
		LastTouchPos = Input.Position
	end
end)

Player.CharacterAdded:Connect(function(Character)
	Character:WaitForChild("Humanoid")
	task.wait(0.3)

	if States["Third Person"] and States["Enable Functions"] then
		EnableThirdPerson()
	end
end)

-- ============================================================
-- AIMBOT
-- ============================================================
local function IsSameTeam(Target)
	return Target.Team ~= nil and Player.Team ~= nil and Target.Team == Player.Team
end

local function IsTargetVisible(TargetCharacter, TargetPart)
	local MyCharacter = Player.Character
	if not MyCharacter or not TargetCharacter or not TargetPart then return false end

	local Origin = Camera.CFrame.Position
	local Direction = TargetPart.Position - Origin
	local Params = RaycastParams.new()
	Params.FilterType = Enum.RaycastFilterType.Exclude
	Params.FilterDescendantsInstances = {MyCharacter}
	Params.IgnoreWater = true

	local Result = workspace:Raycast(Origin, Direction, Params)
	return Result == nil or Result.Instance:IsDescendantOf(TargetCharacter)
end

local function GetTargetPart(Character)
	return Character:FindFirstChild("Head")
		or Character:FindFirstChild("UpperTorso")
		or Character:FindFirstChild("HumanoidRootPart")
end

local function GetClosestPlayer()
	local MyCharacter = Player.Character
	local MyRoot = MyCharacter and MyCharacter:FindFirstChild("HumanoidRootPart")
	if not MyRoot then return nil end

	local Viewport = Camera.ViewportSize
	local ScreenCenter = Vector2.new(Viewport.X / 2, Viewport.Y / 2)
	local Closest = nil
	local ShortestScreenDistance = AimbotSettings.FOV

	for _, Target in ipairs(Players:GetPlayers()) do
		if Target ~= Player and Target.Character then
			local Humanoid = Target.Character:FindFirstChildOfClass("Humanoid")
			local TargetPart = GetTargetPart(Target.Character)

			if Humanoid and TargetPart and Humanoid.Health > 0
				and not IsSameTeam(Target)
				and (MyRoot.Position - TargetPart.Position).Magnitude <= AimbotSettings.MaxDistance then

				local ScreenPos, OnScreen = WorldToScreen(TargetPart.Position)
				if OnScreen then
					local ScreenDistance = (ScreenPos - ScreenCenter).Magnitude
					if ScreenDistance <= ShortestScreenDistance
						and IsTargetVisible(Target.Character, TargetPart) then
						ShortestScreenDistance = ScreenDistance
						Closest = TargetPart
					end
				end
			end
		end
	end

	return Closest
end

local function RunAimbot()
	if not (States["Aimbot Pro"] and States["Enable Functions"]) then return end

	local TargetPart = GetClosestPlayer()
	if not TargetPart then return end

	local MyCharacter = Player.Character
	local MyRoot = MyCharacter and MyCharacter:FindFirstChild("HumanoidRootPart")
	if not MyRoot then return end

	local Direction = (TargetPart.Position - MyRoot.Position).Unit
	local TargetYaw = math.atan2(-Direction.X, -Direction.Z)
	local CurrentYaw = math.atan2(-MyRoot.CFrame.LookVector.X, -MyRoot.CFrame.LookVector.Z)
	local DeltaYaw = math.atan2(math.sin(TargetYaw - CurrentYaw), math.cos(TargetYaw - CurrentYaw))
	local NewYaw = CurrentYaw + DeltaYaw * AimbotSettings.Smoothness
	local LookCFrame = CFrame.new(MyRoot.Position) * CFrame.Angles(0, NewYaw, 0)

	MyRoot.CFrame = MyRoot.CFrame:Lerp(LookCFrame, math.clamp(AimbotSettings.Smoothness, 0.01, 1))

	if not States["Third Person"] then
		local CameraTarget = CFrame.new(Camera.CFrame.Position, TargetPart.Position)
		Camera.CFrame = Camera.CFrame:Lerp(CameraTarget, math.clamp(AimbotSettings.Smoothness, 0.01, 1))
	else
		-- Keep the player's current camera pitch/height.
		-- Only rotate the horizontal camera yaw toward the target, so
		-- changing Height or looking upward does not make the lock point
		-- sit above the enemy.
		local Diff = TargetPart.Position - MyRoot.Position
		local TargetCamYaw = math.atan2(-Diff.X, -Diff.Z)
		local CamDelta = math.atan2(math.sin(TargetCamYaw - CamYaw), math.cos(TargetCamYaw - CamYaw))
		CamYaw = CamYaw + CamDelta * AimbotSettings.Smoothness
	end
end

-- ============================================================
-- SLIDER FACTORY
-- ============================================================
local function CreateSlider(LabelText, MinValue, MaxValue, DefaultValue, OnChanged)
	local Holder = Instance.new("Frame")
	Holder.Size = UDim2.new(1, 0, 0, 42)
	Holder.BackgroundTransparency = 1
	Holder.Parent = Content

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, 0, 0, 16)
	Label.BackgroundTransparency = 1
	Label.Text = LabelText .. " : " .. tostring(DefaultValue)
	Label.TextColor3 = WHITE
	Label.TextSize = 11
	Label.Font = Enum.Font.Gotham
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Holder

	local Bar = Instance.new("Frame")
	Bar.Size = UDim2.new(1, -10, 0, 10)
	Bar.Position = UDim2.new(0, 5, 0, 26)
	Bar.BackgroundColor3 = OFF
	Bar.BorderSizePixel = 0
	Bar.Parent = Holder

	local BarCorner = Instance.new("UICorner")
	BarCorner.CornerRadius = UDim.new(1, 0)
	BarCorner.Parent = Bar

	local Fill = Instance.new("Frame")
	Fill.Size = UDim2.new(
		(DefaultValue - MinValue) / (MaxValue - MinValue),
		0, 1, 0
	)
	Fill.BackgroundColor3 = PINK
	Fill.BorderSizePixel = 0
	Fill.Parent = Bar

	local FillCorner = Instance.new("UICorner")
	FillCorner.CornerRadius = UDim.new(1, 0)
	FillCorner.Parent = Fill

	local Knob = Instance.new("Frame")
	Knob.Size = UDim2.fromOffset(14, 14)
	Knob.Position = UDim2.new(
		(DefaultValue - MinValue) / (MaxValue - MinValue),
		-7,
		0.5, -7
	)
	Knob.BackgroundColor3 = WHITE
	Knob.BorderSizePixel = 0
	Knob.ZIndex = 2
	Knob.Parent = Bar

	local KnobCorner = Instance.new("UICorner")
	KnobCorner.CornerRadius = UDim.new(1, 0)
	KnobCorner.Parent = Knob

	local Dragging = false
	local CurrentValue = DefaultValue

	local function SetValue(Value)
		CurrentValue = math.clamp(Value, MinValue, MaxValue)
		local Alpha = (CurrentValue - MinValue) / (MaxValue - MinValue)
		Fill.Size = UDim2.new(Alpha, 0, 1, 0)
		Knob.Position = UDim2.new(Alpha, -7, 0.5, -7)
		Label.Text = LabelText .. " : " .. (LabelText == "Aimbot Smooth" and string.format("%.2f", CurrentValue) or string.format("%.0f", CurrentValue))
		if OnChanged then OnChanged(CurrentValue) end
	end

	local function UpdateFromInput(Input)
		local AbsPos = Bar.AbsolutePosition
		local AbsSize = Bar.AbsoluteSize
		local X = Input.Position.X - AbsPos.X
		local Alpha = math.clamp(X / AbsSize.X, 0, 1)
		SetValue(MinValue + Alpha * (MaxValue - MinValue))
	end

	Bar.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			UpdateFromInput(Input)

			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if not Dragging then return end
		if Input.UserInputType == Enum.UserInputType.MouseMovement
			or Input.UserInputType == Enum.UserInputType.Touch then
			UpdateFromInput(Input)
		end
	end)

	return Holder
end

-- ============================================================
-- TOGGLE FACTORY
-- ============================================================
local function CreateToggle(Name)
	local Button = Instance.new("TextButton")
	Button.Name = Name
	Button.Size = UDim2.new(1, 0, 0, 38)
	Button.BackgroundTransparency = 1
	Button.Text = ""
	Button.AutoButtonColor = false
	Button.Active = true
	Button.Selectable = true
	Button.Parent = Content

	local Box = Instance.new("TextLabel")
	Box.Size = UDim2.fromOffset(29, 29)
	Box.Position = UDim2.new(0, 3, 0.5, -14)
	Box.BackgroundColor3 = OFF
	Box.BorderSizePixel = 0
	Box.Text = ""
	Box.TextColor3 = Color3.fromRGB(20, 20, 20)
	Box.TextSize = 18
	Box.Font = Enum.Font.GothamBold
	Box.Parent = Button

	local BoxCorner = Instance.new("UICorner")
	BoxCorner.CornerRadius = UDim.new(0, 2)
	BoxCorner.Parent = Box

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -42, 1, 0)
	Label.Position = UDim2.fromOffset(40, 0)
	Label.BackgroundTransparency = 1
	Label.Text = Name
	Label.TextColor3 = WHITE
	Label.TextSize = 13
	Label.Font = Enum.Font.Gotham
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Button

	Button.MouseButton1Click:Connect(function()
		States[Name] = not States[Name]

		if States[Name] then
			Box.BackgroundColor3 = PINK
			Box.Text = "✓"
			Status.Text = Name .. " : ON"
			Status.TextColor3 = PINK
		else
			Box.BackgroundColor3 = OFF
			Box.Text = ""
			Status.Text = Name .. " : OFF"
			Status.TextColor3 = GRAY
		end

		-- Special handling
		if Name == "Third Person" then
			if States[Name] and States["Enable Functions"] then
				EnableThirdPerson()
			else
				DisableThirdPerson()
			end
		end

		if Name == "Enable Functions" then
			if not States[Name] then
				DisableThirdPerson()
			elseif States["Third Person"] then
				EnableThirdPerson()
			end
		end

		UpdateFOVCircle()

		-- Force refresh ESP states
		for _, Data in pairs(ESPObjects) do
			if Data.Box then
				Data.Box.Visible = States["ESP Box"] and States["Enable Functions"]
			end
			if Data.Billboard then
				Data.Billboard.Enabled = States["ESP Name"] and States["Enable Functions"]
			end
			if Data.HealthGui then
				Data.HealthGui.Enabled = States["ESP Health"] and States["Enable Functions"]
			end
			if Data.Line then
				Data.Line.Visible = false
			end
		end

		print(Name, States[Name])
	end)

	return Button
end

-- ============================================================
-- BUILD MENU
-- ============================================================
CreateToggle("Enable Functions")
CreateToggle("Aimbot Pro")
CreateToggle("ESP Line")
CreateToggle("ESP Box")
CreateToggle("ESP Name")
CreateToggle("ESP Health")
CreateToggle("Third Person")

-- Sliders (Third Person)
CreateSlider("Distance", 5, 40, ThirdPersonSettings.Distance, function(v)
	ThirdPersonSettings.Distance = v
end)

CreateSlider("Height", 0, 100, ThirdPersonSettings.Height, function(v)
	ThirdPersonSettings.Height = v
end)

CreateSlider("Aimbot FOV", 50, 300, AimbotSettings.FOV, function(v)
	AimbotSettings.FOV = v
	UpdateFOVCircle()
end)

CreateSlider("Aimbot Smooth", 0.05, 1, AimbotSettings.Smoothness, function(v)
	AimbotSettings.Smoothness = math.clamp(v, 0.05, 1)
end)

-- ============================================================
-- CANVAS UPDATE
-- ============================================================
local function UpdateCanvas()
	Content.CanvasSize = UDim2.fromOffset(0, Layout.AbsoluteContentSize.Y + 15)
end

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
UpdateCanvas()

-- ============================================================
-- COLLAPSE
-- ============================================================
local Expanded = true

Arrow.MouseButton1Click:Connect(function()
	Expanded = not Expanded

	if Expanded then
		Arrow.Text = "▼"
		Content.Visible = true
		Main.Size = UDim2.fromOffset(MENU_WIDTH, MENU_HEIGHT)
	else
		Arrow.Text = "▲"
		Content.Visible = false
		Main.Size = UDim2.fromOffset(MENU_WIDTH, HEADER_HEIGHT)
	end
end)

-- ============================================================
-- DRAG
-- ============================================================
local Dragging = false
local DragStart
local StartPosition

Header.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then

		Dragging = true
		DragStart = Input.Position
		StartPosition = Main.Position

		Input.Changed:Connect(function()
			if Input.UserInputState == Enum.UserInputState.End then
				Dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(Input)
	if not Dragging then return end

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

-- ============================================================
-- LOGIN FLOW
-- ============================================================
local LoggedIn = false

local function OpenMenu()
	if LoggedIn then return end
	LoggedIn = true

	local Tween = TweenService:Create(
		LoginFrame,
		TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ Size = UDim2.fromOffset(0, 0) }
	)

	Tween:Play()

	Tween.Completed:Connect(function()
		LoginFrame.Visible = false
		Main.Visible = true
		Main.Size = UDim2.fromOffset(MENU_WIDTH, MENU_HEIGHT)
	end)
end

LoginButton.MouseButton1Click:Connect(function()
	local Number = KeyBox.Text

	if #Number < 5 then
		LoginStatus.Text = "Enter at least 5 numbers"
		LoginStatus.TextColor3 = PINK
		return
	end

	LoginStatus.Text = "Login Success"
	LoginStatus.TextColor3 = Color3.fromRGB(80, 255, 150)

	task.wait(0.25)
	OpenMenu()
end)

KeyBox.FocusLost:Connect(function(EnterPressed)
	if EnterPressed then
		LoginButton:Activate()
	end
end)

-- ============================================================
-- MAIN LOOP
-- ============================================================
RunService.RenderStepped:Connect(function()
	UpdateESP()
	UpdateFOVCircle()
	RunAimbot()
end)
