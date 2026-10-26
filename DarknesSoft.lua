--[[
    Darknes Soft | Samurai Edition
    Fly + ESP + Language (RU/EN)
    
    Compatible with: Delta Executor, and most other executors that support Drawing API
    
    Features:
    - Fly (WASD + Space/Ctrl)
    - Speed slider
    - ESP (Box, Tracer, Name + Distance, Health bar)
    - Language switch (Russian / English)
    - Samurai-themed UI with particles
    
    Author: Darknes Soft
    Version: 1.0
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

--================ SETTINGS ================--
local Flying = false
local FlySpeed = 50
local BodyVelocity, BodyGyro = nil, nil
local CurrentLang = "RU"
local ESPEnabled = false

local Lang = {
    RU = {
        Title = "DARKNES SOFT",
        FlyOff = "ПОЛЁТ: ВЫКЛ",
        FlyOn = "ПОЛЁТ: ВКЛ",
        Speed = "Скорость: ",
        LangBtn = "EN",
        ESPOff = "ESP: ВЫКЛ",
        ESPOn = "ESP: ВКЛ"
    },
    EN = {
        Title = "DARKNES SOFT",
        FlyOff = "FLY: OFF",
        FlyOn = "FLY: ON",
        Speed = "Speed: ",
        LangBtn = "RU",
        ESPOff = "ESP: OFF",
        ESPOn = "ESP: ON"
    }
}

--================ GUI ================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DarknesSoft"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 275)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -137)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(180, 20, 30)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Samurai Icon
local IconFrame = Instance.new("Frame")
IconFrame.Size = UDim2.new(0, 42, 0, 42)
IconFrame.Position = UDim2.new(0, 12, 0, 8)
IconFrame.BackgroundColor3 = Color3.fromRGB(20, 5, 5)
IconFrame.BorderSizePixel = 0
IconFrame.Parent = MainFrame

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = IconFrame

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(200, 30, 40)
IconStroke.Thickness = 1.5
IconStroke.Parent = IconFrame

local Sun = Instance.new("Frame")
Sun.Size = UDim2.new(0, 28, 0, 28)
Sun.Position = UDim2.new(0.5, -14, 0.5, -14)
Sun.BackgroundColor3 = Color3.fromRGB(200, 25, 35)
Sun.BorderSizePixel = 0
Sun.Parent = IconFrame

local SunCorner = Instance.new("UICorner")
SunCorner.CornerRadius = UDim.new(1, 0)
SunCorner.Parent = Sun

local SamuraiIcon = Instance.new("TextLabel")
SamuraiIcon.Size = UDim2.new(1, 0, 1, 0)
SamuraiIcon.BackgroundTransparency = 1
SamuraiIcon.Text = "侍"
SamuraiIcon.TextColor3 = Color3.fromRGB(0, 0, 0)
SamuraiIcon.Font = Enum.Font.GothamBold
SamuraiIcon.TextSize = 22
SamuraiIcon.Parent = IconFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 0, 42)
Title.Position = UDim2.new(0, 60, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = Lang[CurrentLang].Title
Title.TextColor3 = Color3.fromRGB(230, 230, 235)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Divider
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -24, 0, 1)
Divider.Position = UDim2.new(0, 12, 0, 56)
Divider.BackgroundColor3 = Color3.fromRGB(140, 20, 30)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

-- Fly Toggle
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, -30, 0, 36)
ToggleBtn.Position = UDim2.new(0, 15, 0, 68)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 12, 14)
ToggleBtn.Text = Lang[CurrentLang].FlyOff
ToggleBtn.TextColor3 = Color3.fromRGB(230, 230, 235)
ToggleBtn.Font = Enum.Font.GothamSemibold
ToggleBtn.TextSize = 14
ToggleBtn.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(160, 25, 35)
ToggleStroke.Thickness = 1.2
ToggleStroke.Parent = ToggleBtn

