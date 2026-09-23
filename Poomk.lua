local a=game:GetService("HttpService")local b=game:GetService("TweenService")local c=game:GetService("TeleportService")local d=game:GetService("Players")local e=game:GetService("MarketplaceService")local f=game:GetService("UserInputService")local g=d.LocalPlayer
local h=nil
if syn and syn.request then h=syn.request elseif http and http.request then h=http.request elseif http_request then h=http_request elseif fluxus and fluxus.request then h=fluxus.request elseif request then h=request else error("\228\184\141\228\184\158\228\184\158\228\184\159\228\184\177\228\184\129\228\184\138\228\184\177\228\184\153 HTTP \228\184\151\228\184\181\224\184\163\224\184\173\224\184\135\224\184\163\224\184\177\224\184\154!")end
local i="Unknown"pcall(function()local j=e:GetProductInfo(game.PlaceId)i=j.Name or i end)
local k="VisitedServers.json"local l={}
local function m()pcall(function()if isfile and isfile(k)then local n=a:JSONDecode(readfile(k))if type(n)=="table"then l=n end end end)end
local function o()pcall(function()if writefile then writefile(k,a:JSONEncode(l))end end)end
m()
local function p(q,r)r=r or q local s,t,u,v
r.InputBegan:Connect(function(w)if w.UserInputType==Enum.UserInputType.MouseButton1 or w.UserInputType==Enum.UserInputType.Touch then s=true u=w.Position v=q.AbsolutePosition
w.Changed:Connect(function()if w.UserInputState==Enum.UserInputState.End then s=false end end)end end)
r.InputChanged:Connect(function(w)if w.UserInputType==Enum.UserInputType.MouseMovement or w.UserInputType==Enum.UserInputType.Touch then t=w end end)
f.InputChanged:Connect(function(w)if w==t and s then local x=w.Position-u q.Position=UDim2.new(0,v.X+x.X,0,v.Y+x.Y)end end)end
local y=Instance.new("ScreenGui")y.Name="LowServerFinder"y.Parent=g:WaitForChild("PlayerGui")y.ZIndexBehavior=Enum.ZIndexBehavior.Sibling y.ResetOnSpawn=false
local z=Instance.new("Frame")z.Name="MainFrame"z.Parent=y z.BackgroundColor3=Color3.fromRGB(22,22,28)z.BorderSizePixel=0 z.Position=UDim2.new(0.5,-370,0.5,-240)z.Size=UDim2.new(0,740,0,480)z.ClipsDescendants=true
local A=Instance.new("UICorner")A.CornerRadius=UDim.new(0,16)A.Parent=z
local B=Instance.new("UIStroke")B.Thickness=1.5 B.Color=Color3.fromRGB(55,55,70)B.Parent=z
local C=Instance.new("Frame")C.Name="TitleBar"C.Parent=z C.BackgroundColor3=Color3.fromRGB(32,32,42)C.BorderSizePixel=0 C.Size=UDim2.new(1,0,0,50)
local D=Instance.new("UICorner")D.CornerRadius=UDim.new(0,16)D.Parent=C
local E=Instance.new("Frame")E.Parent=C E.BackgroundColor3=Color3.fromRGB(32,32,42)E.BorderSizePixel=0 E.Position=UDim2.new(0,0,0.5,0)E.Size=UDim2.new(1,0,0.5,0)
local F=Instance.new("TextLabel")F.Name="Title"F.Parent=C F.BackgroundTransparency=1 F.Position=UDim2.new(0,18,0,0)F.Size=UDim2.new(0.65,0,1,0)F.Font=Enum.Font.GothamBold F.Text="\240\159\140\144  \224\184\132\224\185\137\224\184\153\224\184\171\224\184\178\224\185\128\224\184\139\224\184\180\224\184\163\224\185\140\224\184\167\224\184\185\224\184\173\224\184\163\224\185\140  \226\128\162  "..i F.TextColor3=Color3.fromRGB(245,245,250)F.TextSize=17 F.TextXAlignment=Enum.TextXAlignment.Left F.TextTruncate=Enum.TextTruncate.AtEnd
local G=Instance.new("TextButton")G.Name="Minimize"G.Parent=C G.BackgroundColor3=Color3.fromRGB(70,70,85)G.BorderSizePixel=0 G.Position=UDim2.new(1,-84,0.5,-13)G.Size=UDim2.new(0,26,0,26)G.Font=Enum.Font.GothamBold G.Text="\226\136\146"G.TextColor3=Color3.fromRGB(255,255,255)G.TextSize=18
local H=Instance.new("UICorner")H.CornerRadius=UDim.new(0,6)H.Parent=G
local I=Instance.new("TextButton")I.Name="Close"I.Parent=C I.BackgroundColor3=Color3.fromRGB(210,55,55)I.BorderSizePixel=0 I.Position=UDim2.new(1,-48,0.5,-13)I.Size=UDim2.new(0,26,0,26)I.Font=Enum.Font.GothamBold I.Text="\226\156\149"I.TextColor3=Color3.fromRGB(255,255,255)I.TextSize=13
local J=Instance.new("UICorner")J.CornerRadius=UDim.new(0,6)J.Parent=I
local K=Instance.new("Frame")K.Name="Content"K.Parent=z K.BackgroundTransparency=1 K.Position=UDim2.new(0,0,0,50)K.Size=UDim2.new(1,0,1,-50)
local L=Instance.new("TextLabel")L.Name="StatusLabel"L.Parent=K L.BackgroundTransparency=1 L.Position=UDim2.new(0,18,0,10)L.Size=UDim2.new(1,-36,0,22)L.Font=Enum.Font.Gotham L.Text="\224\184\158\224\184\163\224\185\137\224\184\173\224\184\161\224\185\131\224\184\138\224\185\137\224\184\135\224\184\178\224\184\153 \226\128\162 \224\184\129\224\184\148\224\184\155\224\184\184\224\185\136\224\184\161 \"\224\184\132\224\185\137\224\184\153\224\184\171\224\184\178\224\185\128\224\184\139\224\184\180\224\184\163\224\185\140\224\184\167\224\184\185\224\184\173\224\184\163\" \224\185\128\224\184\158\224\184\183\224\185\136\224\184\173\224\185\128\224\184\163\224\184\180\224\185\136\224\184\161"L.TextColor3=Color3.fromRGB(150,150,170)L.TextSize=13 L.TextXAlignment=Enum.TextXAlignment.Left
local M=Instance.new("Frame")M.Name="ProgressBG"M.Parent=K M.BackgroundColor3=Color3.fromRGB(40,40,52)M.BorderSizePixel=0 M.Position=UDim2.new(0,18,0,36)M.Size=UDim2.new(1,-36,0,5)M.Visible=false
local N=Instance.new("UICorner")N.CornerRadius=UDim.new(1,0)N.Parent=M
local O=Instance.new("Frame")O.Name="ProgressFill"O.Parent=M O.BackgroundColor3=Color3.fromRGB(70,140,255)O.BorderSizePixel=0 O.Size=UDim2.new(0,0,1,0)
local P=Instance.new("UICorner")P.CornerRadius=UDim.new(1,0)P.Parent=O
local Q=Instance.new("Frame")Q.Name="ButtonRow"Q.Parent=K Q.BackgroundTransparency=1 Q.Position=UDim2.new(0,18,0,50)Q.Size=UDim2.new(1,-36,0,34)
local R=Instance.new("TextButton")R.Name="FindButton"R.Parent=Q R.BackgroundColor3=Color3.fromRGB(55,125,255)R.BorderSizePixel=0 R.Size=UDim2.new(0,160,1,0)R.Font=Enum.Font.GothamBold R.Text="\240\159\148\141  \224\184\132\224\185\137\224\184\153\224\184\171\224\184\178\224\185\128\224\184\139\224\184\180\224\184\163\224\185\140\224\184\167\224\184\185\224\184\173\224\184\163"R.TextColor3=Color3.fromRGB(255,255,255)R.TextSize=13
local S=Instance.new("UICorner")S.CornerRadius=UDim.new(0,8)S.Parent=R
local T=Instance.new("TextButton")T.Name="ClearButton"T.Parent=Q T.BackgroundColor3=Color3.fromRGB(55,55,68)T.BorderSizePixel=0 T.Position=UDim2.new(0,170,0,0)T.Size=UDim2.new(0,90,1,0)T.Font=Enum.Font.GothamBold T.Text="\224\184\165\224\185\137\224\184\178\224\184\135\224\184\163\224\184\178\224\184\162\224\184\129\224\184\178\224\184\163"T.TextColor3=Color3.fromRGB(220,220,235)T.TextSize=13
local U=Instance.new("UICorner")U.CornerRadius=UDim.new(0,8)U.Parent=T
local V=Instance.new("TextLabel")V.Name="Legend"V.Parent=Q V.BackgroundTransparency=1 V.Position=UDim2.new(0,275,0,0)V.Size=UDim2.new(1,-275,1,0)V.Font=Enum.Font.Gotham V.Text="\240\159\159\162 \224\184\155\224\184\177\224\184\136\224\184\136\224\184\184\224\184\154\224\184\177\224\184\153    \240\159\159\166 \224\185\128\224\184\129\224\185\136\224\184\178    \226\151\139 \224\185\131\224\184\171\224\184\161\224\185\136"V.TextColor3=Color3.fromRGB(130,130,150)V.TextSize=12 V.TextXAlignment=Enum.TextXAlignment.Left
local W=Instance.new("ScrollingFrame")W.Name="ServerListFrame"W.Parent=K W.Active=true W.BackgroundColor3=Color3.fromRGB(30,30,38)W.BorderSizePixel=0 W.Position=UDim2.new(0,18,0,96)W.Size=UDim2.new(1,-36,1,-112)W.CanvasSize=UDim2.new(0,0,0,0)W.ScrollBarThickness=5 W.ScrollBarImageColor3=Color3.fromRGB(80,80,100)W.ScrollingDirection=Enum.ScrollingDirection.Y
local X=Instance.new("UICorner")X.CornerRadius=UDim.new(0,10)X.Parent=W
local Y=Instance.new("UIListLayout")Y.Parent=W Y.SortOrder=Enum.SortOrder.LayoutOrder Y.Padding=UDim.new(0,6)
local Z=Instance.new("UIPadding")Z.Parent=W Z.PaddingTop=UDim.new(0,8)Z.PaddingBottom=UDim.new(0,8)Z.PaddingLeft=UDim.new(0,8)Z.PaddingRight=UDim.new(0,8)
local _=Instance.new("Frame")_.Name="ServerFrame"_.BackgroundColor3=Color3.fromRGB(42,42,54)_.BorderSizePixel=0 _.Size=UDim2.new(1,-16,0,50)_.Visible=false
local aa=Instance.new("UICorner")aa.CornerRadius=UDim.new(0,8)aa.Parent=_
local ab=Instance.new("TextLabel")ab.Name="Tag"ab.Parent=_ ab.BackgroundColor3=Color3.fromRGB(70,70,90)ab.Position=UDim2.new(0,10,0.5,-11)ab.Size=UDim2.new(0,72,0,22)ab.Font=Enum.Font.GothamBold ab.Text="\224\185\131\224\184\171\224\184\161\224\185\136"ab.TextColor3=Color3.fromRGB(255,255,255)ab.TextSize=11
local ac=Instance.new("UICorner")ac.CornerRadius=UDim.new(0,5)ac.Parent=ab
local ad=Instance.new("TextLabel")ad.Name="ServerInfo"ad.Parent=_ ad.BackgroundTransparency=1 ad.Position=UDim2.new(0,95,0,0)ad.Size=UDim2.new(0.52,0,1,0)ad.Font=Enum.Font.Gotham ad.Text="\224\184\130\224\185\137\224\184\173\224\184\161\224\184\185\224\184\165\224\185\128\224\184\139\224\184\180\224\184\163\224\185\140\224\184\167\224\184\185\224\184\173\224\184\163"ad.TextColor3=Color3.fromRGB(225,225,240)ad.TextSize=13 ad.TextXAlignment=Enum.TextXAlignment.Left ad.TextYAlignment=Enum.TextYAlignment.Center
local ae=Instance.new("TextLabel")ae.Name="Players"ae.Parent=_ ae.BackgroundTransparency=1 ae.Position=UDim2.new(0.65,0,0,0)ae.Size=UDim2.new(0.16,0,1,0)ae.Font=Enum.Font.GothamBold ae.Text="0 / 0"ae.TextColor3=Color3.fromRGB(170,170,190)ae.TextSize=13 ae.TextXAlignment=Enum.TextXAlignment.Center
local af=Instance.new("TextButton")af.Name="Join"af.Parent=_ af.BackgroundColor3=Color3.fromRGB(60,125,255)af.BorderSizePixel=0 af.Position=UDim2.new(1,-95,0.5,-14)af.Size=UDim2.new(0,82,0,28)af.Font=Enum.Font.GothamBold af.Text="\224\185\128\224\184\130\224\185\137\224\184\178  \226\134\146"af.TextColor3=Color3.fromRGB(255,255,255)af.TextSize=12
local ag=Instance.new("UICorner")ag.CornerRadius=UDim.new(0,6)ag.Parent=af
local ah=Instance.new("TextButton")ah.Name="ResizeHandle"ah.Parent=z ah.BackgroundColor3=Color3.fromRGB(70,70,90)ah.BorderSizePixel=0 ah.Position=UDim2.new(1,-18,1,-18)ah.Size=UDim2.new(0,16,0,16)ah.Text=""ah.AutoButtonColor=false ah.ZIndex=10
local ai=Instance.new("UICorner")ai.CornerRadius=UDim.new(0,4)ai.Parent=ah
local aj=Instance.new("TextButton")aj.Name="HideShow"aj.Parent=y aj.BackgroundColor3=Color3.fromRGB(45,170,85)aj.BorderSizePixel=0 aj.Position=UDim2.new(0,14,0.5,-18)aj.Size=UDim2.new(0,72,0,36)aj.Font=Enum.Font.GothamBold aj.Text="\224\184\139\224\185\136\224\184\173\224\184\153"aj.TextColor3=Color3.fromRGB(255,255,255)aj.TextSize=13
local ak=Instance.new("UICorner")ak.CornerRadius=UDim.new(0,8)ak.Parent=aj
local al=false local am=false local an=false local ao=UDim2.new(0,740,0,480)
Y:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()W.CanvasSize=UDim2.new(0,0,0,Y.AbsoluteContentSize.Y+16)end)
local function ap()for _,aq in ipairs(W:GetChildren())do if aq:IsA("Frame")and aq.Name=="ServerFrameClone"then aq:Destroy()end end end
local function ar(as)local at=_:Clone()at.Name="ServerFrameClone"at.Visible=true at.Parent=W
local au=tostring(as.id)==tostring(game.JobId)local av=l[tostring(as.id)]==true
local aw=at:FindFirstChild("Tag")local ax=at:FindFirstChild("ServerInfo")local ay=at:FindFirstChild("Players")local az=at:FindFirstChild("Join")
if au then aw.Text="\224\184\155\224\184\177\224\184\136\224\184\136\224\184\184\224\184\154\224\184\177\224\184\153"aw.BackgroundColor3=Color3.fromRGB(35,150,75)at.BackgroundColor3=Color3.fromRGB(35,65,50)
elseif av then aw.Text="\224\185\128\224\184\129\224\185\136\224\184\178"aw.BackgroundColor3=Color3.fromRGB(45,105,195)at.BackgroundColor3=Color3.fromRGB(40,50,70)
else aw.Text="\224\185\131\224\184\171\224\184\161\224\185\136"aw.BackgroundColor3=Color3.fromRGB(75,75,95)at.BackgroundColor3=Color3.fromRGB(42,42,54)end
ax.Text="ID: "..tostring(as.id):sub(1,14).."..."ay.Text=string.format("\240\159\145\165 %d / %d",as.playing,as.maxPlayers)
az.MouseButton1Click:Connect(function()l[tostring(as.id)]=true o()c:TeleportToPlaceInstance(game.PlaceId,as.id,g)end)end
local function aA(aB)local aC=string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",game.PlaceId)if aB then aC=aC.."&cursor="..aB end
local aD=h({Url=aC,Method="GET"})if aD and aD.Body then return a:JSONDecode(aD.Body)end return nil end
local function aE()if al then return end al=true R.Text="\224\184\129\224\184\179\224\184\165\224\184\177\224\184\135\224\184\132\224\185\137\224\184\153\224\184\171\224\184\178..."R.BackgroundColor3=Color3.fromRGB(80,80,100)ap()
M.Visible=true O.Size=UDim2.new(0,0,1,0)
spawn(function()local aF={}local aG=nil local aH=0 local aI=0 local aJ=40
repeat aH=aH+1 local aK=aA(aG)
if aK and aK.data then for _,aL in ipairs(aK.data)do table.insert(aF,aL)end aI=#aF aG=aK.nextPageCursor
local aM=math.clamp(math.floor((aH/aJ)*100),0,95)L.Text=string.format("\224\184\129\224\184\179\224\184\165\224\184\177\224\184\135\224\184\132\224\185\137\224\184\153\224\184\171\224\184\178... %d%%  \226\128\162  \224\184\171\224\184\153\224\185\137\224\184\178 %d  \226\128\162  \224\184\158\224\184\154\224\185\129\224\184\165\224\185\137\224\184\167: %d \224\185\128\224\184\139\224\184\180\224\184\163\224\185\140\224\184\167\224\184\185\224\184\173\224\184\163",aM,aH,aI)
O:TweenSize(UDim2.new(aM/100,0,1,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.2,true)else break end task.wait(0.12)until not aG or aH>=60
table.sort(aF,function(aN,aO)return aN.playing<aO.playing end)
local aP=0 for _,aQ in ipairs(aF)do if aQ.playing<aQ.maxPlayers then ar(aQ)aP=aP+1 end end
O:TweenSize(UDim2.new(1,0,1,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)
L.Text=string.format("\226\156\133 \224\185\128\224\184\170\224\184\163\224\185\135\224\184\136\224\184\170\224\184\180\224\185\137\224\184\153! \224\185\129\224\184\170\224\184\148\224\184\135 %d \224\185\128\224\184\139\224\184\180\224\184\163\224\185\140\224\184\167\224\184\185\224\184\173\224\184\163 (\224\185\128\224\184\163\224\184\181\224\184\162\224\184\136\224\184\178\224\184\129\224\184\132\224\184\153\224\184\153\224\185\137\224\184\173\224\184\162 \226\134\146 \224\184\161\224\184\178\224\184\129)",aP)
R.Text="\240\159\148\141  \224\184\132\224\185\137\224\184\153\224\184\171\224\184\178\224\185\128\224\184\139\224\184\180\224\184\163\224\185\140\224\184\167\224\184\185\224\184\173\224\184\163"R.BackgroundColor3=Color3.fromRGB(55,125,255)al=false
task.wait(1.1)M.Visible=false end)end
R.MouseButton1Click:Connect(aE)
T.MouseButton1Click:Connect(function()ap()L.Text="\224\184\165\224\185\137\224\184\178\224\184\135\224\184\163\224\184\178\224\184\162\224\184\129\224\184\178\224\184\163\224\185\129\224\184\165\224\185\137\224\184\167 \226\128\162 \224\184\158\224\184\163\224\185\137\224\184\173\224\184\161\224\185\131\224\184\138\224\185\137\224\184\135\224\184\178\224\184\153"M.Visible=false end)
G.MouseButton1Click:Connect(function()an=not an if an then K.Visible=false ah.Visible=false z:TweenSize(UDim2.new(0,z.AbsoluteSize.X,0,50),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)G.Text="+"else K.Visible=true ah.Visible=true z:TweenSize(ao,Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)G.Text="\226\136\146"end end)
I.MouseButton1Click:Connect(function()local aR=b:Create(z,TweenInfo.new(0.22,Enum.EasingStyle.Back,Enum.EasingDirection.In),{BackgroundTransparency=1,Size=UDim2.new(0,z.AbsoluteSize.X,0,0)})aR:Play()aR.Completed:Connect(function()y:Destroy()end)end)
aj.MouseButton1Click:Connect(function()if not am then z.Visible=false aj.Text="\224\185\129\224\184\170\224\184\148\224\184\135"aj.BackgroundColor3=Color3.fromRGB(55,125,255)am=true else z.Visible=true aj.Text="\224\184\139\224\185\136\224\184\173\224\184\153"aj.BackgroundColor3=Color3.fromRGB(45,170,85)am=false end end)
local aS=false local aT,aU
ah.InputBegan:Connect(function(aV)if aV.UserInputType==Enum.UserInputType.MouseButton1 or aV.UserInputType==Enum.UserInputType.Touch then aS=true aT=aV.Position aU=z.AbsoluteSize
aV.Changed:Connect(function()if aV.UserInputState==Enum.UserInputState.End then aS=false ao=z.Size end end)end end)
f.InputChanged:Connect(function(aV)if aS and(aV.UserInputType==Enum.UserInputType.MouseMovement or aV.UserInputType==Enum.UserInputType.Touch)then local aW=aV.Position-aT
local aX=math.clamp(aU.X+aW.X,480,1100)local aY=math.clamp(aU.Y+aW.Y,320,800)z.Size=UDim2.new(0,aX,0,aY)end end)
p(z,C)p(aj)
L.Text="\224\184\158\224\184\163\224\185\137\224\184\173\224\184\161\224\185\131\224\184\138\224\185\137\224\184\135\224\184\178\224\184\153 \226\128\162 \224\184\129\224\184\148\224\184\155\224\184\184\224\185\136\224\184\161 \"\224\184\132\224\185\137\224\184\153\224\184\171\224\184\178\224\185\128\224\184\139\224\184\180\224\184\163\224\185\140\224\184\167\224\184\185\224\184\173\224\184\163\" \224\185\128\224\184\158\224\184\183\224\185\136\224\184\173\224\185\128\224\184\163\224\184\180\224\185\136\224\184\161"
