-- GUI Noir Intense avec Animation d'Introduction et Menu Déroulant Amélioré
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local MinimizedIcon = Instance.new("Frame")
local SideMenu = Instance.new("Frame")
local FarmButton = Instance.new("TextButton")
local ContentFrame = Instance.new("Frame")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local toggleStates = {} -- Sauvegarde les états des toggles
local UIS = game:GetService("UserInputService")
local isMobile = UIS.TouchEnabled -- Détecte si c'est un appareil tactile

local guiSize = {
    PC = UDim2.new(0, 800, 0, 540), -- Taille pour PC
    Mobile = UDim2.new(0, 400, 0, 280) -- Taille pour Mobile
}

local function scaleElement(element, pcSize, mobileSize)
    element.Size = isMobile and mobileSize or pcSize
end

-- Récupérer le joueur local
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Fonction pour téléporter le joueur
local function teleportTo(target)
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CFrame = target.CFrame
    end
end

-- Configuration principale du ScreenGui
ScreenGui.Name = "AnimalSimulatorGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Animation d'affichage du texte "Dev by Krix"
local function animateText(textLabel, text, delay)
    for i = 1, #text do
        textLabel.Text = string.sub(text, 1, i)
        wait(delay)
    end
end

-- Label pour l'animation d'introduction
local AnimationLabel = Instance.new("TextLabel")
AnimationLabel.Parent = ScreenGui
AnimationLabel.Text = ""
AnimationLabel.Font = Enum.Font.GothamBlack
AnimationLabel.TextSize = 50
AnimationLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
AnimationLabel.BackgroundTransparency = 1
AnimationLabel.Position = UDim2.new(0.5, -200, 0.4, 0)
AnimationLabel.Size = UDim2.new(0, 400, 0, 100)
AnimationLabel.TextXAlignment = Enum.TextXAlignment.Center

animateText(AnimationLabel, "Dev by Krix", 0.05)
wait(2)
AnimationLabel:Destroy()

local function scaleGUI()
    if isMobile then
       -- Configuration pour PC
        MainFrame.Size = UDim2.new(0.5, 0, 0.6, 0)
        MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
        Title.TextSize = 24
        SideMenu.Size = UDim2.new(0.2, 0, 1, -55)
        ContentFrame.Size = UDim2.new(0.8, -10, 1, -65)
        ContentFrame.ScrollBarThickness = 8

        local buttonHeight = 0.15
        FarmButton.Size = UDim2.new(1, -20, buttonHeight, 0)
        BossButton.Size = UDim2.new(1, -20, buttonHeight, 0)
        UtilityButton.Size = UDim2.new(1, -20, buttonHeight, 0)
        InfoButton.Size = UDim2.new(1, -20, buttonHeight, 0)

        FarmButton.Position = UDim2.new(0.05, 0, 0.05, 0)
        BossButton.Position = UDim2.new(0.05, 0, 0.25, 0)
        UtilityButton.Position = UDim2.new(0.05, 0, 0.45, 0)
        InfoButton.Position = UDim2.new(0.05, 0, 0.65, 0)
    else
        -- Configuration pour PC
        MainFrame.Size = UDim2.new(0.5, 0, 0.6, 0)
        MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
        Title.TextSize = 24
        SideMenu.Size = UDim2.new(0.2, 0, 1, -55)
        ContentFrame.Size = UDim2.new(0.8, -10, 1, -65)
        ContentFrame.ScrollBarThickness = 8

        local buttonHeight = 0.15
        FarmButton.Size = UDim2.new(1, -20, buttonHeight, 0)
        BossButton.Size = UDim2.new(1, -20, buttonHeight, 0)
        UtilityButton.Size = UDim2.new(1, -20, buttonHeight, 0)
        InfoButton.Size = UDim2.new(1, -20, buttonHeight, 0)

        FarmButton.Position = UDim2.new(0.05, 0, 0.05, 0)
        BossButton.Position = UDim2.new(0.05, 0, 0.25, 0)
        UtilityButton.Position = UDim2.new(0.05, 0, 0.45, 0)
        InfoButton.Position = UDim2.new(0.05, 0, 0.65, 0)
    end
