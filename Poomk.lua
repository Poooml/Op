--// ============================================================
--// PREMIUM MOBILE UI + AUTO FLY LOOP (Delta / Executor)
--// ============================================================

if _G.__PremiumFlyLoaded then
    pcall(function() _G.__PremiumFlyDestroy() end)
end
_G.__PremiumFlyLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// ---------- CONFIG ----------
local CONFIG = {
    Speed = 1000,                     -- ความเร็วการบิน (studs/sec)
    HoverDuration = 5,                -- เวลาลอยระหว่างจุด 3-4 (วินาที)
    Waypoints = {
        Vector3.new(-53.2,  84.6,  817.5),
        Vector3.new(-48.9,  40.2, 8815.4),
        Vector3.new(-53.1, -355.8, 9482.5),
        Vector3.new(-55.5, -356.3, 9505.6),
    },
}

--// ---------- STATE ----------
local State = {
    Running = false,
    Generation = 0,        -- ป้องกัน loop เก่าทำงานหลัง start ใหม่
    Connections = {},
    Thread = nil,
}

--// ---------- CLEANUP STORAGE ----------
local TrackedConnections = {}
local TrackedInstances = {}

local function track(conn)
    table.insert(TrackedConnections, conn)
    return conn
end

local function trackInst(inst)
    table.insert(TrackedInstances, inst)
    return inst
end

--// ---------- SAFE DESTROY ----------
local function fullCleanup()
    State.Running = false
    State.Generation += 1

    for _, c in ipairs(TrackedConnections) do
        pcall(function() c:Disconnect() end)
    end
    TrackedConnections = {}

    for _, i in ipairs(TrackedInstances) do
        pcall(function() i:Destroy() end)
    end
    TrackedInstances = {}

    if _G.__PremiumFlyDestroy then
        _G.__PremiumFlyDestroy = nil
    end
    _G.__PremiumFlyLoaded = false
end

_G.__PremiumFlyDestroy = fullCleanup

--// ---------- GUI ----------
local parentGui = (function()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    if CoreGui then return CoreGui end
    return PlayerGui
end)()

-- ลบของเก่า
pcall(function()
    local old = parentGui:FindFirstChild("PremiumFlyUI")
    if old then old:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumFlyUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentGui
trackInst(ScreenGui)

--// ---------- MAIN PANEL ----------
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 260, 0, 340)
Main.Position = UDim2.new(0, 20, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
trackInst(Main)

local mainCorner = Instance.new("UICorner", Main)
mainCorner.CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = Color3.fromRGB(90, 130, 255)
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.3

local mainGradient = Instance.new("UIGradient", Main)
mainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 36)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 18)),
}
mainGradient.Rotation = 90

--// ---------- HEADER ----------
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "PREMIUM FLY"
Title.TextColor3 = Color3.fromRGB(230, 235, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- ปุ่มย่อ
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -74, 0.5, -15)
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(200, 210, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.AutoButtonColor = false
MinBtn.Parent = Header
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

-- ปุ่มปิด (ซ่อนไว้ใช้เฉพาะในเมนู)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 25, 35)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 180, 180)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

--// ---------- CONTENT ----------
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -24, 1, -60)
Content.Position = UDim2.new(0, 12, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = Main

local function makeLabel(text, y, height)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, height or 22)
    l.Position = UDim2.new(0, 0, 0, y)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamMedium
    l.Text = text
    l.TextColor3 = Color3.fromRGB(180, 190, 220)
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = Content
    return l
end

local function makeButton(text, y, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 40)
    b.Position = UDim2.new(0, 0, 0, y)
    b.BackgroundColor3 = color or Color3.fromRGB(50, 90, 200)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.AutoButtonColor = false
    b.Parent = Content
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", b)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.85
    stroke.Thickness = 1
    return b
end