-- ESP Toggle
local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(1, -30, 0, 36)
ESPBtn.Position = UDim2.new(0, 15, 0, 110)
ESPBtn.BackgroundColor3 = Color3.fromRGB(25, 12, 14)
ESPBtn.Text = Lang[CurrentLang].ESPOff
ESPBtn.TextColor3 = Color3.fromRGB(230, 230, 235)
ESPBtn.Font = Enum.Font.GothamSemibold
ESPBtn.TextSize = 14
ESPBtn.Parent = MainFrame

local ESPCorner = Instance.new("UICorner")
ESPCorner.CornerRadius = UDim.new(0, 8)
ESPCorner.Parent = ESPBtn

local ESPStroke = Instance.new("UIStroke")
ESPStroke.Color = Color3.fromRGB(160, 25, 35)
ESPStroke.Thickness = 1.2
ESPStroke.Parent = ESPBtn

-- Speed Label
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -30, 0, 18)
SpeedLabel.Position = UDim2.new(0, 15, 0, 155)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = Lang[CurrentLang].Speed .. FlySpeed
SpeedLabel.TextColor3 = Color3.fromRGB(200, 180, 185)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 13
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = MainFrame

-- Slider
local SliderBg = Instance.new("Frame")
SliderBg.Size = UDim2.new(1, -30, 0, 8)
SliderBg.Position = UDim2.new(0, 15, 0, 178)
SliderBg.BackgroundColor3 = Color3.fromRGB(30, 15, 18)
SliderBg.BorderSizePixel = 0
SliderBg.Parent = MainFrame

local SliderBgCorner = Instance.new("UICorner")
SliderBgCorner.CornerRadius = UDim.new(1, 0)
SliderBgCorner.Parent = SliderBg

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(190, 30, 40)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBg

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(1, 0)
SliderFillCorner.Parent = SliderFill

local SliderBtn = Instance.new("TextButton")
SliderBtn.Size = UDim2.new(0, 16, 0, 16)
SliderBtn.Position = UDim2.new(0.5, -8, 0.5, -8)
SliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderBtn.Text = ""
SliderBtn.Parent = SliderBg

local SliderBtnCorner = Instance.new("UICorner")
SliderBtnCorner.CornerRadius = UDim.new(1, 0)
SliderBtnCorner.Parent = SliderBtn

-- Language Button
local LangBtn = Instance.new("TextButton")
LangBtn.Size = UDim2.new(1, -30, 0, 32)
LangBtn.Position = UDim2.new(0, 15, 0, 200)
LangBtn.BackgroundColor3 = Color3.fromRGB(25, 12, 14)
LangBtn.Text = "Language: " .. Lang[CurrentLang].LangBtn
LangBtn.TextColor3 = Color3.fromRGB(230, 230, 235)
LangBtn.Font = Enum.Font.GothamSemibold
LangBtn.TextSize = 13
LangBtn.Parent = MainFrame

local LangCorner = Instance.new("UICorner")
LangCorner.CornerRadius = UDim.new(0, 8)
LangCorner.Parent = LangBtn

local LangStroke = Instance.new("UIStroke")
LangStroke.Color = Color3.fromRGB(160, 25, 35)
LangStroke.Thickness = 1.2
LangStroke.Parent = LangBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -36, 0, 10)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(200, 60, 70)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.Parent = MainFrame

--================ PARTICLES ================--
local function CreateParticle()
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, math.random(3, 7), 0, math.random(3, 7))
    p.BackgroundColor3 = Color3.fromRGB(math.random(160, 220), math.random(10, 40), math.random(20, 50))
    p.BackgroundTransparency = math.random(10, 40) / 100
    p.BorderSizePixel = 0
    p.Rotation = math.random(0, 360)
    p.ZIndex = 0
    p.Parent = MainFrame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = p

    local startX = math.random(0, 280)
    p.Position = UDim2.new(0, startX, 0, -10)

    local tween = TweenService:Create(p, TweenInfo.new(math.random(25, 50) / 10, Enum.EasingStyle.Linear), {
        Position = UDim2.new(0, startX + math.random(-30, 30), 0, 290),
        Rotation = p.Rotation + math.random(60, 200)
    })
    tween:Play()
    tween.Completed:Connect(function()
        p:Destroy()
    end)
