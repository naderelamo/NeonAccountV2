-- LocalScript: Login + Panel centrado + Watermark + AimAssist potente (no snap) + ESP + FOV
-- PEGAR en StarterPlayer -> StarterPlayerScripts

-- CONFIG
local ACCOUNTS = {
	{user="Admin", pass="nader765"},
	{user="free1", pass="0809"},
	{user="NeonUser2", pass="M0nK#72"},
	{user="NeonUser3", pass="Zebra_88a"},
	{user="NeonUser4", pass="R!ver2025"},
	{user="NeonUser5", pass="NeonAcc2"},
	{user="NeonUser6", pass="Sky_7Paz"},
	{user="NeonUser7", pass="B0lt&44"},
	{user="NeonUser8", pass="Echo!Delta9"},
}
local EXPIRATION_DAYS = 90

-- AimAssist tuning (muy fuerte por defecto pero sigue siendo 'assist')
local AIM_KEY = Enum.UserInputType.MouseButton2 -- clic derecho
local AIM_MAX_DIST = 300
local AIM_MAX_ANGLE = 60
local AIM_STRENGTH_DEFAULT = 0.98 -- 0..1 (0 nada, 1 casi snap)
local AIM_CAM_LERP = 0.95          -- 0..1 (mayor = respuesta más rápida)
local FOV_DEFAULT = 180
local ESP_UPDATE_RATE = 0.12

-- servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
repeat task.wait() until player and player:FindFirstChild("PlayerGui")
local playerGui = player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- util
local function trim(s) return tostring(s):gsub("^%s*(.-)%s*$","%1") end
local function findAccount(u,p)
	for _,a in ipairs(ACCOUNTS) do if a.user==u and a.pass==p then return true end end
	return false
end

-- cleanup previos
for _,n in ipairs({"NeonLoginGui","NeonMainGui","NeonFOVGui","NeonWatermarkGui"}) do
	local g = playerGui:FindFirstChild(n)
	if g then pcall(function() g:Destroy() end) end
end

-- =========== WATERMARK (ARRIBA-DERECHA) ===========
local watermarkGui = Instance.new("ScreenGui", playerGui)
watermarkGui.Name = "NeonWatermarkGui"
watermarkGui.ResetOnSpawn = false
local watermarkLabel = Instance.new("TextLabel", watermarkGui)
watermarkLabel.Size = UDim2.new(0,220,0,24)
watermarkLabel.Position = UDim2.new(1,-230,0,8)
watermarkLabel.BackgroundTransparency = 1
watermarkLabel.Font = Enum.Font.GothamBold
watermarkLabel.TextSize = 16
watermarkLabel.TextColor3 = Color3.fromRGB(180,0,255)
watermarkLabel.Text = "NeonShop Account"
watermarkLabel.TextXAlignment = Enum.TextXAlignment.Right

-- =========== LOGIN GUI ===========
local loginGui = Instance.new("ScreenGui", playerGui)
loginGui.Name = "NeonLoginGui"
loginGui.ResetOnSpawn = false

local frame = Instance.new("Frame", loginGui)
frame.Size = UDim2.new(0,420,0,240)
frame.Position = UDim2.new(0.5, -210, 0.5, -120)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.BackgroundColor3 = Color3.fromRGB(18,20,28)
frame.BorderSizePixel = 0
local frameCorner = Instance.new("UICorner", frame); frameCorner.CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40); title.Position = UDim2.new(0,0,0,8)
title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBlack; title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255,110,180); title.Text = "NEONSHOP LOGIN"

local userBox = Instance.new("TextBox", frame)
userBox.Size = UDim2.new(0,360,0,42); userBox.Position = UDim2.new(0,30,0,78)
userBox.PlaceholderText = "Usuario"; userBox.Font = Enum.Font.Gotham; userBox.TextSize = 18
userBox.BackgroundColor3 = Color3.fromRGB(245,245,247)

local passBox = Instance.new("TextBox", frame)
passBox.Size = UDim2.new(0,360,0,42); passBox.Position = UDim2.new(0,30,0,126)
passBox.PlaceholderText = "Contraseña"; passBox.Font = Enum.Font.Gotham; passBox.TextSize = 18
passBox.BackgroundColor3 = Color3.fromRGB(245,245,247)