--// Speed input
makeLabel("⚡ Speed (studs/sec)", 0, 20)

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(1, 0, 0, 38)
SpeedBox.Position = UDim2.new(0, 0, 0, 22)
SpeedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
SpeedBox.Text = tostring(CONFIG.Speed)
SpeedBox.TextColor3 = Color3.fromRGB(230, 235, 255)
SpeedBox.Font = Enum.Font.GothamBold
SpeedBox.TextSize = 14
SpeedBox.ClearTextOnFocus = false
SpeedBox.Parent = Content
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0, 10)
local sbStroke = Instance.new("UIStroke", SpeedBox)
sbStroke.Color = Color3.fromRGB(90, 130, 255)
sbStroke.Transparency = 0.5

local function applySpeed()
    local n = tonumber(SpeedBox.Text)
    if n and n > 0 and n <= 5000 then
        CONFIG.Speed = n
        SpeedBox.TextColor3 = Color3.fromRGB(200, 255, 200)
    else
        SpeedBox.TextColor3 = Color3.fromRGB(255, 150, 150)
    end
end
track(SpeedBox.FocusLost:Connect(applySpeed))

--// Status
makeLabel("📡 Status", 72, 20)

local StatusBox = Instance.new("TextLabel")
StatusBox.Size = UDim2.new(1, 0, 0, 40)
StatusBox.Position = UDim2.new(0, 0, 0, 94)
StatusBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
StatusBox.Text = "Idle"
StatusBox.TextColor3 = Color3.fromRGB(160, 200, 255)
StatusBox.Font = Enum.Font.GothamBold
StatusBox.TextSize = 13
StatusBox.Parent = Content
Instance.new("UICorner", StatusBox).CornerRadius = UDim.new(0, 10)

--// Start / Stop
local StartBtn = makeButton("▶  START", 148, Color3.fromRGB(40, 160, 90))
local StopBtn  = makeButton("■  STOP",  196, Color3.fromRGB(180, 50, 60))

--// ปุ่มลบเมนู (อยู่ในหมวดสุดท้าย)
makeLabel("⚠ Danger Zone", 246, 18)

local DeleteBtn = makeButton("🗑  ลบเมนู / ลบสคริปต์", 266, Color3.fromRGB(120, 30, 40))

--// ---------- MINIMIZED BUTTON ----------
local MiniBtn = Instance.new("TextButton")
MiniBtn.Name = "MiniBtn"
MiniBtn.Size = UDim2.new(0, 54, 0, 54)
MiniBtn.Position = UDim2.new(0, 20, 0.5, -27)
MiniBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 140)
MiniBtn.Text = "✈"
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.TextSize = 24
MiniBtn.AutoButtonColor = false
MiniBtn.Visible = false
MiniBtn.Active = true
MiniBtn.Draggable = true
MiniBtn.Parent = ScreenGui
trackInst(MiniBtn)
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(0, 14)
local miniStroke = Instance.new("UIStroke", MiniBtn)
miniStroke.Color = Color3.fromRGB(120, 180, 255)
miniStroke.Thickness = 1.5
miniStroke.Transparency = 0.3

--// ---------- ANIMATION HELPERS ----------
local function fadeIn(frame, targetPos)
    frame.Visible = true
    frame.Position = UDim2.new(targetPos.X.Scale, targetPos.X.Offset, targetPos.Y.Scale, targetPos.Y.Offset + 12)
    frame.BackgroundTransparency = 1
    TweenService:Create(frame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = targetPos,
        BackgroundTransparency = 0.05,
    }):Play()
end

--// ปุ่มย่อ
track(MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    MiniBtn.Visible = true
    -- ตำแหน่ง MiniBtn อิงจาก Main
    MiniBtn.Position = UDim2.new(0, Main.AbsolutePosition.X, 0, Main.AbsolutePosition.Y)
end))

--// ปุ่มกางกลับ
track(MiniBtn.MouseButton1Click:Connect(function()
    MiniBtn.Visible = false
    Main.Visible = true
    fadeIn(Main, UDim2.new(0, Main.Position.X.Offset, 0, Main.Position.Y.Offset))
end))