end

task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        CreateParticle()
        task.wait(math.random(6, 14) / 10)
    end
end)

--================ ESP SYSTEM ================--
local ESPObjects = {}

local function CreateESP(player)
    if player == LocalPlayer then return end

    local drawings = {
        Box = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        HealthBar = Drawing.new("Line"),
        HealthOutline = Drawing.new("Line")
    }

    drawings.Box.Thickness = 1.5
    drawings.Box.Filled = false
    drawings.Box.Color = Color3.fromRGB(200, 30, 40)
    drawings.Box.Visible = false

    drawings.Tracer.Thickness = 1.2
    drawings.Tracer.Color = Color3.fromRGB(200, 30, 40)
    drawings.Tracer.Visible = false

    drawings.Name.Size = 14
    drawings.Name.Center = true
    drawings.Name.Outline = true
    drawings.Name.Color = Color3.fromRGB(255, 255, 255)
    drawings.Name.Visible = false

    drawings.HealthOutline.Thickness = 3
    drawings.HealthOutline.Color = Color3.fromRGB(0, 0, 0)
    drawings.HealthOutline.Visible = false

    drawings.HealthBar.Thickness = 1.5
    drawings.HealthBar.Color = Color3.fromRGB(0, 255, 100)
    drawings.HealthBar.Visible = false

    ESPObjects[player] = drawings
end

local function RemoveESP(player)
    if ESPObjects[player] then
        for _, v in pairs(ESPObjects[player]) do
            pcall(function() v:Remove() end)
        end
        ESPObjects[player] = nil
    end
end

local function UpdateESP()
    for player, drawings in pairs(ESPObjects) do
        if not ESPEnabled 
            or not player.Character 
            or not player.Character:FindFirstChild("HumanoidRootPart") 
            or not player.Character:FindFirstChild("Humanoid") 
            or player.Character.Humanoid.Health <= 0 then
            
            drawings.Box.Visible = false
            drawings.Tracer.Visible = false
            drawings.Name.Visible = false
            drawings.HealthBar.Visible = false
            drawings.HealthOutline.Visible = false
            continue
        end

        local root = player.Character.HumanoidRootPart
        local hum = player.Character.Humanoid
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)

        if onScreen then
            local top = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 2.5, 0))
            local bottom = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
            local sizeY = math.abs(top.Y - bottom.Y)
            local sizeX = sizeY * 0.65
            local boxSize = Vector2.new(sizeX, sizeY)
            local boxPos = Vector2.new(pos.X - sizeX / 2, pos.Y - sizeY / 2)

            -- Box
            drawings.Box.Size = boxSize
            drawings.Box.Position = boxPos
            drawings.Box.Visible = true

            -- Tracer
            drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            drawings.Tracer.To = Vector2.new(pos.X, pos.Y + sizeY / 2)
            drawings.Tracer.Visible = true

            -- Name + Distance
            local dist = 0
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude)
            end
            drawings.Name.Text = player.Name .. " [" .. dist .. "m]"
            drawings.Name.Position = Vector2.new(pos.X, boxPos.Y - 16)
            drawings.Name.Visible = true

            -- Health bar
            local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local barHeight = sizeY * healthPercent
            local barX = boxPos.X - 6

            drawings.HealthOutline.From = Vector2.new(barX, boxPos.Y)
            drawings.HealthOutline.To = Vector2.new(barX, boxPos.Y + sizeY)
            drawings.HealthOutline.Visible = true

            drawings.HealthBar.From = Vector2.new(barX, boxPos.Y + (sizeY - barHeight))
            drawings.HealthBar.To = Vector2.new(barX, boxPos.Y + sizeY)
            drawings.HealthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 40)
            drawings.HealthBar.Visible = true
        else
            drawings.Box.Visible = false
            drawings.Tracer.Visible = false
            drawings.Name.Visible = false
            drawings.HealthBar.Visible = false
            drawings.HealthOutline.Visible = false
        end
    end
