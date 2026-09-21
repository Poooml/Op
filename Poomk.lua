-- NONNOI Flight Route UI
-- ใส่เป็น LocalScript ใน StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- =========================
-- ตั้งค่าเส้นทาง
-- =========================

local ROUTE = {
	Vector3.new(-53.2, 84.6, 817.5),
	Vector3.new(-48.9, 40.2, 8815.4),
	Vector3.new(-53.1, -355.8, 9482.5),
	Vector3.new(-55.5, -356.3, 9505.6)
}

local flightSpeed = 50
local hoverSpeed = 15
local hoverTime = 5

local running = false
local destroyed = false
local routeThread

-- =========================
-- Character
-- =========================

local character
local humanoid
local root

local function updateCharacter()
	character = player.Character or player.CharacterAdded:Wait()
	humanoid = character:WaitForChild("Humanoid")
	root = character:WaitForChild("HumanoidRootPart")
end

updateCharacter()

player.CharacterAdded:Connect(function()
	task.wait(0.5)
	if not destroyed then
		updateCharacter()
	end
end)

-- =========================
-- UI
-- =========================

local gui = Instance.new("ScreenGui")
gui.Name = "NONNOI_FlightMenu"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(285, 355)
main.Position = UDim2.new(0.5, -142, 0.5, -177)
main.BackgroundColor3 = Color3.fromRGB(10, 8, 16)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(139, 92, 246)
stroke.Thickness = 1.5
stroke.Transparency = 0.25
stroke.Parent = main

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 55)
header.BackgroundTransparency = 1
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.fromOffset(18, 0)
title.BackgroundTransparency = 1
title.Text = "NONNOI  •  FLIGHT"
title.TextColor3 = Color3.fromRGB(235, 225, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Minimize
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(38, 38)
minimize.Position = UDim2.new(1, -88, 0, 8)
minimize.BackgroundColor3 = Color3.fromRGB(27, 22, 38)
minimize.Text = "−"
minimize.TextColor3 = Color3.fromRGB(220, 205, 255)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 22
minimize.Parent = header

Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 10)

-- Close
local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(38, 38)
close.Position = UDim2.new(1, -45, 0, 8)
close.BackgroundColor3 = Color3.fromRGB(35, 20, 28)
close.Text = "×"
close.TextColor3 = Color3.fromRGB(255, 170, 190)
close.Font = Enum.Font.GothamBold
close.TextSize = 22
close.Parent = header

Instance.new("UICorner", close).CornerRadius = UDim.new(0, 10)

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -30, 1, -70)
content.Position = UDim2.fromOffset(15, 60)
content.BackgroundTransparency = 1
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 35)
status.BackgroundColor3 = Color3.fromRGB(19, 15, 28)
status.Text = "●  READY"
status.TextColor3 = Color3.fromRGB(180, 170, 200)
status.Font = Enum.Font.GothamMedium
status.TextSize = 13
status.LayoutOrder = 1
status.Parent = content

Instance.new("UICorner", status).CornerRadius = UDim.new(0, 10)

-- Slider creator
local function createSlider(text, minValue, maxValue, defaultValue, order, callback)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 65)
	holder.BackgroundTransparency = 1
	holder.LayoutOrder = order
	holder.Parent = content

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -55, 0, 25)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(205, 195, 220)
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.fromOffset(55, 25)
	valueLabel.Position = UDim2.new(1, -55, 0, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.TextColor3 = Color3.fromRGB(170, 125, 255)
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextSize = 12
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = holder

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, 0, 0, 8)
	bar.Position = UDim2.fromOffset(0, 37)
	bar.BackgroundColor3 = Color3.fromRGB(35, 29, 46)
	bar.BorderSizePixel = 0
	bar.Parent = holder

	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(
		(defaultValue - minValue) / (maxValue - minValue),
		0, 1, 0
	)
	fill.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
	fill.BorderSizePixel = 0
	fill.Parent = bar

	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(16, 16)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Position = UDim2.new(
		(defaultValue - minValue) / (maxValue - minValue),
		0, 0.5, 0
	)
	knob.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
	knob.BorderSizePixel = 0
	knob.Parent = bar

	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local dragging = false

	local function setValueFromX(x)
		local percentage = math.clamp(
			(x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
			0,
			1
		)

		local value = minValue + percentage * (maxValue - minValue)
		value = math.floor(value + 0.5)

		fill.Size = UDim2.new(percentage, 0, 1, 0)
		knob.Position = UDim2.new(percentage, 0, 0.5, 0)
		valueLabel.Text = tostring(value)

		callback(value)
	end

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			setValueFromX(input.Position.X)
		end
	end)

	bar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = false
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging then
			if input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch then

				setValueFromX(input.Position.X)
			end
		end
	end)

	valueLabel.Text = tostring(defaultValue)

	return holder
end