--// ปุ่มปิด (header) = ย่อเหมือนกันเพื่อความปลอดภัย
track(CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    MiniBtn.Visible = true
end))

--// ---------- FLY LOGIC ----------
local function getHumanoidAndRoot()
    local char = LocalPlayer.Character
    if not char then return nil, nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
    if hum and root and hum.Health > 0 then
        return hum, root
    end
    return nil, nil
end

-- รอให้ character พร้อม (หลัง respawn)
local function waitForCharacter(timeout)
    timeout = timeout or 10
    local t0 = tick()
    while tick() - t0 < timeout do
        if State.Generation == nil then return nil, nil end
        local hum, root = getHumanoidAndRoot()
        if hum and root then return hum, root end
        task.wait(0.1)
    end
    return nil, nil
end

-- เคลียร์ velocity ทุกอย่างเพื่อให้ตัวละครนิ่ง
local function freezeCharacter(root)
    if not root then return end
    pcall(function()
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)
end

-- ตั้งค่า physics สำหรับการบิน
local function setupFly(root)
    pcall(function()
        root.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
    end)
end

-- เคลื่อนที่ไปยัง waypoint แบบนุ่มนวล
-- ใช้ lerp ต่อเฟรมตามความเร็ว (studs/sec)
local function moveTo(root, target, gen)
    local last = tick()
    while State.Running and State.Generation == gen do
        if not root or not root.Parent then return false end

        local now = tick()
        local dt = now - last
        last = now

        local pos = root.Position
        local delta = target - pos
        local dist = delta.Magnitude
        if dist < 1 then
            freezeCharacter(root)
            return true
        end

        -- ระยะที่ควรขยับในเฟรมนี้
        local step = CONFIG.Speed * dt
        if step >= dist then
            root.CFrame = CFrame.new(target)
        else
            local dir = delta.Unit
            root.CFrame = CFrame.new(pos + dir * step)
        end
        -- ล็อคความเร็วไม่ให้ physics ตีกลับ
        pcall(function()
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)

        RunService.Heartbeat:Wait()
    end
    return false
end

-- ลอยระหว่างจุด 3-4
local function hoverBetween(root, pA, pB, duration, gen)
    local t0 = tick()
    local period = 1.2
    while State.Running and State.Generation == gen do
        local elapsed = tick() - t0
        if elapsed >= duration then break end
        if not root or not root.Parent then return false end

        local alpha = (math.sin(elapsed * (math.pi * 2 / period)) + 1) / 2
        local target = pA:Lerp(pB, alpha)
        root.CFrame = CFrame.new(target)

        pcall(function()
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)

        RunService.Heartbeat:Wait()
    end
    return true
end

--// ---------- STATUS ----------
local function setStatus(text, color)
    StatusBox.Text = text
    if color then StatusBox.TextColor3 = color end
end

