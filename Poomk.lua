--[[
    NONNOI MOBILE FLIGHT
    Roblox Studio
    วางเป็น LocalScript ใน:
    StarterPlayer > StarterPlayerScripts

    จุด:
    1. -53.2, 84.6, 817.5
    2. -48.9, 40.2, 8815.4
    3. -53.1, -355.8, 9482.5
    4. -55.5, -356.3, 9505.6

    หลังถึงจุด 3 และ 4:
    ลอยสลับ 2 จุด เป็นเวลา 5 วินาที
    จากนั้นรีตัวละคร
    ถ้าตายระหว่างทาง -> เริ่มจุด 1 ใหม่
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local ROUTE = {
	Vector3.new(-53.2, 84.6, 817.5),
	Vector3.new(-48.9, 40.2, 8815.4),
	Vector3.new(-53.1, -355.8, 9482.5),
	Vector3.new(-55.5, -356.3, 9505.6)
}

local flightSpeed = 180
local hoverSpeed = 80
local hoverDuration = 5

local running = false
local destroyed = false

local character
local humanoid
local root

local routeGeneration = 0

--------------------------------------------------
-- CHARACTER
--------------------------------------------------

local function getCharacter()
	character = player.Character or player.CharacterAdded:Wait()

	humanoid = character:FindFirstChildOfClass("Humanoid")
	root = character:FindFirstChild("HumanoidRootPart")

	if not humanoid then
		humanoid = character:WaitForChild("Humanoid", 5)
	end

	if not root then
		root = character:WaitForChild("HumanoidRootPart", 5)
	end

	return character and humanoid and root
end

getCharacter()

--------------------------------------------------
-- GUI
--------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "NONNOI_MobileFlight"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

--------------------------------------------------
-- MAIN
--------------------------------------------------

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(285, 390)
main.Position = UDim2.new(0.5, -142, 0.5, -195)
main.BackgroundColor3 = Color3.fromRGB(9, 7, 15)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(139, 92, 246)
mainStroke.Thickness = 1
mainStroke.Transparency = 0.25
mainStroke.Parent = main

--------------------------------------------------
-- HEADER
--------------------------------------------------

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 58)
header.BackgroundTransparency = 1
header.Active = true
header.Parent = main

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(16, 0)
title.Size = UDim2.new(1, -105, 1, 0)
title.Text = "NONNOI  •  FLIGHT"
title.TextColor3 = Color3.fromRGB(245, 240, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

--------------------------------------------------
-- MINIMIZE
--------------------------------------------------

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(38, 38)
minimize.Position = UDim2.new(1, -88, 0, 10)
minimize.BackgroundColor3 = Color3.fromRGB(28, 23, 39)
minimize.Text = "−"
minimize.TextColor3 = Color3.fromRGB(230, 220, 250)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 21
minimize.AutoButtonColor = true
minimize.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 10)
minCorner.Parent = minimize

--------------------------------------------------
-- DELETE
--------------------------------------------------

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(38, 38)
close.Position = UDim2.new(1, -45, 0, 10)
close.BackgroundColor3 = Color3.fromRGB(45, 22, 31)
close.Text = "×"
close.TextColor3 = Color3.fromRGB(255, 180, 195)
close.Font = Enum.Font.GothamBold
close.TextSize = 21
close.AutoButtonColor = true
close.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = close

--------------------------------------------------
-- CONTENT
--------------------------------------------------

local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(14, 65)
content.Size = UDim2.new(1, -28, 1, -78)
content.BackgroundTransparency = 1
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 9)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

--------------------------------------------------
-- STATUS
--------------------------------------------------

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 37)
status.BackgroundColor3 = Color3.fromRGB(20, 16, 29)
status.Text = "●  พร้อมใช้งาน"
status.TextColor3 = Color3.fromRGB(190, 180, 210)
status.Font = Enum.Font.GothamMedium
status.TextSize = 13
status.LayoutOrder = 1
status.Parent = content

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 10)
statusCorner.Parent = status

--------------------------------------------------
-- SLIDER
--------------------------------------------------

local sliders = {}