end



-- Fenêtre principale
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Size = isMobile and guiSize.Mobile or guiSize.PC
MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -MainFrame.Size.Y.Offset / 2)

local UICornerMainFrame = Instance.new("UICorner")
UICornerMainFrame.CornerRadius = UDim.new(0, 25)
UICornerMainFrame.Parent = MainFrame

local UIStrokeMainFrame = Instance.new("UIStroke")
UIStrokeMainFrame.Parent = MainFrame
UIStrokeMainFrame.Color = Color3.fromRGB(255, 40, 40)
UIStrokeMainFrame.Thickness = 4

-- Barre de titre
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.Size = UDim2.new(1, 0, 0, 55)

local UICornerTitleBar = Instance.new("UICorner")
UICornerTitleBar.CornerRadius = UDim.new(0, 25)
UICornerTitleBar.Parent = TitleBar

Title.Name = "Title"
Title.Parent = TitleBar
Title.Text = "Animal Simulator - Dev by Krix"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(255, 40, 40)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -110, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left



-- Fonction pour rendre le GUI déplaçable sur PC et mobile
local UIS = game:GetService("UserInputService")
local dragging = false
local dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)



-- Bouton de fermeture
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseButton.Size = UDim2.new(0, 50, 0, 40)
CloseButton.Position = UDim2.new(1, -55, 0.1, 0)

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 12)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Bouton minimiser
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.Text = "_"
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 20
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
MinimizeButton.Size = UDim2.new(0, 50, 0, 40)
MinimizeButton.Position = UDim2.new(1, -110, 0.1, 0)

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 12)
MinimizeCorner.Parent = MinimizeButton

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedIcon.Visible = true
end)

-- Icone réduite
MinimizedIcon.Name = "MinimizedIcon"
MinimizedIcon.Parent = ScreenGui
MinimizedIcon.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
MinimizedIcon.Size = UDim2.new(0, 50, 0, 50)
MinimizedIcon.Position = UDim2.new(0.03, 0, 0.50, 0)
MinimizedIcon.Visible = false

local MinimizedIconCorner = Instance.new("UICorner")
MinimizedIconCorner.CornerRadius = UDim.new(1, 0)
MinimizedIconCorner.Parent = MinimizedIcon

-- Gérer le clic sur l'icône réduite
MinimizedIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        MainFrame.Visible = true
        MinimizedIcon.Visible = false
    end
end)



MinimizedIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        MainFrame.Visible = true
        MinimizedIcon.Visible = false
    end
end)

-- Menu latéral
SideMenu.Name = "SideMenu"
SideMenu.Parent = MainFrame
SideMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SideMenu.Size = UDim2.new(0, 200, 1, -55)
SideMenu.Position = UDim2.new(0, 0, 0, 55)

local UICornerSideMenu = Instance.new("UICorner")
UICornerSideMenu.CornerRadius = UDim.new(0, 25)
UICornerSideMenu.Parent = SideMenu


-- Bouton "Farm"
FarmButton.Name = "FarmButton"
FarmButton.Parent = SideMenu
FarmButton.Text = "Farm"
FarmButton.Font = Enum.Font.GothamBold
FarmButton.TextSize = 20
FarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmButton.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
scaleElement(FarmButton, UDim2.new(1, -20, 0, 50), UDim2.new(1, -10, 0, 40))
FarmButton.Position = UDim2.new(0, 10, 0, 20)

local FarmButtonCorner = Instance.new("UICorner")
FarmButtonCorner.CornerRadius = UDim.new(0, 12)
FarmButtonCorner.Parent = FarmButton

-- Bouton "Boss"
local BossButton = Instance.new("TextButton")
BossButton.Name = "BossButton"
BossButton.Parent = SideMenu
BossButton.Text = "Boss"
BossButton.Font = Enum.Font.GothamBold
BossButton.TextSize = 20
BossButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BossButton.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
scaleElement(BossButton, UDim2.new(1, -20, 0, 50), UDim2.new(1, -10, 0, 40))
BossButton.Position = UDim2.new(0, 10, 0, 80)

