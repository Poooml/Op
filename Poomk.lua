local a=game:GetService("Players")local b=game:GetService("RunService")local c=game:GetService("UserInputService")
local d=a.LocalPlayer
if not d then repeat task.wait(.1)d=a.LocalPlayer until d end
local e=d:WaitForChild("PlayerGui",10)if not e then return end

local f={Speed=350,LoopTime=11,Waypoints={Vector3.new(-53.2,84.6,817.5),Vector3.new(-48.9,40.2,8815.4),Vector3.new(-53.1,-355.8,9482.5),Vector3.new(-55.5,-356.3,9505.6)}}
local g,h,i,j,k=false,0,false,nil,nil

local l=e:FindFirstChild("PremiumFlyUI")if l then l:Destroy()end

local m=Instance.new("ScreenGui")m.Name="PremiumFlyUI"m.ResetOnSpawn=false m.IgnoreGuiInset=true m.ZIndexBehavior=Enum.ZIndexBehavior.Sibling m.Parent=e

local n=Instance.new("Frame")n.Size=UDim2.fromOffset(230,110)n.Position=UDim2.new(0,20,.5,-55)n.BackgroundColor3=Color3.fromRGB(28,18,42)n.BackgroundTransparency=.05 n.BorderSizePixel=0 n.Parent=m
Instance.new("UICorner",n).CornerRadius=UDim.new(0,20)

local o=Instance.new("UIStroke")o.Color=Color3.fromRGB(180,120,255)o.Thickness=2 o.Transparency=.25 o.Parent=n

local p=Instance.new("UIGradient")p.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(55,30,85)),ColorSequenceKeypoint.new(.5,Color3.fromRGB(38,20,62)),ColorSequenceKeypoint.new(1,Color3.fromRGB(22,12,38))})p.Rotation=90 p.Parent=n

local q=Instance.new("TextLabel")q.Size=UDim2.new(1,-20,0,28)q.Position=UDim2.fromOffset(10,8)q.BackgroundTransparency=1 q.Text="✦ PREMIUM FLY ✦"q.TextColor3=Color3.fromRGB(235,210,255)q.Font=Enum.Font.GothamBold q.TextSize=16 q.TextXAlignment=Enum.TextXAlignment.Center q.Parent=n

local r=Instance.new("TextButton")r.Size=UDim2.new(1,-20,0,50)r.Position=UDim2.fromOffset(10,45)r.BackgroundColor3=Color3.fromRGB(145,85,230)r.BorderSizePixel=0 r.Text="▶  START"r.TextColor3=Color3.fromRGB(255,255,255)r.Font=Enum.Font.GothamBold r.TextSize=15 r.AutoButtonColor=false r.Parent=n
Instance.new("UICorner",r).CornerRadius=UDim.new(0,14)

local s=Instance.new("UIStroke")s.Color=Color3.fromRGB(210,160,255)s.Thickness=1.5 s.Transparency=.35 s.Parent=r

local t=Instance.new("UIGradient")t.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(175,110,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(130,70,210))})t.Rotation=90 t.Parent=r

local function u(v)if v and v.Parent then v.AssemblyLinearVelocity=Vector3.zero v.AssemblyAngularVelocity=Vector3.zero end end

local function w()local x=d.Character if not x then return nil,nil end local y=x:FindFirstChildOfClass("Humanoid")local z=x:FindFirstChild("HumanoidRootPart")if y and z and y.Health>0 then return y,z end return nil,nil end

local function A(B,C,D)while g and h==D do if not B or not B.Parent then return false end local E=B.Parent:FindFirstChildOfClass("Humanoid")if not E or E.Health<=0 then return false end local F=B.Position local G=C-F local H=G.Magnitude if H<=1 then B.CFrame=CFrame.new(C)u(B)return true end local I=b.Heartbeat:Wait()local J=math.min(f.Speed*I,H)B.CFrame=CFrame.new(F+G.Unit*J)u(B)end return false end

local function Warp(B,C)if B and B.Parent then B.CFrame=CFrame.new(C)u(B)return true end return false end

local function K(L,M,N,O,P)local Q=tick()while g and h==P do if not L or not L.Parent then return false end local R=L.Parent:FindFirstChildOfClass("Humanoid")if not R or R.Health<=0 then return false end local S=tick()-Q if S>=O then return true end local T=(math.sin(S*math.pi*2/1.2)+1)/2 L.CFrame=CFrame.new(M:Lerp(N,T))u(L)b.Heartbeat:Wait()end return false end

local function U(V)while g and h==V do local W,X repeat if not g or h~=V then return end W,X=w()if not X then task.wait(.2)end until X local Y=false local Z Z=W.Died:Connect(function()Y=true end)for aa,ab in ipairs(f.Waypoints)do if not g or h~=V or Y then break end if aa==1 or aa==3 then if not Warp(X,ab)then break end task.wait(.1)else if not A(X,ab,V)then break end end if aa==#f.Waypoints then K(X,f.Waypoints[#f.Waypoints-1],f.Waypoints[#f.Waypoints],f.LoopTime,V)end end if Z then Z:Disconnect()end if not g or h~=V then break end if Y then repeat task.wait(.2)until d.Character and d.Character:FindFirstChildOfClass("Humanoid")task.wait(.5)else if W and W.Parent and W.Health>0 then W.Health=0 end task.wait(1)end end end

local function ac()if g then r.Text="■  STOP"r.BackgroundColor3=Color3.fromRGB(200,75,130)s.Color=Color3.fromRGB(255,150,190)if t then t.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(230,100,150)),ColorSequenceKeypoint.new(1,Color3.fromRGB(180,60,110))})end else r.Text="▶  START"r.BackgroundColor3=Color3.fromRGB(145,85,230)s.Color=Color3.fromRGB(210,160,255)if t then t.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(175,110,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(130,70,210))})end end end

local function ad()if g then return end g=true h+=1 local ae=h ac()task.spawn(function()local af,ag=pcall(function()U(ae)end)if not af then g=false h+=1 ac()warn("[PremiumFly] "..tostring(ag))end end)end

local function ah()g=false h+=1 local _,ai=w()u(ai)ac()end

local function aj()if g then ah()else ad()end end

r.MouseButton1Click:Connect(aj)

n.InputBegan:Connect(function(ak)if ak.UserInputType==Enum.UserInputType.MouseButton1 or ak.UserInputType==Enum.UserInputType.Touch then i=true j=ak.Position k=n.Position end end)

c.InputChanged:Connect(function(al)if not i then return end if al.UserInputType==Enum.UserInputType.MouseMovement or al.UserInputType==Enum.UserInputType.Touch then local am=al.Position-j n.Position=UDim2.new(k.X.Scale,k.X.Offset+am.X,k.Y.Scale,k.Y.Offset+am.Y)end end)

c.InputEnded:Connect(function(an)if an.UserInputType==Enum.UserInputType.MouseButton1 or an.UserInputType==Enum.UserInputType.Touch then i=false end end)

local ao={}

local function ap()g=false h+=1 local _,aq=w()u(aq)if m then m:Destroy()end end

c.TouchStarted:Connect(function(ar)ao[ar]=true local as=0 for _ in pairs(ao)do as+=1 end if as>=3 then ap()end end)
c.TouchEnded:Connect(function(at)ao[at]=nil end)
c.TouchPan:Connect(function()end)

print("[PremiumFly] Private Script Loaded")