end

-- Initialize ESP
for _, player in ipairs(Players:GetPlayers()) do
    CreateESP(player)
end

Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)

RunService.RenderStepped:Connect(UpdateESP)

--================ FUNCTIONS ================--
local function UpdateLanguage()
    local L = Lang[CurrentLang]
    Title.Text = L.Title
    SpeedLabel.Text = L.Speed .. FlySpeed
    LangBtn.Text = "Language: " .. L.LangBtn
    ToggleBtn.Text = Flying and L.FlyOn or L.FlyOff
    ESPBtn.Text = ESPEnabled and L.ESPOn or L.ESPOff
end

local function StartFly()
    if Flying then return end
    Flying = true

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BodyVelocity.Velocity = Vector3.zero
    BodyVelocity.Parent = HumanoidRootPart

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    BodyGyro.P = 10000
    BodyGyro.Parent = HumanoidRootPart

    Humanoid.PlatformStand = true

    ToggleBtn.Text = Lang[CurrentLang].FlyOn
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 15, 20)
end

local function StopFly()
    if not Flying then return end
    Flying = false

    if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end

    Humanoid.PlatformStand = false

    ToggleBtn.Text = Lang[CurrentLang].FlyOff
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 12, 14)
end

local function ToggleFly()
    if Flying then
        StopFly()
    else
        StartFly()
    end
end

local function ToggleESP()
    ESPEnabled = not ESPEnabled
    ESPBtn.Text = ESPEnabled and Lang[CurrentLang].ESPOn or Lang[CurrentLang].ESPOff
    ESPBtn.BackgroundColor3 = ESPEnabled and Color3.fromRGB(60, 15, 20) or Color3.fromRGB(25, 12, 14)
end

-- Slider logic
local Sliding = false

SliderBtn.MouseButton1Down:Connect(function()
    Sliding = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Sliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation()
        local relative = math.clamp((mousePos.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)

        SliderFill.Size = UDim2.new(relative, 0, 1, 0)
        SliderBtn.Position = UDim2.new(relative, -8, 0.5, -8)

        FlySpeed = math.floor(10 + relative * 140)
        SpeedLabel.Text = Lang[CurrentLang].Speed .. FlySpeed
    end
end)

-- Fly movement
RunService.RenderStepped:Connect(function()
    if Flying and BodyVelocity and BodyGyro and HumanoidRootPart then
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end

        if dir.Magnitude > 0.1 then
            BodyVelocity.Velocity = dir.Unit * FlySpeed
        else
            BodyVelocity.Velocity = Vector3.zero
        end

        BodyGyro.CFrame = cam.CFrame
    end
end)

-- Buttons
ToggleBtn.MouseButton1Click:Connect(ToggleFly)
ESPBtn.MouseButton1Click:Connect(ToggleESP)

LangBtn.MouseButton1Click:Connect(function()
    CurrentLang = (CurrentLang == "RU") and "EN" or "RU"
    UpdateLanguage()
end)

CloseBtn.MouseButton1Click:Connect(function()
    StopFly()
    ESPEnabled = false

    for _, drawings in pairs(ESPObjects) do
        for _, v in pairs(drawings) do
            pcall(function() v:Remove() end)
        end
    end

    ScreenGui:Destroy()
end)

-- Character respawn support
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")

    if Flying then
        task.wait(0.5)
        StartFly()
    end
end)

print("Darknes Soft | Samurai Edition loaded successfully")