local BossButtonCorner = Instance.new("UICorner")
BossButtonCorner.CornerRadius = UDim.new(0, 12)
BossButtonCorner.Parent = BossButton

-- Bouton "Utility"
local UtilityButton = Instance.new("TextButton")
UtilityButton.Name = "UtilityButton"
UtilityButton.Parent = SideMenu
UtilityButton.Text = "Utility"
UtilityButton.Font = Enum.Font.GothamBold
UtilityButton.TextSize = 20
UtilityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UtilityButton.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
scaleElement(UtilityButton, UDim2.new(1, -20, 0, 50), UDim2.new(1, -10, 0, 40))
UtilityButton.Position = UDim2.new(0, 10, 0, 140) -- Change la position pour qu'elle soit en dessous des autres boutons

local UtilityButtonCorner = Instance.new("UICorner")
UtilityButtonCorner.CornerRadius = UDim.new(0, 12)
UtilityButtonCorner.Parent = UtilityButton


-- Bouton "info"
local InfoButton = Instance.new("TextButton")
InfoButton.Name = "InfoButton"
InfoButton.Parent = SideMenu
InfoButton.Text = "Info"
InfoButton.Font = Enum.Font.GothamBold
InfoButton.TextSize = 20
InfoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoButton.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
scaleElement(InfoButton, UDim2.new(1, -20, 0, 50), UDim2.new(1, -10, 0, 40))
InfoButton.Position = UDim2.new(0, 10, 0, 200)

local InfoButtonCorner = Instance.new("UICorner")
InfoButtonCorner.CornerRadius = UDim.new(0, 12)
InfoButtonCorner.Parent = InfoButton

-- Déclaration de ContentFrame (placée avant la création des boutons)
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ContentFrame.Size = UDim2.new(1, -220, 1, -55)
ContentFrame.Position = UDim2.new(0, 210, 0, 55)
ContentFrame.CanvasSize = UDim2.new(0, 0, 2, 0) -- Taille du défilement
ContentFrame.ScrollBarThickness = 8
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 40, 40)

local UICornerContentFrame = Instance.new("UICorner")
UICornerContentFrame.CornerRadius = UDim.new(0, 25)
UICornerContentFrame.Parent = ContentFrame

-- Fonction pour afficher les informations du développeur
InfoButton.MouseButton1Click:Connect(function()
    -- Supprime tout le contenu actuel du ContentFrame
    for _, child in ipairs(ContentFrame:GetChildren()) do
        if not child:IsA("UICorner") then
            child:Destroy()
        end
    end

    -- Création d'un label pour afficher les informations du développeur
    local DevInfoLabel = Instance.new("TextLabel")
    DevInfoLabel.Parent = ContentFrame
    DevInfoLabel.Text = "Informations du Développeur :\n\nCréateur : Krix\nVersion : 1.0\nMerci d'utiliser notre GUI !\n\nDiscord : soon \nGitHub : https://github.com/krix28lf"
    DevInfoLabel.Font = Enum.Font.GothamBold
    DevInfoLabel.TextSize = 18
    DevInfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DevInfoLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    DevInfoLabel.BackgroundTransparency = 0.2
    DevInfoLabel.TextWrapped = true
    DevInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
    DevInfoLabel.Size = UDim2.new(0.9, 0, 0.9, 0)
    DevInfoLabel.Position = UDim2.new(0.05, 0, 0.05, 0)

    -- Ajout d'un contour arrondi
    local DevInfoCorner = Instance.new("UICorner")
    DevInfoCorner.CornerRadius = UDim.new(0, 15)
    DevInfoCorner.Parent = DevInfoLabel
end)


-- Fonction farming pour Dummy Safe
local function farmDummySafe()
    local dummySafe = workspace.MAP.dummies.Dummy.Humanoid.Parent
    if dummySafe and dummySafe.PrimaryPart then
        teleportTo(dummySafe.PrimaryPart)
    end
    local args = {
        [1] = dummySafe.Humanoid,
        [2] = 1
    }
    local farmLoop = RunService.RenderStepped:Connect(function()
        ReplicatedStorage.jdskhfsIIIllliiIIIdchgdIiIIIlIlIli:FireServer(unpack(args))
    end)
    return farmLoop