local function createSlider(name, minValue, maxValue, defaultValue, order, callback)

	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 66)
	holder.BackgroundTransparency = 1
	holder.LayoutOrder = order
	holder.Parent = content

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -60, 0, 24)
	label.Text = name
	label.TextColor3 = Color3.fromRGB(210, 200, 225)
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder

	local valueText = Instance.new("TextLabel")
	valueText.BackgroundTransparency = 1
	valueText.Position = UDim2.new(1, -60, 0, 0)
	valueText.Size = UDim2.fromOffset(60, 24)
	valueText.Text = tostring(defaultValue)
	valueText.TextColor3 = Color3.fromRGB(170, 125, 255)
	valueText.Font = Enum.Font.GothamBold
	valueText.TextSize = 12
	valueText.TextXAlignment = Enum.TextXAlignment.Right
	valueText.Parent = holder

	local bar = Instance.new("Frame")
	bar.Position = UDim2.fromOffset(0, 37)
	bar.Size = UDim2.new(1, 0, 0, 8)
	bar.BackgroundColor3 = Color3.fromRGB(35, 29, 46)
	bar.BorderSizePixel = 0
	bar.Active = true
	bar.Parent = holder

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(1, 0)
	barCorner.Parent = bar

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(
		(defaultValue - minValue) / (maxValue - minValue),
		0,
		1,
		0
	)
	fill.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
	fill.BorderSizePixel = 0
	fill.Parent = bar

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = fill

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(18, 18)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Position = UDim2.new(
		(defaultValue - minValue) / (maxValue - minValue),
		0,
		0.5,
		0
	)
	knob.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
	knob.BorderSizePixel = 0
	knob.Active = true
	knob.Parent = bar

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local dragging = false

	local function updateSlider(screenX)

		local width = math.max(bar.AbsoluteSize.X, 1)

		local percent = math.clamp(
			(screenX - bar.AbsolutePosition.X) / width,
			0,
			1
		)

		local value = minValue + (maxValue - minValue) * percent

		value = math.floor(value + 0.5)

		local finalPercent =
			(value - minValue) /
			(maxValue - minValue)

		fill.Size = UDim2.new(finalPercent, 0, 1, 0)

		knob.Position = UDim2.new(
			finalPercent,
			0,
			0.5,
			0
		)

		valueText.Text = tostring(value)

		callback(value)
	end

	local function beginDrag(input)
		if input.UserInputType == Enum.UserInputType.Touch
			or input.UserInputType == Enum.UserInputType.MouseButton1 then

			dragging = true
			updateSlider(input.Position.X)
		end
	end

	bar.InputBegan:Connect(beginDrag)
	knob.InputBegan:Connect(beginDrag)

	UserInputService.InputChanged:Connect(function(input)

		if not dragging then
			return
		end

		if input.UserInputType == Enum.UserInputType.Touch
			or input.UserInputType == Enum.UserInputType.MouseMovement then

			updateSlider(input.Position.X)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.Touch
			or input.UserInputType == Enum.UserInputType.MouseButton1 then

			dragging = false
		end
	end)

	sliders[#sliders + 1] = holder

	return holder
end

createSlider(
	"ความเร็วบินระหว่างจุด",
	20,
	500,
	flightSpeed,
	2,
	function(value)
		flightSpeed = value
	end
)

createSlider(
	"ความเร็วลอย 2 จุดสุดท้าย",
	5,
	250,
	hoverSpeed,
	3,
	function(value)
		hoverSpeed = value
	end
)

--------------------------------------------------
-- START BUTTON
--------------------------------------------------

local startButton = Instance.new("TextButton")
startButton.Size = UDim2.new(1, 0, 0, 47)
startButton.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
startButton.Text = "เริ่มบิน"
startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
startButton.Font = Enum.Font.GothamBold
startButton.TextSize = 14
startButton.LayoutOrder = 4
startButton.Parent = content

local startCorner = Instance.new("UICorner")
startCorner.CornerRadius = UDim.new(0, 12)
startCorner.Parent = startButton

--------------------------------------------------
-- STOP BUTTON
--------------------------------------------------

local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(1, 0, 0, 43)
stopButton.BackgroundColor3 = Color3.fromRGB(27, 22, 37)
stopButton.Text = "หยุด"
stopButton.TextColor3 = Color3.fromRGB(215, 205, 225)
stopButton.Font = Enum.Font.GothamMedium
stopButton.TextSize = 13
stopButton.LayoutOrder = 5
stopButton.Parent = content

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 12)
stopCorner.Parent = stopButton

--------------------------------------------------
-- SMOOTH MOVE
--------------------------------------------------

local function moveTo(target, speed, generation)

	if not root or not root.Parent then
		if not getCharacter() then
			return false
		end
	end

	local reached = false

	while running
		and not destroyed
		and generation == routeGeneration
		and root
		and root.Parent
		and humanoid
		and humanoid.Health > 0 do

		local current = root.Position
		local offset = target - current
		local distance = offset.Magnitude

		if distance <= 3 then
			root.CFrame = CFrame.new(target)
			reached = true
			break
		end

		local dt = RunService.Heartbeat:Wait()

		if dt > 0.1 then
			dt = 0.1
		end

		local step = math.min(
			speed * dt,
			distance
		)

		local nextPosition =
			current + offset.Unit * step

		root.CFrame =
			CFrame.new(nextPosition)

	end

	return reached
end

--------------------------------------------------
-- HOVER
--------------------------------------------------

local function hoverBetween(a, b, generation)

	local startTime = os.clock()
	local target = a

	while running
		and not destroyed
		and generation == routeGeneration
		and os.clock() - startTime < hoverDuration do

		if not root or not root.Parent
			or not humanoid
			or humanoid.Health <= 0 then

			return false
		end

		local success = moveTo(
			target,
			hoverSpeed,
			generation
		)

		if not success then
			return false
		end

		if target == a then
			target = b
		else
			target = a
		end
	end

	return true
