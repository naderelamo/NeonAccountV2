--[[========================================
         NeonAccount Shop + AimAssist + ESP
===========================================]]--

repeat wait() until game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ================= LOGIN CONFIG =================
local accounts = {
    {user = "Admin", pass = "nader123"},
    {user = "Neon1", pass = "V3x!r9Q"},
    {user = "Neon2", pass = "M0nK#72"},
    {user = "Neon3", pass = "Zebra_88a"},
    {user = "Neon4", pass = "R!ver2025"},
    {user = "Neon5", pass = "Cl0ud-911"},
    {user = "Neon6", pass = "Sky_7Paz"},
    {user = "Neon7", pass = "B0lt&44"},
}

local function findAccount(u,p)
    for _,acc in ipairs(accounts) do
        if acc.user==u and acc.pass==p then return true end
    end
    return false
end

-- ================= LOGIN GUI =================
local loginGui = Instance.new("ScreenGui")
loginGui.Name = "NeonLoginGui"
loginGui.ResetOnSpawn = false
loginGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 220)
frame.Position = UDim2.new(0.5, -180, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BackgroundTransparency = 0.08
frame.BorderSizePixel = 0
frame.Parent = loginGui

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,40)
title.Position = UDim2.new(0,0,0,6)
title.BackgroundTransparency = 1
title.Text = "Iniciar sesión - NeonAccount Shop"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(180,0,255)
title.TextXAlignment = Enum.TextXAlignment.Center

local userBox = Instance.new("TextBox")
userBox.Parent = frame
userBox.Size = UDim2.new(0, 320, 0, 30)
userBox.Position = UDim2.new(0, 20, 0, 70)
userBox.PlaceholderText = "Usuario"
userBox.ClearTextOnFocus = false
userBox.Font = Enum.Font.Gotham
userBox.TextSize = 18
userBox.TextColor3 = Color3.new(0,0,0)
userBox.BackgroundColor3 = Color3.fromRGB(240,240,240)
userBox.BorderSizePixel = 0

local passBox = Instance.new("TextBox")
passBox.Parent = frame
passBox.Size = UDim2.new(0, 320, 0, 30)
passBox.Position = UDim2.new(0, 20, 0, 110)
passBox.PlaceholderText = "Contraseña"
passBox.ClearTextOnFocus = false
passBox.Font = Enum.Font.Gotham
passBox.TextSize = 18
passBox.TextColor3 = Color3.new(0,0,0)
passBox.BackgroundColor3 = Color3.fromRGB(240,240,240)
passBox.BorderSizePixel = 0

local loginBtn = Instance.new("TextButton")
loginBtn.Parent = frame
loginBtn.Size = UDim2.new(0, 140, 0, 36)
loginBtn.Position = UDim2.new(0.5, -70, 1, -56)
loginBtn.Text = "Iniciar sesión"
loginBtn.Font = Enum.Font.GothamBold
loginBtn.TextSize = 18
loginBtn.TextColor3 = Color3.fromRGB(255,255,255)
loginBtn.BackgroundColor3 = Color3.fromRGB(120,30,180)
loginBtn.BorderSizePixel = 0

local feedback = Instance.new("TextLabel")
feedback.Parent = frame
feedback.Size = UDim2.new(1, -20, 0, 22)
feedback.Position = UDim2.new(0, 10, 1, -28)
feedback.BackgroundTransparency = 1
feedback.Text = ""
feedback.Font = Enum.Font.Gotham
feedback.TextSize = 14
feedback.TextColor3 = Color3.fromRGB(255,120,120)
feedback.TextXAlignment = Enum.TextXAlignment.Center