end

-- Fonction farming pour Dummy 5k
local function farmDummy5k()
    local dummy5k = workspace.MAP:FindFirstChild("5k_dummies").Dummy2
    if dummy5k and dummy5k:FindFirstChild("Humanoid") then
        local args = {
            [1] = dummy5k.Humanoid,
            [2] = 4
        }
        local farmLoop = RunService.RenderStepped:Connect(function()
            -- Téléportation vers le Dummy 5k
            if dummy5k.PrimaryPart then
                teleportTo(dummy5k.PrimaryPart)
            end
            -- Action de farm sur le Dummy
            ReplicatedStorage.jdskhfsIIIllliiIIIdchgdIiIIIlIlIli:FireServer(unpack(args))
        end)
        return farmLoop
    else
        warn("Dummy 5k introuvable dans le workspace.")
        return nil
    end
end


-- Fonction farming pour les Coins
local function farmCoin()
    local farmLoop = RunService.RenderStepped:Connect(function()
        ReplicatedStorage.Events.CoinEvent:FireServer()
    end)
    return farmLoop
end

-- Ajouter les options de farming
local function createFarmOption(name, positionY, action)
    local height = isMobile and 30 or 70 -- Ajustement de la hauteur

    local OptionBox = Instance.new("Frame")
    OptionBox.Parent = ContentFrame
    OptionBox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    OptionBox.Size = UDim2.new(0, isMobile and 200 or 260, 0, height) -- Largeur adaptée
    OptionBox.Position = UDim2.new(0, 10, 0, positionY)

    local UICornerOptionBox = Instance.new("UICorner")
    UICornerOptionBox.CornerRadius = UDim.new(1, 0)
    UICornerOptionBox.Parent = OptionBox

    local OptionLabel = Instance.new("TextLabel")
    OptionLabel.Parent = OptionBox
    OptionLabel.Text = name
    OptionLabel.Font = Enum.Font.GothamBold
    OptionLabel.TextSize = isMobile and 12 or 18 -- Taille réduite pour mobile
    OptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    OptionLabel.BackgroundTransparency = 1
    OptionLabel.Size = UDim2.new(0, 120, 0, height / 2) -- Taille réduite
    OptionLabel.Position = UDim2.new(0, 10, 0, height / 4)

    local ToggleSwitch = Instance.new("TextButton")
    ToggleSwitch.Parent = OptionBox
    ToggleSwitch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ToggleSwitch.Size = UDim2.new(0, isMobile and 40 or 60, 0, isMobile and 20 or 30) -- Taille du toggle
    ToggleSwitch.Position = UDim2.new(1, -70, 0.5, -10)
    ToggleSwitch.Text = ""

    local UICornerToggle = Instance.new("UICorner")
    UICornerToggle.CornerRadius = UDim.new(1, 0)
    UICornerToggle.Parent = ToggleSwitch

    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Parent = ToggleSwitch
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleCircle.Size = UDim2.new(0, 24, 0, 24)
    ToggleCircle.Position = UDim2.new(0, 3, 0.5, -12)

    local UICornerCircle = Instance.new("UICorner")
    UICornerCircle.CornerRadius = UDim.new(1, 0)
    UICornerCircle.Parent = ToggleCircle

    local isActive = toggleStates[name] or false -- Récupérer l'état sauvegardé
    local farmLoop

    -- Synchroniser l'état visuel au démarrage
    if isActive then
        ToggleSwitch.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        ToggleCircle.Position = UDim2.new(1, -27, 0.5, -12)
        farmLoop = action()
    end

    ToggleSwitch.MouseButton1Click:Connect(function()
        isActive = not isActive
        toggleStates[name] = isActive -- Sauvegarder l'état

        if isActive then
            ToggleSwitch.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            ToggleCircle:TweenPosition(UDim2.new(1, -27, 0.5, -12), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.3, true)
            farmLoop = action()
        else
            ToggleSwitch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            ToggleCircle:TweenPosition(UDim2.new(0, 3, 0.5, -12), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.3, true)
            if farmLoop then
                farmLoop:Disconnect()
            end
        end
    end)