local loginBtn = Instance.new("TextButton", frame)
loginBtn.Size = UDim2.new(0,180,0,42); loginBtn.Position = UDim2.new(0.5,-90,1,-56)
loginBtn.AnchorPoint = Vector2.new(0.5,1)
loginBtn.Text = "Iniciar sesión"; loginBtn.Font = Enum.Font.GothamBold; loginBtn.TextSize = 18
loginBtn.BackgroundColor3 = Color3.fromRGB(160,60,200); loginBtn.TextColor3 = Color3.fromRGB(255,255,255)
local loginCorner = Instance.new("UICorner", loginBtn); loginCorner.CornerRadius = UDim.new(0,10)

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1,-20,0,20); statusLabel.Position = UDim2.new(0,10,1,-26)
statusLabel.BackgroundTransparency = 1; statusLabel.Font = Enum.Font.Gotham; statusLabel.TextSize = 14
statusLabel.TextColor3 = Color3.fromRGB(255,140,140); statusLabel.Text = ""

-- =========== FOV GUI ===========
local fovGui = Instance.new("ScreenGui", playerGui)
fovGui.Name = "NeonFOVGui"
fovGui.ResetOnSpawn = false
local fovFrame = Instance.new("Frame", fovGui)
fovFrame.Name = "FOVFrame"
fovFrame.Size = UDim2.new(0, FOV_DEFAULT or FOV_DEFAULT, 0, FOV_DEFAULT or FOV_DEFAULT)
fovFrame.AnchorPoint = Vector2.new(0.5,0.5)
fovFrame.Position = UDim2.new(0.5,0,0.5,0)
fovFrame.BackgroundTransparency = 1
fovFrame.Visible = false
local fovStroke = Instance.new("UIStroke", fovFrame); fovStroke.Thickness = 2; fovStroke.Color = Color3.fromRGB(160,60,200)
local fovCorner = Instance.new("UICorner", fovFrame); fovCorner.CornerRadius = UDim.new(0,999)
fovGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() fovFrame.Position = UDim2.new(0.5,0,0.5,0) end)

-- =========== MAIN PANEL (post-login, creado pero oculto) ===========
local mainGui = Instance.new("ScreenGui", playerGui)
mainGui.Name = "NeonMainGui"
mainGui.ResetOnSpawn = false
mainGui.Enabled = false

local pframe = Instance.new("Frame", mainGui)
pframe.Size = UDim2.new(0,520,0,360)
pframe.Position = UDim2.new(0.5,-260,0.5,-180)
pframe.AnchorPoint = Vector2.new(0.5,0.5)
pframe.BackgroundColor3 = Color3.fromRGB(18,18,18)
local pfCorner = Instance.new("UICorner", pframe); pfCorner.CornerRadius = UDim.new(0,12)

local header = Instance.new("TextLabel", pframe)
header.Size = UDim2.new(1,0,0,44); header.Position = UDim2.new(0,0,0,0)
header.BackgroundTransparency = 1; header.Font = Enum.Font.GothamBold; header.TextSize = 20
header.TextColor3 = Color3.fromRGB(220,40,40); header.Text = "PANEL DE ENTRENAMIENTO"

local neonLabel = Instance.new("TextLabel", pframe)
neonLabel.Size = UDim2.new(0,220,0,28)
neonLabel.Position = UDim2.new(1,-240,0,8)
neonLabel.BackgroundTransparency = 1
neonLabel.Font = Enum.Font.GothamBold
neonLabel.TextSize = 16
neonLabel.TextColor3 = Color3.fromRGB(180,0,255)
neonLabel.Text = "NeonShop Account"
neonLabel.TextXAlignment = Enum.TextXAlignment.Right

local nameLabel = Instance.new("TextLabel", pframe)
nameLabel.Size = UDim2.new(0,360,0,28); nameLabel.Position = UDim2.new(0,126,0,76)
nameLabel.BackgroundTransparency = 1; nameLabel.Font = Enum.Font.Gotham; nameLabel.TextSize = 18
nameLabel.TextColor3 = Color3.fromRGB(220,220,220); nameLabel.Text = "Jugador: "..player.Name