--// ---------- MAIN LOOP ----------
local function flyLoop(gen)
    while State.Running and State.Generation == gen do
        -- รอ character ให้พร้อม
        local hum, root = waitForCharacter(15)
        if not root then
            setStatus("⏳ รอตัวละคร...", Color3.fromRGB(255, 200, 120))
            task.wait(0.5)
            continue
        end
        setupFly(root)

        -- ฟังการตายระหว่างทาง
        local died = false
        local deathConn
        deathConn = hum.Died:Connect(function()
            died = true
        end)
        track(deathConn)

        local alive = true

        for i, wp in ipairs(CONFIG.Waypoints) do
            if not (State.Running and State.Generation == gen) then alive = false break end
            if died then alive = false break end

            -- refresh root (เผื่อ respawn)
            local _, curRoot = getHumanoidAndRoot()
            if not curRoot then alive = false break end
            root = curRoot

            setStatus("✈ กำลังไปจุดที่ " .. i .. " / 4", Color3.fromRGB(120, 200, 255))

            local ok = moveTo(root, wp, gen)
            if not ok then alive = false break end

            -- เมื่อถึงจุดที่ 4 → hover 5 วิ
            if i == 4 then
                setStatus("🌀 กำลังวน 5 วินาที...", Color3.fromRGB(200, 160, 255))
                local p3 = CONFIG.Waypoints[3]
                local p4 = CONFIG.Waypoints[4]
                local _, hr = getHumanoidAndRoot()
                if hr then
                    hoverBetween(hr, p3, p4, CONFIG.HoverDuration, gen)
                end
            end
        end

        if deathConn then deathConn:Disconnect() end

        if not (State.Running and State.Generation == gen) then break end

        -- รีเซ็ต / ตาย
        setStatus("💀 รีเซ็ตตัวละคร...", Color3.fromRGB(255, 150, 150))
        pcall(function()
            LocalPlayer.Character:BreakJoints()
        end)
        task.wait(0.2)
        pcall(function()
            LocalPlayer.Character:ClearAllChildren()
        end)

        -- รอ respawn
        setStatus("⏳ รอเกิดใหม่...", Color3.fromRGB(255, 200, 120))
        task.wait(1.0)
        waitForCharacter(15)

        -- หน่วงเล็กน้อยก่อนเริ่มรอบใหม่
        task.wait(0.5)
    end

    if State.Running then
        setStatus("Idle", Color3.fromRGB(160, 200, 255))
    end
end

--// ---------- START / STOP ----------
local function startFly()
    if State.Running then
        setStatus("⚠ กำลังทำงานอยู่แล้ว", Color3.fromRGB(255, 200, 120))
        return
    end
    applySpeed()
    State.Running = true
    State.Generation += 1
    local gen = State.Generation

    setStatus("🚀 เริ่มการบิน...", Color3.fromRGB(150, 255, 180))

    task.spawn(function()
        local ok, err = pcall(flyLoop, gen)
        if not ok then
            warn("[PremiumFly] error:", err)
            setStatus("❌ Error", Color3.fromRGB(255, 120, 120))
            State.Running = false
        end
    end)
end

local function stopFly()
    if not State.Running then
        setStatus("Idle", Color3.fromRGB(160, 200, 255))
        return
    end
    State.Running = false
    State.Generation += 1
    setStatus("⏹ หยุดแล้ว", Color3.fromRGB(255, 200, 120))
    -- หยุดการเคลื่อนที่ปัจจุบัน
    local _, root = getHumanoidAndRoot()
    freezeCharacter(root)
end

track(StartBtn.MouseButton1Click:Connect(startFly))
track(StopBtn.MouseButton1Click:Connect(stopFly))

--// ปุ่มลบเมนูทั้งหมด
track(DeleteBtn.MouseButton1Click:Connect(function()
    State.Running = false
    State.Generation += 1

    -- แจ้งเตือนสั้น ๆ
    setStatus("🗑 กำลังลบ...", Color3.fromRGB(255, 150, 150))

    local _, root = getHumanoidAndRoot()
    freezeCharacter(root)

    task.wait(0.25)
    fullCleanup()
end))

--// ---------- BUTTON FEEDBACK ----------
local function addPressEffect(btn)
    track(btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundTransparency = 0.35}):Play()
    end))
    track(btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play()
    end))
    track(btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play()
    end))
end
addPressEffect(StartBtn)
addPressEffect(StopBtn)
addPressEffect(DeleteBtn)
addPressEffect(MinBtn)
addPressEffect(CloseBtn)
addPressEffect(MiniBtn)

--// ---------- CHARACTER RESPAWN GUARD ----------
-- รีเซ็ต State เมื่อตายนอกลูป
track(LocalPlayer.CharacterAdded:Connect(function()
    if State.Running then
        -- ปล่อยให้ loop หลักจัดการต่อเอง
    else
        setStatus("Idle", Color3.fromRGB(160, 200, 255))
    end
end))

print("[PremiumFly] โหลดสำเร็จ ✅")