end


-- options simple bouton
local function createSimpleButton(name, positionY, action)
    local height = isMobile and 30 or 50 -- Ajustement de la hauteur

    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Parent = ContentFrame
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    ButtonFrame.Size = UDim2.new(0, isMobile and 200 or 260, 0, height)
    ButtonFrame.Position = UDim2.new(0, 10, 0, positionY)

    local UICornerButtonFrame = Instance.new("UICorner")
    UICornerButtonFrame.CornerRadius = UDim.new(0, 12)
    UICornerButtonFrame.Parent = ButtonFrame

    local Button = Instance.new("TextButton")
    Button.Parent = ButtonFrame
    Button.Text = name
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = isMobile and 12 or 18 -- Réduction du texte
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    Button.Size = UDim2.new(1, -10, 1, -10)
    Button.Position = UDim2.new(0, 5, 0, 5)

    local UICornerButton = Instance.new("UICorner")
    UICornerButton.CornerRadius = UDim.new(0, 10)
    UICornerButton.Parent = Button

    Button.MouseButton1Click:Connect(action)
end

local function adjustScrolling()
    -- Calculer la hauteur totale du contenu
    local totalHeight = 0
    for _, child in ipairs(ContentFrame:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight = totalHeight + child.Size.Y.Offset + 10 -- Inclut un espacement
        end
    end

    -- Ajuster la CanvasSize ou désactiver le scrolling
    if totalHeight <= ContentFrame.AbsoluteSize.Y then
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentFrame.AbsoluteSize.Y)
    else
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    end
end




-- Fonction pour "Kill All Boss"
local function killAllBoss()
    local bosses = {
        {name = "Griffin", damage = 3},
        {name = "CRABBOSS", damage = 1},
        {name = "LavaGorilla", damage = 5},
        {name = "CENTAUR", damage = 4},
        {name = "DragonGiraffe", damage = 1},
        {name = "BOSSFROG", damage = 3}, -- Nouveau boss
        {name = "BOSSBEAR", damage = 2} -- Nouveau boss
    }
    local farmLoop = RunService.RenderStepped:Connect(function()
        for _, boss in ipairs(bosses) do
            local bossHumanoid = workspace:FindFirstChild("NPC"):FindFirstChild(boss.name):FindFirstChild("Humanoid")
            if bossHumanoid then
                ReplicatedStorage.jdskhfsIIIllliiIIIdchgdIiIIIlIlIli:FireServer(bossHumanoid, boss.damage)
            end
        end
    end)
    return farmLoop
end