-- botones
local function mkButton(parent,pos,text)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(0,240,0,44)
	b.Position = pos
	b.Font = Enum.Font.Gotham
	b.TextSize = 16
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(100,100,100)
	local c = Instance.new("UICorner", b); c.CornerRadius = UDim.new(0,8)
	return b
end

local aimBtn = mkButton(pframe, UDim2.new(0,18,0,176), "AimAssist: OFF")
local espBtn = mkButton(pframe, UDim2.new(0,280,0,176), "ESP: OFF")
local fovBtn = mkButton(pframe, UDim2.new(0,18,0,236), "FOV: OFF")
local trainBtn = mkButton(pframe, UDim2.new(0,280,0,236), "TrainingMode: OFF (Server)")

local strengthLabel = Instance.new("TextLabel", pframe)
strengthLabel.Size = UDim2.new(0,360,0,22); strengthLabel.Position = UDim2.new(0,18,0,288)
strengthLabel.BackgroundTransparency = 1; strengthLabel.Font = Enum.Font.Gotham; strengthLabel.TextSize = 14
strengthLabel.TextColor3 = Color3.fromRGB(200,200,200)
strengthLabel.Text = "Potencia AimAssist: "..tostring(math.floor(AIM_STRENGTH_DEFAULT*100)).."%"

-- runtime state
local state = {
	aimassist = false,
	esp = false,
	fov = false,
	aimstrength = AIM_STRENGTH_DEFAULT,
	fovsize = FOV_DEFAULT,
	trainingMode = false
}

-- toggle panel con RightShift (siempre existe)
mainGui.Enabled = false
UserInputService.InputBegan:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.RightShift then
		mainGui.Enabled = not mainGui.Enabled
	end
end)

-- handlers UI
aimBtn.MouseButton1Click:Connect(function()
	state.aimassist = not state.aimassist
	aimBtn.Text = "AimAssist: "..(state.aimassist and "ON" or "OFF")
	aimBtn.BackgroundColor3 = state.aimassist and Color3.fromRGB(80,160,80) or Color3.fromRGB(100,100,100)
end)
espBtn.MouseButton1Click:Connect(function()
	state.esp = not state.esp
	espBtn.Text = "ESP: "..(state.esp and "ON" or "OFF")
	espBtn.BackgroundColor3 = state.esp and Color3.fromRGB(80,160,80) or Color3.fromRGB(100,100,100)
end)
fovBtn.MouseButton1Click:Connect(function()
	state.fov = not state.fov
	fovBtn.Text = "FOV: "..(state.fov and "ON" or "OFF")
	fovBtn.BackgroundColor3 = state.fov and Color3.fromRGB(80,160,80) or Color3.fromRGB(100,100,100)
	fovFrame.Visible = state.fov
end)
trainBtn.MouseButton1Click:Connect(function()
	state.trainingMode = not state.trainingMode
	trainBtn.Text = "TrainingMode: "..(state.trainingMode and "ON (Server)" or "OFF (Server)")
	trainBtn.BackgroundColor3 = state.trainingMode and Color3.fromRGB(80,160,80) or Color3.fromRGB(100,100,100)
	-- si tienes RemoteEvent para TRAINING en servidor lo llamas aquí:
	-- pcall(function() game.ReplicatedStorage:WaitForChild("TrainingToggleEvent"):FireServer(state.trainingMode) end)
end)

-- login handler
local function tryLogin()
	local u = trim(userBox.Text)
	local p = trim(passBox.Text)
	if u=="" or p=="" then
		statusLabel.TextColor3 = Color3.fromRGB(255,150,150)
		statusLabel.Text = "Introduce usuario y contraseña"
		return
	end
	if findAccount(u,p) then
		statusLabel.TextColor3 = Color3.fromRGB(120,255,120)
		statusLabel.Text = "Acceso correcto. Abriendo panel..."
		task.wait(0.18)
		if loginGui and loginGui.Parent then loginGui:Destroy() end
		mainGui.Enabled = true
		fovFrame.Size = UDim2.new(0, state.fovsize, 0, state.fovsize)
	else
		statusLabel.TextColor3 = Color3.fromRGB(255,120,120)
		statusLabel.Text = "Usuario o contraseña incorrectos."
	end