-- ความเร็วบิน
createSlider(
	"ความเร็วบินระหว่างจุด",
	10,
	200,
	flightSpeed,
	2,
	function(value)
		flightSpeed = value
	end
)

-- ความเร็วลอย
createSlider(
	"ความเร็วลอย 2 จุดสุดท้าย",
	1,
	100,
	hoverSpeed,
	3,
	function(value)
		hoverSpeed = value
	end
)

-- Start
local startButton = Instance.new("TextButton")
startButton.Size = UDim2.new(1, 0, 0, 48)
startButton.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
startButton.Text = "เริ่มบิน"
startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
startButton.Font = Enum.Font.GothamBold
startButton.TextSize = 14
startButton.LayoutOrder = 4
startButton.Parent = content

Instance.new("UICorner", startButton).CornerRadius = UDim.new(0, 12)

-- Stop
local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(1, 0, 0, 42)
stopButton.BackgroundColor3 = Color3.fromRGB(27, 22, 38)
stopButton.Text = "หยุด"
stopButton.TextColor3 = Color3.fromRGB(210, 200, 225)
stopButton.Font = Enum.Font.GothamMedium
stopButton.TextSize = 13
stopButton.LayoutOrder = 5
stopButton.Parent = content

Instance.new("UICorner", stopButton).CornerRadius = UDim.new(0, 12)

-- =========================
-- Flight Functions
-- =========================

local function moveTo(position)
	if not root or not root.Parent then
		updateCharacter()
	end

	local distance = (root.Position - position).Magnitude
	local duration = math.max(distance / flightSpeed, 0.05)

	local tween = TweenService:Create(
		root,
		TweenInfo.new(
			duration,
			Enum.EasingStyle.Linear,
			Enum.EasingDirection.InOut
		),
		{
			CFrame = CFrame.new(position)
		}
	)

	tween:Play()

	while tween.PlaybackState == Enum.PlaybackState.Playing do
		if not running or destroyed then
			tween:Cancel()
			return false
		end

		task.wait()
	end

	return true
end

local function hoverBetweenPoints(a, b)
	local startTime = os.clock()

	while running and not destroyed and os.clock() - startTime < hoverTime do

		local distanceA = (root.Position - a).Magnitude
		local durationA = math.max(distanceA / hoverSpeed, 0.05)

		local tweenA = TweenService:Create(
			root,
			TweenInfo.new(
				durationA,
				Enum.EasingStyle.Linear
			),
			{
				CFrame = CFrame.new(a)
			}
		)

		tweenA:Play()
		tweenA.Completed:Wait()

		if not running or destroyed then
			return
		end

		local distanceB = (root.Position - b).Magnitude
		local durationB = math.max(distanceB / hoverSpeed, 0.05)

		local tweenB = TweenService:Create(
			root,
			TweenInfo.new(
				durationB,
				Enum.EasingStyle.Linear
			),
			{
				CFrame = CFrame.new(b)
			}
		)

		tweenB:Play()
		tweenB.Completed:Wait()
	end
end

local function resetCharacter()
	if humanoid and humanoid.Parent then
		humanoid.Health = 0
	end
end

local function startRoute()
	if running then
		return
	end

	running = true

	routeThread = task.spawn(function()

		while running and not destroyed do

			status.Text = "●  กำลังบิน"
			status.TextColor3 = Color3.fromRGB(180, 140, 255)

			for i = 1, #ROUTE do

				if not running or destroyed then
					break
				end

				local success = moveTo(ROUTE[i])

				if not success then
					break
				end
			end

			if running and not destroyed then
				status.Text = "●  ลอย 2 จุดสุดท้าย"
				hoverBetweenPoints(
					ROUTE[3],
					ROUTE[4]
				)
			end

			if running and not destroyed then
				status.Text = "●  รีเซ็ตตัวละคร"
				task.wait(0.2)

				resetCharacter()

				-- รอเกิดใหม่
				player.CharacterAdded:Wait()
				task.wait(0.8)

				if not destroyed then
					updateCharacter()
				end
			end
		end
	end)
end

local function stopRoute()
	running = false
	status.Text = "●  หยุดแล้ว"
	status.TextColor3 = Color3.fromRGB(180, 170, 200)
end

startButton.MouseButton1Click:Connect(function()
	startRoute()
end)

stopButton.MouseButton1Click:Connect(function()
	stopRoute()
end)

-- =========================
-- Minimize
-- =========================

local minimized = false

minimize.MouseButton1Click:Connect(function()
	minimized = not minimized

	if minimized then
		content.Visible = false
		main.Size = UDim2.fromOffset(190, 55)
		title.Text = "NONNOI  •  FLIGHT"
	else
		content.Visible = true
		main.Size = UDim2.fromOffset(285, 355)
	end
end)

-- =========================
-- Close / Delete Menu
-- =========================

close.MouseButton1Click:Connect(function()
	destroyed = true
	running = false

	if routeThread then
		task.cancel(routeThread)
	end

	gui:Destroy()
end)