-- ================= FUNCIONES DEL PANEL =================
local function onLoginSuccess()
    if loginGui and loginGui.Parent then
        loginGui:Destroy()
    end
    
    -- Mostrar label permanente NeonShop Account arriba derecha
    local gui = Instance.new("ScreenGui", playerGui)
    gui.Name = "NeonAccountLabelGui"
    gui.ResetOnSpawn = false

    local label = Instance.new("TextLabel", gui)
    label.AnchorPoint = Vector2.new(1,0)
    label.Position = UDim2.new(1,-10,0.02,0)
    label.Size = UDim2.new(0,220,0,36)
    label.BackgroundTransparency = 1
    label.Text = "NeonShop Account"
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.TextColor3 = Color3.fromRGB(180,0,255)
    
    -- ================= MENU DE CHEATS =================
    local menu = Instance.new("Frame", gui)
    menu.Size = UDim2.new(0,360,0,220)
    menu.Position = UDim2.new(0.5,-180,0.5,-110)
    menu.BackgroundColor3 = Color3.fromRGB(25,25,25)
    menu.BackgroundTransparency = 0.08
    menu.BorderSizePixel = 0

    local menuTitle = Instance.new("TextLabel", menu)
    menuTitle.Size = UDim2.new(1,0,0,40)
    menuTitle.Position = UDim2.new(0,0,0,6)
    menuTitle.BackgroundTransparency = 1
    menuTitle.Text = "PANEL CHEAT"
    menuTitle.Font = Enum.Font.GothamBold
    menuTitle.TextSize = 18
    menuTitle.TextColor3 = Color3.fromRGB(255,0,0)
    menuTitle.TextXAlignment = Enum.TextXAlignment.Center

    -- Botones ejemplo: AimAssist, ESP
    local function createToggle(name, posY)
        local btn = Instance.new("TextButton", menu)
        btn.Size = UDim2.new(0,140,0,36)
        btn.Position = UDim2.new(0.5,-70,posY,0)
        btn.Text = name.." OFF"
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.BackgroundColor3 = Color3.fromRGB(120,30,180)
        btn.BorderSizePixel = 0
        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = name.." "..(state and "ON" or "OFF")
            if name=="ESP" then _G.ESP_ON = state end
            if name=="AimAssist" then _G.AIM_ON = state end
        end)
        return btn
    end

    createToggle("AimAssist", 50)
    createToggle("ESP", 100)

    -- Toggle menu con Mayus Derecho
    local menuVisible = true
    game:GetService("UserInputService").InputBegan:Connect(function(input,gameProcessed)
        if input.KeyCode==Enum.KeyCode.RightShift then
            menuVisible = not menuVisible
            menu.Visible = menuVisible
        end
    end)

    -- ================= ESP BOX =================
    _G.ESP_ON = true
    local ESP_Holder = Instance.new("Folder", game.CoreGui)
    ESP_Holder.Name = "ESP"

    local function UpdateESP()
        for _,v in pairs(game.Players:GetPlayers()) do
            if v~=player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local existing = ESP_Holder:FindFirstChild(v.Name)
                if not existing then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = v.Name
                    box.Size = Vector3.new(2,5,1)
                    box.Adornee = v.Character.HumanoidRootPart
                    box.AlwaysOnTop = true
                    box.ZIndex = 1
                    box.Transparency = 0.6
                    box.Parent = ESP_Holder
                end
                if _G.ESP_ON then
                    local box = ESP_Holder:FindFirstChild(v.Name)
                    if v.Team then
                        if v.TeamColor==player.TeamColor then
                            box.Color3 = Color3.fromRGB(0,0,255)
                        else
                            box.Color3 = Color3.fromRGB(255,0,0)
                        end
                    else
                        box.Color3 = Color3.fromRGB(180,0,255)
                    end
                    box.Visible = true
                else
                    local box = ESP_Holder:FindFirstChild(v.Name)
                    if box then box.Visible=false end
                end
            end
        end
    end

    game:GetService("RunService").RenderStepped:Connect(UpdateESP)

    game.Players.PlayerAdded:Connect(function(v)
        v.CharacterAdded:Connect(function()
            wait(0.1)
            UpdateESP()
        end)
    end)

    game.Players.PlayerRemoving:Connect(function(v)
        local box = ESP_Holder:FindFirstChild(v.Name)
        if box then box:Destroy() end
    end)

    -- ================= AIMASSIST (ejemplo) =================
    _G.AIM_ON = false
    local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V3/main/src/Aimbot.lua"))()
    Aimbot.Load()
end

-- ================= BOTÓN LOGIN =================
loginBtn.MouseButton1Click:Connect(function()
    local u = userBox.Text or ""
    local p = passBox.Text or ""
    if findAccount(u,p) then
        feedback.TextColor3 = Color3.fromRGB(120,255,120)
        feedback.Text = "Inicio de sesión correcto. Cargando..."
        wait(0.4)
        onLoginSuccess()
    else
        feedback.TextColor3 = Color3.fromRGB(255,120,120)
        feedback.Text = "Usuario o contraseña incorrectos."
    end
end)

userBox.FocusLost:Connect(function(enter) if enter then loginBtn:CaptureFocus() loginBtn.MouseButton1Click:Fire() end end)
passBox.FocusLost:Connect(function(enter) if enter then loginBtn:CaptureFocus() loginBtn.MouseButton1Click:Fire() end end)