end

loginBtn.MouseButton1Click:Connect(tryLogin)
userBox.FocusLost:Connect(function(enter) if enter then tryLogin() end end)
passBox.FocusLost:Connect(function(enter) if enter then tryLogin() end end)

-- =========== ESP (Highlight) ===========
local highlights = {}
local function ensureHighlightFor(pl)
	if not pl.Character then return nil end
	if highlights[pl] and highlights[pl].Parent == pl.Character then return highlights[pl] end
	if highlights[pl] then pcall(function() highlights[pl]:Destroy() end) end
	local ok, h = pcall(function()
		local nh = Instance.new("Highlight")
		nh.Name = "NeonTrainESP"
		nh.Adornee = pl.Character
		nh.Parent = pl.Character
		nh.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		nh.Enabled = false
		return nh
	end)
	if ok then highlights[pl] = h; return h end
	return nil
end

local function updateESP()
	for _,pl in pairs(Players:GetPlayers()) do
		if pl ~= player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
			local h = ensureHighlightFor(pl)
			if h then
				local color = (pl.TeamColor == player.TeamColor) and Color3.fromRGB(60,180,255) or Color3.fromRGB(255,80,80)
				h.FillColor = color
				h.OutlineColor = color
				h.Enabled = state.esp
			end
		end
	end
	for pl,_ in pairs(highlights) do
		if not Players:FindFirstChild(pl.Name) or not pl.Character then
			pcall(function() highlights[pl]:Destroy() end)
			highlights[pl] = nil
		end
	end
end
spawn(function()
	while true do
		pcall(updateESP)
		task.wait(ESP_UPDATE_RATE)
	end
end)

-- =========== AimAssist (mantener clic derecho) ===========
local aiming = false
UserInputService.InputBegan:Connect(function(i,gp) if i.UserInputType == AIM_KEY then aiming = true end end)
UserInputService.InputEnded:Connect(function(i,gp) if i.UserInputType == AIM_KEY then aiming = false end end)

local function angleBetween(a,b) local dot = a:Dot(b); dot = math.clamp(dot,-1,1); return math.deg(math.acos(dot)) end

local function findBestTarget()
	if not Camera or not Camera.CFrame then return nil end
	local camPos = Camera.CFrame.Position
	local camLook = Camera.CFrame.LookVector
	local best, bestScore = nil, math.huge
	for _,pl in pairs(Players:GetPlayers()) do
		if pl ~= player and pl.Character and pl.Character:FindFirstChild("Head") and pl.Character:FindFirstChild("Humanoid") then
			local head = pl.Character.Head
			local toHead = head.Position - camPos
			local dist = toHead.Magnitude
			if dist <= AIM_MAX_DIST then
				local dir = toHead.Unit
				local ang = angleBetween(camLook, dir)
				if ang <= AIM_MAX_ANGLE then
					local score = ang + dist/100
					if score < bestScore then bestScore = score; best = {player=pl, head=head, ang=ang, dist=dist} end
				end
			end
		end
	end
	return best
end

RunService.RenderStepped:Connect(function()
	-- actualizar FOV visual
	if state.fov then fovFrame.Size = UDim2.new(0, state.fovsize, 0, state.fovsize) end

	-- AimAssist potente (solo si activado y mantienes clic derecho)
	if state.aimassist and aiming then
		local target = findBestTarget()
		if target and target.head then
			local camPos = Camera.CFrame.Position
			local headPos = target.head.Position
			local desired = (headPos - camPos).Unit
			local cur = Camera.CFrame.LookVector
			local nudge = math.clamp(state.aimstrength, 0, 1)
			local newLook = (cur:Lerp(desired, nudge)).Unit
			local newCF = CFrame.new(camPos, camPos + newLook)
			-- Lerp la cámara muy rápido para sensación "pegajosa" (pero no mover la cámara instantáneamente)
			Camera.CFrame = Camera.CFrame:Lerp(newCF, AIM_CAM_LERP)
		end
	end
end)

print("[NeonAssist] Cargado. Usa Admin/nader123 para entrar. RightShift abre/oculta panel.")


