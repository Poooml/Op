local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

if not Player then
	repeat
		task.wait(0.1)
		Player = Players.LocalPlayer
	until Player
end

local PlayerGui = Player:WaitForChild("PlayerGui", 10)

if not PlayerGui then
	return
end

local CONFIG = {
	Speed = 350,
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
Main.Size = UDim2.fromOffset(230, 110)
Main.Position = UDim2.new(0, 20, 0.5, -55)
Main.BackgroundColor3 = Color3.fromRGB(28, 18, 42)
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 0
Main.Parent = Gui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(180, 120, 255)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.25
MainStroke.Parent = Main

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 30, 85)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(38, 20, 62)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 12, 38))
})
Gradient.Rotation = 90
Gradient.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 28)
Title.Position = UDim2.fromOffset(10, 8)
Title.BackgroundTransparency = 1
Title.Text = "✦ PREMIUM FLY ✦"
Title.TextColor3 = Color3.fromRGB(235, 210, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = Main

local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(1, -20, 0, 50)
FlyButton.Position = UDim2.fromOffset(10, 45)
FlyButton.BackgroundColor3 = Color3.fromRGB(145, 85, 230)
FlyButton.BorderSizePixel = 0
FlyButton.Text = "▶  START"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.Font = Enum.Font.GothamBold
FlyButton.TextSize = 15
FlyButton.AutoButtonColor = false
FlyButton.Parent = Main

Instance.new("UICorner", FlyButton).CornerRadius = UDim.new(0, 14)

local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Color = Color3.fromRGB(210, 160, 255)
ButtonStroke.Thickness = 1.5
ButtonStroke.Transparency = 0.35
ButtonStroke.Parent = FlyButton

local ButtonGradient = Instance.new("UIGradient")
ButtonGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(175, 110, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 70, 210))
})
ButtonGradient.Rotation = 90
ButtonGradient.Parent = FlyButton

local function Freeze(Root)
	if Root and Root.Parent then
		Root.AssemblyLinearVelocity = Vector3.zero
		Root.AssemblyAngularVelocity = Vector3.zero
	end
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

local function MoveTo(Root, Target, Gen)
	while Running and Generation == Gen do

		if not Root or not Root.Parent then  
			return false  
		end  

		local Humanoid = Root.Parent:FindFirstChildOfClass("Humanoid")  

		if not Humanoid or Humanoid.Health <= 0 then  
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

		local Step = math.min(  
			CONFIG.Speed * DeltaTime,  
			Distance  
		)  

		Root.CFrame = CFrame.new(  
			Position + Offset.Unit * Step  
		)  

		Freeze(Root)  
	end  

	return false
end

local function LoopBetween(Root, PointA, PointB, Duration, Gen)
	local StartTime = tick()

	while Running and Generation == Gen do  

		if not Root or not Root.Parent then  
			return false  
		end  

		local Humanoid = Root.Parent:FindFirstChildOfClass("Humanoid")  

		if not Humanoid or Humanoid.Health <= 0 then  
			return false  
		end  

		local Elapsed = tick() - StartTime  

		if Elapsed >= Duration then  
			return true  
		end  

		local Alpha =  
			(math.sin(Elapsed * math.pi * 2 / 1.2) + 1) / 2  

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
				task.wait(0.2)  
			end  

		until Root  

		local Dead = false  

		local DeathConnection  

		DeathConnection = Humanoid.Died:Connect(function()  
			Dead = true  
		end)  

		for Index, Waypoint in ipairs(CONFIG.Waypoints) do  

			if not Running  
				or Generation ~= Gen  
				or Dead then  

				break  
			end  

			if not MoveTo(  
				Root,  
				Waypoint,  
				Gen  
			) then  

				break  
			end  

			if Index == #CONFIG.Waypoints then  

				LoopBetween(  
					Root,  
					CONFIG.Waypoints[#CONFIG.Waypoints - 1],  
					CONFIG.Waypoints[#CONFIG.Waypoints],  
					CONFIG.LoopTime,  
					Gen  
				)  
			end  
		end  

		if DeathConnection then  
			DeathConnection:Disconnect()  
		end  

		if not Running or Generation ~= Gen then  
			break  
		end  

		if Dead then  

			repeat  
				task.wait(0.2)  
			until Player.Character  
				and Player.Character:FindFirstChildOfClass("Humanoid")  

			task.wait(0.5)  

		else  

			if Humanoid  
				and Humanoid.Parent  
				and Humanoid.Health > 0 then  

				Humanoid.Health = 0  
			end  

			task.wait(1)  
		end  
	end
end

local function UpdateButton()
	if Running then

		FlyButton.Text = "■  STOP"  
		FlyButton.BackgroundColor3 = Color3.fromRGB(200, 75, 130)  
		ButtonStroke.Color = Color3.fromRGB(255, 150, 190)  

		if ButtonGradient then
			ButtonGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 100, 150)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 60, 110))
			})
		end

	else  

		FlyButton.Text = "▶  START"  
		FlyButton.BackgroundColor3 = Color3.fromRGB(145, 85, 230)  
		ButtonStroke.Color = Color3.fromRGB(210, 160, 255)  

		if ButtonGradient then
			ButtonGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(175, 110, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 70, 210))
			})
		end
	end
end

local function Start()
	if Running then
		return
	end

	Running = true  
	Generation += 1  

	local Gen = Generation  

	UpdateButton()  

	task.spawn(function()  

		local Success, ErrorMessage = pcall(function()  
			FlightLoop(Gen)  
		end)  

		if not Success then  

			Running = false  
			Generation += 1  

			UpdateButton()  

			warn(  
				"[PremiumFly] " ..  
				tostring(ErrorMessage)  
			)  
		end  
	end)
end

local function Stop()
	Running = false
	Generation += 1

	local _, Root = GetCharacter()  

	Freeze(Root)  

	UpdateButton()
end

local function ToggleFly()
	if Running then
		Stop()
	else
		Start()
	end
end

FlyButton.MouseButton1Click:Connect(ToggleFly)

-- DRAG MENU

Main.InputBegan:Connect(function(Input)

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

-- 3 FINGER DELETE

local ActiveTouches = {}

local function RemoveMenu()
	Running = false
	Generation += 1

	local _, Root = GetCharacter()  
	Freeze(Root)  

	if Gui then  
		Gui:Destroy()  
	end
end

UserInputService.TouchStarted:Connect(function(Touch)

	ActiveTouches[Touch] = true  

	local Count = 0  

	for _ in pairs(ActiveTouches) do  
		Count += 1  
	end  

	if Count >= 3 then  
		RemoveMenu()  
	end
end)

UserInputService.TouchEnded:Connect(function(Touch)

	ActiveTouches[Touch] = nil
end)

UserInputService.TouchPan:Connect(function()
	-- รองรับการสัมผัสหลายจุดบนมือถือ
end)

print("[PremiumFly] Loaded successfully - Purple Cute Theme 💜")