end

--------------------------------------------------
-- ROUTE
--------------------------------------------------

local function startRoute()

	if running then
		return
	end

	running = true
	routeGeneration += 1

	local generation = routeGeneration

	task.spawn(function()

		while running
			and not destroyed
			and generation == routeGeneration do

			if not getCharacter() then
				task.wait(0.2)
				continue
			end

			------------------------------------------------
			-- เริ่มใหม่จากจุด 1 ทุกครั้ง
			------------------------------------------------

			local routeFailed = false

			for index = 1, #ROUTE do

				if not running
					or destroyed
					or generation ~= routeGeneration then

					return
				end

				if not humanoid
					or humanoid.Health <= 0 then

					routeFailed = true
					break
				end

				status.Text =
					"●  กำลังบิน  จุด " ..
					index .. "/4"

				local success = moveTo(
					ROUTE[index],
					flightSpeed,
					generation
				)

				if not success then
					routeFailed = true
					break
				end
			end

			------------------------------------------------
			-- ถ้าตาย/เกิดปัญหา
			-- กลับไปเริ่มจุด 1
			------------------------------------------------

			if routeFailed then

				status.Text = "●  เริ่มเส้นทางใหม่..."

				-- รอ Character ใหม่
				if not humanoid
					or humanoid.Health <= 0 then

					local newCharacter =
						player.CharacterAdded:Wait()

					if newCharacter then
						task.wait(0.3)
						getCharacter()
					end
				end

				task.wait(0.1)

				continue
			end

			------------------------------------------------
			-- ลอยระหว่างจุด 3 และ 4
			------------------------------------------------

			if running and not destroyed then

				status.Text =
					"●  ลอยระหว่างจุด 3 ↔ 4"

				local hoverOK =
					hoverBetween(
						ROUTE[3],
						ROUTE[4],
						generation
					)

				if not hoverOK then
					continue
				end
			end

			------------------------------------------------
			-- รีเซ็ต
			------------------------------------------------

			if running and not destroyed then

				status.Text = "●  รีเซ็ต..."

				task.wait(0.15)

				if humanoid and humanoid.Parent then
					humanoid.Health = 0
				end

				-- รอเกิดใหม่
				local newCharacter =
					player.CharacterAdded:Wait()

				if newCharacter
					and running
					and not destroyed then

					task.wait(0.35)
					getCharacter()
				end
			end
		end
	end)
end

--------------------------------------------------
-- STOP
--------------------------------------------------

local function stopRoute()

	running = false
	routeGeneration += 1

	status.Text = "●  หยุดแล้ว"
	status.TextColor3 =
		Color3.fromRGB(190, 180, 210)
end

--------------------------------------------------
-- BUTTONS
--------------------------------------------------

startButton.Activated:Connect(function()

	status.TextColor3 =
		Color3.fromRGB(190, 150, 255)

	startRoute()
end)

stopButton.Activated:Connect(function()
	stopRoute()
end)

--------------------------------------------------
-- MINIMIZE
--------------------------------------------------

local minimized = false

minimize.Activated:Connect(function()

	minimized = not minimized

	if minimized then

		content.Visible = false

		main.Size =
			UDim2.fromOffset(190, 58)

		minimize.Text = "+"

	else

		content.Visible = true

		main.Size =
			UDim2.fromOffset(285, 390)

		minimize.Text = "−"
	end
end)

--------------------------------------------------
-- DRAG MOBILE
--------------------------------------------------

local dragging = false
local dragStart
local startPosition
local dragInput

local function updateDrag(input)

	local delta =
		input.Position - dragStart

	main.Position =
		UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
end

header.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true

		dragStart = input.Position
		startPosition = main.Position

		dragInput = input
	end
end)

header.InputChanged:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if dragging
		and input == dragInput then

		updateDrag(input)
	end
end)

UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = false
	end
end)

--------------------------------------------------
-- DELETE MENU
--------------------------------------------------

close.Activated:Connect(function()

	destroyed = true
	running = false
	routeGeneration += 1

	if gui then
		gui:Destroy()
	end
end)

--------------------------------------------------
-- CHARACTER DEATH DETECTION
--------------------------------------------------

player.CharacterAdded:Connect(function(newCharacter)

	if destroyed then
		return
	end

	task.wait(0.2)

	character = newCharacter
	humanoid =
		newCharacter:FindFirstChildOfClass("Humanoid")
	root =
		newCharacter:FindFirstChild("HumanoidRootPart")

	if humanoid then

		humanoid.Died:Connect(function()

			if running and not destroyed then

				-- ทำให้รอบปัจจุบันถูกยกเลิก
				-- แล้วเริ่มใหม่จากจุด 1
				routeGeneration += 1

				status.Text =
					"●  ตายแล้ว → เริ่มจุด 1"

				task.wait(0.1)

				if running and not destroyed then
					startRoute()
				end
			end
		end)
	end
end)