-- Fonction pour "Kill Aura"
local function killAura()
    local isAttacking = true
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local attackRange = 40
    local farmLoop = RunService.RenderStepped:Connect(function()
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
                local distance = (character.HumanoidRootPart.Position - targetPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance <= attackRange then
                    local args = {
                        [1] = targetPlayer.Character.Humanoid,
                        [2] = 1
                    }
                    ReplicatedStorage.jdskhfsIIIllliiIIIdchgdIiIIIlIlIli:FireServer(unpack(args))
                end
            end
        end
    end)
    return farmLoop
end

-- Fonction pour Griffin
local function farmGriffin()
    local boss = workspace:FindFirstChild("NPC"):FindFirstChild("Griffin")
    if boss and boss:FindFirstChild("Humanoid") then
        local args = {
            [1] = boss.Humanoid,
            [2] = 3
        }
        local farmLoop = RunService.RenderStepped:Connect(function()
            ReplicatedStorage.jdskhfsIIIllliiIIIdchgdIiIIIlIlIli:FireServer(unpack(args))
        end)
        return farmLoop
    else
        warn("Boss Griffin introuvable dans le workspace.")
        return nil
    end
end

-- Fonction pour CRABBOSS
local function farmCrabBoss()
    local boss = workspace:FindFirstChild("NPC"):FindFirstChild("CRABBOSS")
    if boss and boss:FindFirstChild("Humanoid") then
        local args = {
            [1] = boss.Humanoid,
            [2] = 1
        }
        local farmLoop = RunService.RenderStepped:Connect(function()
            ReplicatedStorage.jdskhfsIIIllliiIIIdchgdIiIIIlIlIli:FireServer(unpack(args))
        end)
        return farmLoop
    else
        warn("Boss CRABBOSS introuvable dans le workspace.")
        return nil
    end
end

-- Fonction pour LavaGorilla
local function farmLavaGorilla()
    local boss = workspace:FindFirstChild("NPC"):FindFirstChild("LavaGorilla")
    if boss and boss:FindFirstChild("Humanoid") then
        local args = {
            [1] = boss.Humanoid,
            [2] = 5
        }
        local farmLoop = RunService.RenderStepped:Connect(function()
            ReplicatedStorage.jdskhfsIIIllliiIIIdchgdIiIIIlIlIli:FireServer(unpack(args))
        end)
        return farmLoop
    else
        warn("Boss LavaGorilla introuvable dans le workspace.")
        return nil
    end
end

-- Fonction pour CENTAUR
local function farmCentaur()
    local boss = workspace:FindFirstChild("NPC"):FindFirstChild("CENTAUR")
    if boss and boss:FindFirstChild("Humanoid") then
        local args = {
            [1] = boss.Humanoid,
            [2] = 4
        }
        local farmLoop = RunService.RenderStepped:Connect(function()
            ReplicatedStorage.jdskhfsIIIllliiIIIdchgdIiIIIlIlIli:FireServer(unpack(args))
        end)
        return farmLoop
    else
        warn("Boss CENTAUR introuvable dans le workspace.")
        return nil
    end
end

-- Fonction pour DragonGiraffe
local function farmDragonGiraffe()
    local boss = workspace:FindFirstChild("NPC"):FindFirstChild("DragonGiraffe")
    if boss and boss:FindFirstChild("Humanoid") then
        local args = {
            [1] = boss.Humanoid,
            [2] = 1
        }
        local farmLoop = RunService.RenderStepped:Connect(function()
            ReplicatedStorage.jdskhfsIIIllliiIIIdchgdIiIIIlIlIli:FireServer(unpack(args))
        end)
        return farmLoop
    else
        warn("Boss DragonGiraffe introuvable dans le workspace.")
        return nil
    end
end

-- Fonction pour BOSSFROG
local function farmBossFrog()
    local boss = workspace:FindFirstChild("NPC"):FindFirstChild("BOSSFROG")
    if boss and boss:FindFirstChild("Humanoid") then
        local args = {
            [1] = boss.Humanoid,
            [2] = 3
        }
        local farmLoop = RunService.RenderStepped:Connect(function()
            ReplicatedStorage.jdskhfsIIIllliiIIIdchgdIiIIIlIlIli:FireServer(unpack(args))
        end)
        return farmLoop
    else
        warn("Boss BOSSFROG introuvable dans le workspace.")
        return nil
    end
end

-- Fonction pour BOSSBEAR
local function farmBossBear()
    local boss = workspace:FindFirstChild("NPC"):FindFirstChild("BOSSBEAR")
    if boss and boss:FindFirstChild("Humanoid") then
        local args = {
            [1] = boss.Humanoid,
            [2] = 2
        }
        local farmLoop = RunService.RenderStepped:Connect(function()
            ReplicatedStorage.jdskhfsIIIllliiIIIdchgdIiIIIlIlIli:FireServer(unpack(args))
        end)
        return farmLoop
    else
        warn("Boss BOSSBEAR introuvable dans le workspace.")
        return nil
    end
end

-- Fonction pour Infini Heal
local function infiniHeal()
    -- Variables
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    -- Arguments pour soigner
    local healArgs = {
        [1] = {
            ["action"] = "damage",
            ["damage"] = -math.huge -- Soigne infiniment
        }
    }

    -- Démarrage du soin infini via farmLoop
    local healLoop = RunService.RenderStepped:Connect(function()
        if humanoid.Health < humanoid.MaxHealth then
            game:GetService("ReplicatedStorage").Events.NPCDamageEvent:FireServer(unpack(healArgs))
        end
    end)

    -- Retourne le loop pour qu'il puisse être déconnecté
    return healLoop
end

-- Fonction pour téléporter au spawn
local function teleportToSpawn()
    local spawnPoint = workspace.SpawnPoints:GetChildren()[6] -- Point de spawn spécifié
    if spawnPoint and spawnPoint:IsA("BasePart") then
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = spawnPoint.CFrame
            print("Téléporté au spawn !")
        else
            warn("Impossible de trouver le HumanoidRootPart pour le joueur.")
        end
    else
        warn("Le spawn point n'a pas été trouvé.")
    end
end

-- Fonction pour supprimer la pluie et le son de pluie
local function Rain()
    -- Supprimer le son de pluie s'il existe
    local function deleteRainSound()
        local rainSoundGroup = game:GetService("SoundService"):FindFirstChild("__RainSoundGroup")
        if rainSoundGroup then
            rainSoundGroup:Destroy() -- Supprime le groupe de sons
            print("__RainSoundGroup supprimé avec succès.")
        else
            print("__RainSoundGroup introuvable.")
        end
    end

    -- Supprimer l'émetteur de pluie dans la caméra
    local rainEmitter = workspace.Camera:FindFirstChild("__RainEmitter")
    if rainEmitter and rainEmitter:FindFirstChild("RainStraight") then
        rainEmitter.RainStraight:Destroy() -- Supprime l'émetteur de pluie
        print("RainStraight supprimé avec succès.")
    else
        print("RainStraight introuvable.")
    end

    -- Appelle la fonction pour supprimer le son de pluie
    deleteRainSound()
end

-- Correction de la gestion de l'icône minimisée
MinimizedIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        MainFrame.Visible = true
        MinimizedIcon.Visible = false
    end
end)

-- Ajout des options dans le menu latéral
FarmButton.MouseButton1Click:Connect(function()
    -- Supprimer les anciens enfants
    for _, child in ipairs(ContentFrame:GetChildren()) do
        if not child:IsA("UICorner") then
            child:Destroy()
        end
    end

    -- Réinitialiser le scrolling
    ContentFrame.CanvasPosition = Vector2.new(0, 0)

    -- Ajouter les options spécifiques à la section
    createFarmOption("Farm Coin", 20, farmCoin)
    createFarmOption("Farm Dummy Safe", 100, farmDummySafe)
    createFarmOption("Farm Dummy 5k", 180, farmDummy5k)
    createFarmOption("Kill Aura", 260, killAura)

    -- Ajuster automatiquement le scrolling
    adjustScrolling()
end)

BossButton.MouseButton1Click:Connect(function()
    for _, child in ipairs(ContentFrame:GetChildren()) do
        if not child:IsA("UICorner") then
            child:Destroy()
        end
    end

    ContentFrame.CanvasPosition = Vector2.new(0, 0) -- Réinitialiser la position

    createFarmOption("Kill All Boss", 20, killAllBoss)
    createFarmOption("Farm Griffin", 100, farmGriffin)
    createFarmOption("Farm CRAB", 180, farmCrabBoss)
    createFarmOption("Farm BOSSLAVA", 260, farmLavaGorilla)
    createFarmOption("Farm CENTAUR", 340, farmCentaur)
    createFarmOption("Farm GIRAFFE", 420, farmDragonGiraffe)
    createFarmOption("Farm FROG", 500, farmBossFrog)
    createFarmOption("Farm BOSSBEAR", 580, farmBossBear)

    adjustScrolling() -- Ajuster le scrolling
end)

UtilityButton.MouseButton1Click:Connect(function()
    for _, child in ipairs(ContentFrame:GetChildren()) do
        if not child:IsA("UICorner") then
            child:Destroy()
        end
    end

    ContentFrame.CanvasPosition = Vector2.new(0, 0) -- Réinitialiser la position

    createFarmOption("Infini Heal", 20, infiniHeal)

    createSimpleButton("Teleport to Spawn", 100, function()
        teleportToSpawn()
    end)
    createSimpleButton("Delete Rain", 160, function()
        Rain()
    end)

    adjustScrolling() -- Ajuster le scrolling
end)

scaleGUI()

