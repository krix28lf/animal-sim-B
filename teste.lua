-- Chargement de la bibliothèque Fluent UI
local function LoadFluent()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end

-- Variables globales
local currentTheme = "Darker"
local Fluent
local Window
local farmLoop
local isActive = false -- Active/Désactive la détection PVP
local detectionDistance = 6 -- Distance fixée
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Fonction pour détecter la plateforme
local function detectPlatform()
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        return "Mobile"
    else
        return "PC"
    end
end


-- Fonction pour téléporter le joueur
local function teleportTo(target)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = target.CFrame
    end
end

-- Fonction pour arrêter le farming
local function StopFarm()
    if farmLoop then
        farmLoop:Disconnect()
        farmLoop = nil
        print("Farm arrêté.")
    end
end

-- Variables globales pour le Dummy actuel
local currentDummy = nil
local isFarming = false

-- Fonction pour surveiller la santé et reset si nécessaire
local function MonitorHealth()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= humanoid.MaxHealth / 2 then
                print("PV < 50%, reset en cours...")
                humanoid.Health = 0 -- Reset du joueur
            end
        end)
    end
end

-- Fonction pour téléporter au Dummy
local function TeleportToDummy()
    if currentDummy then
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        -- Téléporter vers le HumanoidRootPart si présent
        local dummyRootPart = currentDummy:FindFirstChild("HumanoidRootPart")
        if dummyRootPart then
            humanoidRootPart.CFrame = dummyRootPart.CFrame
            print("Téléporté au dummy.")
        else
            warn("HumanoidRootPart introuvable pour le dummy.")
        end
    else
        warn("currentDummy est introuvable.")
    end
end


-- Fonction principale pour le farm level
local function FarmLevel()
    local level = player.leaderstats.Level.Value
    local args1, args2, args3

    -- Déterminer le Dummy en fonction du niveau
    if level <= 5000 then
        currentDummy = workspace.MAP.dummies.Dummy
        args1 = { [1] = currentDummy.Humanoid, [2] = 1 }
        args2 = { [1] = Vector3.new(-125.614, 645.335, 594.117), [2] = "NewFireball" }
        args3 = { [1] = Vector3.new(-125.614, 645.335, 594.117), [2] = "NewLightningball" }
    else
        currentDummy = workspace.MAP["5k_dummies"].Dummy2
        args1 = { [1] = currentDummy.Humanoid, [2] = 4 }
        args2 = { [1] = Vector3.new(-81.826, 596.077, 812.498), [2] = "NewFireball" }
        args3 = { [1] = Vector3.new(-81.826, 596.077, 812.498), [2] = "NewLightningball" }
    end

    isFarming = true

    -- Téléportation initiale
    TeleportToDummy()
    MonitorHealth()

    -- Boucle de farm
    spawn(function()
        while isFarming do
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

            -- Si le joueur est mort, attendre respawn et le téléporter
            if not humanoidRootPart or humanoidRootPart.Parent == nil then
                repeat wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                print("Mort détectée. Re-téléportation au dummy...")
                TeleportToDummy()
            end

            -- Attaque uniquement sans téléportation en boucle
            if currentDummy and currentDummy.Humanoid then
                ReplicatedStorage.jdskhfsIIIllliiIIIdchgdIiIIIlIlIli:FireServer(unpack(args1))
                ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent"):FireServer(unpack(args2))
                ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent"):FireServer(unpack(args3))
            end

            wait() -- Petite pause pour éviter les surcharges
        end
    end)

    print("Farm démarré pour le niveau :", level)
end

-- Fonction pour arrêter le farm
local function StopFarm()
    isFarming = false
    currentDummy = nil
    print("Farm arrêté.")
end


local function FarmCoin()
    farmLoop = RunService.RenderStepped:Connect(function()
        ReplicatedStorage.Events.CoinEvent:FireServer()
    end)
end

local function FarmBoss()
    local bosses = {
        {name = "Griffin", damage = 3},
        {name = "CRABBOSS", damage = 1},
        {name = "LavaGorilla", damage = 5},
        {name = "CENTAUR", damage = 4},
        {name = "DragonGiraffe", damage = 1},
        {name = "BOSSFROG", damage = 3}, -- Nouveau boss
        {name = "BOSSBEAR", damage = 2} -- Nouveau boss
    }
    farmLoop = RunService.RenderStepped:Connect(function()
        for _, boss in ipairs(bosses) do
            local bossHumanoid = workspace:FindFirstChild("NPC"):FindFirstChild(boss.name):FindFirstChild("Humanoid")
            if bossHumanoid then
                ReplicatedStorage.jdskhfsIIIllliiIIIdchgdIiIIIlIlIli:FireServer(bossHumanoid, boss.damage)
            end
        end
    end)
end

-- Fonction Anti-AFK
local antiAfkEnabled = false -- Statut Anti-AFK
local virtualUser = game:GetService("VirtualUser")

local function ToggleAntiAfk(value)
    antiAfkEnabled = value
    if antiAfkEnabled then
        print("Anti-AFK Activé")
        spawn(function()
            while antiAfkEnabled do
                virtualUser:CaptureController()
                virtualUser:ClickButton2(Vector2.new())
                print("Anti-AFK : Mouvement simulé")
                wait(120) -- Exécute toutes les 2 minutes
            end
        end)
    else
        print("Anti-AFK Désactivé")
    end
end

-- Fonction pour supprimer rewardFeed2.Sound et newRewardGui
local function DeleteSoundAndGUI()
    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    -- Supprimer rewardFeed2.Sound
    local rewardFeed = playerGui:FindFirstChild("rewardFeed2")
    if rewardFeed then
        local sound = rewardFeed:FindFirstChild("Sound")
        if sound then 
            sound:Destroy()
            print("rewardFeed2.Sound supprimé.")
        end
    end

    -- Supprimer newRewardGui
    local newRewardGui = playerGui:FindFirstChild("newRewardGui")
    if newRewardGui then
        newRewardGui:Destroy()
        print("newRewardGui supprimé.")
    end
end

local function MobileKey()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/rrixh/skripts/refs/heads/main/deltamobile-keyboard-kraxked",true))();
end

-- Fonction Auto Candy
local autoCandyEnabled = false -- Variable pour contrôler la boucle

local function AutoCandy()
    autoCandyEnabled = true -- Activer la fonction
    spawn(function()
        while autoCandyEnabled do
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            local workspace = game:GetService("Workspace")
            local VirtualInputManager = game:GetService("VirtualInputManager")

            -- 1. Téléportation à 1mm près du modèle GiftModel
            local giftModel = workspace:WaitForChild("BucketsHolder"):FindFirstChild("GiftModel")
            if giftModel and giftModel.PrimaryPart then
                local offset = giftModel.PrimaryPart.CFrame.LookVector * -0.01
                humanoidRootPart.CFrame = giftModel.PrimaryPart.CFrame + offset
                print("Téléporté vers GiftModel.")
            end

            -- 2. Simuler la frappe (3 fois avec des pauses précises)
            for i = 1, 3 do
                if not autoCandyEnabled then return end -- Vérifier si désactivé
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                wait(0.5)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                wait(0.3)
                print("Frappe effectuée (" .. i .. "/3).")
            end

            -- 3. Téléporter les parties de CandyHolder vers le joueur
            local candyHolder = workspace:WaitForChild("Christmas2024"):FindFirstChild("CandyHolder")
            if candyHolder then
                for _, part in pairs(candyHolder:GetChildren()) do
                    if not autoCandyEnabled then return end -- Vérifier si désactivé
                    if part:IsA("BasePart") then
                        part.CFrame = humanoidRootPart.CFrame
                        print("Partie téléportée : " .. part.Name)
                    end
                end
            end

            wait(2) -- Petite pause avant la prochaine itération
        end
    end)
end

-- Fonction pour arrêter Auto Candy
local function StopAutoCandy()
    autoCandyEnabled = false -- Désactiver la boucle
    print("Auto Candy arrêté.")
end

local isFarmingBoss = false -- Contrôle si le script est actif

local function FarmBossTP()
    local bosses = {
        {name = "Griffin", damage = 3},
        {name = "CRABBOSS", damage = 1},
        {name = "LavaGorilla", damage = 5},
        {name = "CENTAUR", damage = 4},
        {name = "DragonGiraffe", damage = 1},
        {name = "BOSSFROG", damage = 3},
        {name = "BOSSBEAR", damage = 2}
    }

    local player = game.Players.LocalPlayer
    local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        warn("Erreur : Impossible de trouver HumanoidRootPart du joueur.")
        return
    end

    -- Démarre la boucle infinie
    isFarmingBoss = true
    spawn(function()
        while isFarmingBoss do
            for _, boss in ipairs(bosses) do
                if not isFarmingBoss then break end -- Vérifie si l'utilisateur a désactivé le farming

                local bossModel = workspace:FindFirstChild("NPC") and workspace.NPC:FindFirstChild(boss.name)
                if bossModel and bossModel:FindFirstChild("Humanoid") and bossModel:FindFirstChild("HumanoidRootPart") then
                    local bossHumanoid = bossModel.Humanoid
                    local bossRootPart = bossModel.HumanoidRootPart

                    -- Étape 1 : Se téléporter à 10 studs derrière le boss
                    print("Téléportation au boss : " .. boss.name)
                    local offset = bossRootPart.CFrame.LookVector * -30
                    humanoidRootPart.CFrame = bossRootPart.CFrame + offset

                    -- Étape 2 : Frapper le boss une fois
                    print("Frappe en cours sur " .. boss.name)
                    ReplicatedStorage.jdskhfsIIIllliiIIIdchgdIiIIIlIlIli:FireServer(bossHumanoid, boss.damage)

                    -- Étape 3 : Attendre 1 seconde
                    wait(1)

                    -- Étape 4 : Mettre la vie à 0
                    print("Mise à 0 de la vie de " .. boss.name)
                    bossHumanoid.Health = 0

                    -- Étape 5 : Pause avant le prochain boss
                    wait(1)
                else
                    print("Boss introuvable ou déjà vaincu : " .. boss.name)
                end
            end

            print("Redémarrage de la boucle des boss...")
        end
    end)
end

-- Fonction pour arrêter le farming
local function StopFarmBossTP()
    isFarmingBoss = false
    print("Farm Boss arrêté.")
end

-- Services principaux
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Variables
local player = game.Players.LocalPlayer
local ResetAndAttackLoopEnabled = false
local spawnConnection = nil
local spawnPos = nil -- Sauvegarde la position initiale

-- Fonction pour sauvegarder le spawn initial
local function saveSpawnPoint()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    if humanoidRootPart then
        spawnPos = humanoidRootPart.CFrame
        print("Point de spawn sauvegardé :", spawnPos)
    else
        warn("Impossible de sauvegarder le point de spawn.")
    end
end

-- Fonction pour respawn au point sauvegardé
local function respawnAtSavedPoint()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    if spawnPos then
        humanoidRootPart.CFrame = spawnPos
        print("Respawn au point sauvegardé.")
    else
        warn("Impossible de respawn : HumanoidRootPart introuvable.")
    end
end

-- Fonction pour supprimer les objets SpawnPoints et SpawnLocation
local function DeleteSpawnObjects()
    local objectsToDelete = {"SpawnPoints", "SpawnLocation"}
    for _, objectName in ipairs(objectsToDelete) do
        local object = workspace:FindFirstChild(objectName)
        if object then
            object:Destroy()
            print("Objet supprimé :", objectName)
        else
            print("Objet introuvable :", objectName)
        end
    end
end

-- Boucle de reset et frappe rapide
local function resetAndAttackLoop()
    while ResetAndAttackLoopEnabled do
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChild("Humanoid")

        if humanoid then
            -- Étape 1 : Frapper soi-même
            local success, err = pcall(function()
                ReplicatedStorage.jdskhfsIIIllliiIIIdchgdIiIIIlIlIli:FireServer(humanoid, 1)
                print("Frappe auto effectuée.")
            end)

            if not success then
                warn("Erreur lors de l'attaque :", err)
            else
                -- Étape 2 : Attendre une petite pause avant de reset
                task.wait(0.2)

                -- Reset instantané
                humanoid.Health = 0
                print("Reset effectué.")
            end
        else
            warn("Humanoid introuvable, réessai...")
        end

        -- Pause avant le prochain cycle
        task.wait(1)
    end
end

-- Activer/Désactiver la boucle avec Toggle
local function toggleResetAndAttackLoop(value)
    if value then
        print("Boucle activée.")
        -- Suppression des objets avant de commencer
        DeleteSpawnObjects()

        ResetAndAttackLoopEnabled = true
        saveSpawnPoint() -- Sauvegarde de la position uniquement quand on active
        spawnConnection = player.CharacterAdded:Connect(respawnAtSavedPoint)
        task.spawn(resetAndAttackLoop)
    else
        print("Boucle désactivée.")
        ResetAndAttackLoopEnabled = false
        if spawnConnection then
            spawnConnection:Disconnect()
            spawnConnection = nil
        end
    end
end


-- Variables pour la Hitbox
_G.HeadSize = _G.HeadSize or 5
local hitboxVisible = false
local hitboxEnabled = false

-- Table pour sauvegarder les valeurs par défaut des joueurs
local defaultProperties = {}

-- Fonction pour sauvegarder les propriétés par défaut (une seule fois)
local function SaveDefaultProperties(player)
    if not defaultProperties[player.UserId] then -- Sauvegarder seulement si pas déjà fait
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = player.Character.HumanoidRootPart
            defaultProperties[player.UserId] = {
                Size = humanoidRootPart.Size,
                Transparency = humanoidRootPart.Transparency,
                BrickColor = humanoidRootPart.BrickColor,
                Material = humanoidRootPart.Material
            }
        end
    end
end

-- Fonction pour réinitialiser la Hitbox d'un joueur
local function ResetHitbox(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = player.Character.HumanoidRootPart
        local defaults = defaultProperties[player.UserId]
        if defaults then
            pcall(function()
                humanoidRootPart.Size = defaults.Size
                humanoidRootPart.Transparency = defaults.Transparency
                humanoidRootPart.BrickColor = defaults.BrickColor
                humanoidRootPart.Material = defaults.Material
            end)
        end
    end
end

-- Fonction pour appliquer la Hitbox
local function ApplyHitbox()
    for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            SaveDefaultProperties(v) -- Sauvegarder avant de modifier
            local humanoidRootPart = v.Character.HumanoidRootPart
            pcall(function()
                humanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                humanoidRootPart.Transparency = hitboxVisible and 0.5 or 1
                humanoidRootPart.BrickColor = BrickColor.new("Really red")
                humanoidRootPart.Material = Enum.Material.Neon
            end)
        end
    end
end

-- Fonction pour activer/désactiver la Hitbox
local function ToggleHitbox(Value)
    hitboxEnabled = Value
    if Value then
        print("Hitbox activée avec une taille de :", _G.HeadSize)
        ApplyHitbox()
    else
        print("Hitbox désactivée.")
        for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
            if v ~= player then
                ResetHitbox(v) -- Réinitialiser les joueurs
            end
        end
    end
end

-- Réappliquer la Hitbox lorsque les joueurs se respawn
game:GetService("Players").PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        wait(1) -- Attendre que le personnage se charge
        if hitboxEnabled then
            ApplyHitbox()
        else
            ResetHitbox(p)
        end
    end)
end)

-- Réappliquer pour les joueurs déjà présents
for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
    p.CharacterAdded:Connect(function()
        wait(1)
        if hitboxEnabled then
            ApplyHitbox()
        else
            ResetHitbox(p)
        end
    end)
end





-- Variables pour le Speed
local isSpeedEnabled = false
local speedValue = 16 -- Valeur par défaut de la vitesse

-- Fonction pour appliquer la vitesse au joueur
local function updateSpeed()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = isSpeedEnabled and speedValue or 16 -- 16 est la vitesse par défaut
        print("Vitesse mise à jour :", humanoid.WalkSpeed)
    end
end

-- Variables pour le Jump
local isJumpEnabled = false
local jumpPowerValue = 50 -- Valeur par défaut du JumpPower

-- Fonction pour appliquer le JumpPower au joueur
local function updateJumpPower()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = isJumpEnabled and jumpPowerValue or 50 -- 50 est la valeur par défaut
        print("JumpPower mis à jour :", humanoid.JumpPower)
    end
end

local function Fly()
    loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")()
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local isFireAuraEnabled = false

-- Fonction pour trouver le joueur le plus proche
local function FindClosestPlayer(range)
    local closestPlayer = nil
    local minDistance = range

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < minDistance then
                closestPlayer = otherPlayer
                minDistance = distance
            end
        end
    end

    return closestPlayer
end

-- Fonction pour activer/désactiver la Fire Aura
local function FireAuraLoop()
    spawn(function()
        while isFireAuraEnabled do
            local closestPlayer = FindClosestPlayer(30) -- Distance de détection : 30 studs

            if closestPlayer and closestPlayer.Character then
                local targetPosition = closestPlayer.Character.HumanoidRootPart.Position
                local fireballArgs = {
                    [1] = Vector3.new(targetPosition.X, targetPosition.Y, targetPosition.Z),
                    [2] = "NewFireball"
                }

                -- Envoi des Fireballs
                ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent"):FireServer(unpack(fireballArgs))
                print("Fireball envoyée sur le joueur :", closestPlayer.Name)
            end

            wait(0.5) -- Envoi toutes les 1 seconde pour éviter les spams
        end
    end)
end

-- Fonction pour activer/désactiver la Fire Aura
local function ToggleFireAura(Value)
    isFireAuraEnabled = Value
    if Value then
        print("Fire Aura activée.")
        FireAuraLoop()
    else
        print("Fire Aura désactivée.")
    end
end

-- Variables pour le suivi des stats
local statsTrackingEnabled = false
local previousExp = nil -- XP précédent
local xpHistory = {} -- Historique des XP/s pour calculer une moyenne
local lastXpPerSecond = 0 -- Dernière moyenne d'XP par seconde
local lastTimeFor100Levels = 0 -- Temps estimé pour atteindre 100 niveaux
local statsLoop = nil -- Boucle principale
local lastUpdateTime = 0 -- Dernière mise à jour des Paragraphs
local startTime = os.clock() -- Temps de départ

-- Fonction pour formater le temps (secondes -> hh:mm:ss)
local function FormatTime(seconds)
    if seconds == math.huge then return "Infini" end
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)

    if hours > 0 then
        return string.format("%dh %dm %ds", hours, minutes, secs)
    elseif minutes > 0 then
        return string.format("%dm %ds", minutes, secs)
    else
        return string.format("%ds", secs)
    end
end

-- Fonction pour calculer la moyenne de l'XP/s
local function CalculateAverage(data)
    local sum = 0
    local count = #data

    -- Retourner 0 si la table est vide
    if count == 0 then
        return 0
    end

    -- Calculer la somme
    for _, value in ipairs(data) do
        sum = sum + value
    end

    return sum / count
end

-- Variables pour stocker les Paragraphs
local xpParagraph, timeParagraph = nil, nil

-- Fonction pour créer ou mettre à jour les Paragraphs
local function CreateOrUpdateStatsParagraphs(Tab)
    -- Si les Paragraphs existent déjà, les détruire
    if xpParagraph then xpParagraph:Destroy() end
    if timeParagraph then timeParagraph:Destroy() end

    -- Créer de nouveaux Paragraphs avec les valeurs mises à jour
    xpParagraph = Tab:AddParagraph({
        Title = "XP par seconde",
        Content = string.format("%.2f XP/s", lastXpPerSecond)
    })

    timeParagraph = Tab:AddParagraph({
        Title = "Temps pour 100 niveaux",
        Content = FormatTime(lastTimeFor100Levels)
    })
end


-- Fonction pour démarrer le suivi des stats
local function StartStatsTracking(Tab)
    local levelStat = player.leaderstats.Level
    local expStat = player.otherstats.ExpBar

    statsTrackingEnabled = true
    previousExp = expStat.Value
    startTime = os.clock()
    local startLevel = levelStat.Value

    -- Précalculer l'XP nécessaire pour 100 niveaux
    local totalXpNeeded = 0
    for i = startLevel + 1, startLevel + 100 do
        totalXpNeeded = totalXpNeeded + (i * 1000)
    end

    -- Boucle principale
    statsLoop = task.spawn(function()
        while statsTrackingEnabled do
            local currentTime = os.clock()
            local elapsedTime = currentTime - startTime

            -- Calculer l'XP par seconde
            local currentExp = expStat.Value
            local expGained = currentExp - previousExp

            if expGained > 0 and elapsedTime > 0 then
                table.insert(xpHistory, expGained / elapsedTime)
                if #xpHistory > 10 then table.remove(xpHistory, 1) end -- Limite à 10 valeurs pour la moyenne

                lastXpPerSecond = CalculateAverage(xpHistory)
                previousExp = currentExp
                startTime = currentTime
            end

            -- Calculer le temps pour atteindre 100 niveaux
            if lastXpPerSecond > 0 then
                lastTimeFor100Levels = totalXpNeeded / lastXpPerSecond
            else
                lastTimeFor100Levels = math.huge
            end

            -- Mettre à jour les Paragraphs (toutes les 0.5 secondes)
            if os.clock() - lastUpdateTime >= 0.5 then
                CreateOrUpdateStatsParagraphs(Tab)
                lastUpdateTime = os.clock()
            end

            wait(0.1) -- Réduit la charge sur le serveur
        end
    end)
end

-- Fonction pour arrêter le suivi des stats
local function StopStatsTracking()
    if statsLoop then
        task.cancel(statsLoop)
        statsLoop = nil
    end
    statsTrackingEnabled = false
    xpHistory = {} -- Réinitialiser l'historique
    print("Suivi des stats arrêté.")
end

local function X13()
-- Attendre que le joueur et le GUI soient chargés
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Protéger contre les erreurs si l'objet n'est pas encore prêt
local success, err = pcall(function()
    -- Chemin vers l'élément du texte dans le GUI
    local gamepassText = player.PlayerGui:WaitForChild("LevelBar"):WaitForChild("gamepassText")

    -- Changer la valeur du texte
    gamepassText.Text = "13x Exp"
end)

-- Afficher une erreur si quelque chose ne va pas
if not success then
    warn("Erreur : " .. err)
end
end 

local function FreeFireball()
    -- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Fonction pour copier un Tool nommé "Fireball" depuis un autre joueur
local function copyFireballTool()
    for _, player in ipairs(Players:GetPlayers()) do
        -- Vérifier que ce n'est pas le joueur local
        if player ~= LocalPlayer then
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                -- Chercher le Tool "Fireball" dans le Backpack
                local fireballTool = backpack:FindFirstChild("Fireball")
                if fireballTool then
                    -- Cloner le Tool et le placer dans le Backpack du joueur local
                    local clonedTool = fireballTool:Clone()
                    clonedTool.Parent = LocalPlayer.Backpack
                    print("Tool 'Fireball' copié depuis " .. player.Name .. " vers ton Backpack.")
                    return -- Sortir après avoir copié
                end
            end
        end
    end
    print("Aucun joueur ne possède le Tool 'Fireball'.")
end

-- Appeler la fonction pour copier le Tool
copyFireballTool()
end


-- Interface Fluent UI
local function CreateWindow(theme)
    Fluent = LoadFluent()

    -- Détection de la plateforme
    local platform = detectPlatform()
    local windowSize

    if platform == "Mobile" then
        windowSize = UDim2.new(0, 580, 0, 300) -- Taille réduite pour mobile
        print("Plateforme détectée : Mobile. Taille réduite.")
    else
        windowSize = UDim2.new(0, 580, 0, 460) -- Taille normale pour PC
        print("Plateforme détectée : PC. Taille normale.")
    end

    Window = Fluent:CreateWindow({
        Title = "animal sim",
        SubTitle = "Propulsé par krix",
        TabWidth = 160,
        Size = windowSize,
        Acrylic = true,
        Theme = theme,
        MinimizeKey = Enum.KeyCode.Y
    })
    local Tabs = {
        Main = Window:AddTab({ Title = "Principal", Icon = "home" }), 
        Farm = Window:AddTab({ Title = "Farm", Icon = "leaf" }), 
        Stats = Window:AddTab({ Title = "Stats", Icon = "bar-chart" }),
        FarmTitle = Window:AddTab({ Title = "FarmTitle", Icon = "separator-vertical" }),
        PVP = Window:AddTab({ Title = "PVP", Icon = "swords" }),
        Player = Window:AddTab({ Title = "Player", Icon = "person-standing" }),
        Noel = Window:AddTab({ Title = "Noel", Icon = "gift" }), 
        Utility = Window:AddTab({ Title = "Utility", Icon = "wrench" }), 
        Settings = Window:AddTab({ Title = "Paramètres", Icon = "settings" }) 
    }    
    
    -- Onglet Farm
    Tabs.Farm:AddSection("Options de Farm")
    Tabs.Farm:AddToggle("FarmLevelToggle", {
        Title = "Farm Level",
        Description = "Farm fonction avancé et anti kill en farm",
        Default = false,
        Callback = function(Value)
            if Value then
                FarmLevel()
            else
                StopFarm()
            end
        end
    })
    

    Tabs.Farm:AddToggle("FarmCoin", {
        Title = "Farm Coin",
        Default = false,
        Callback = function(Value) if Value then FarmCoin() else StopFarm() end end
    })

    Tabs.Farm:AddToggle("FarmBoss", {
        Title = "Farm Boss",
        Default = false,
        Callback = function(Value) if Value then FarmBoss() else StopFarm() end end
    })

    Tabs.Farm:AddToggle("FarmBossTPToggle", {
        Title = "Farm Boss whit tp",
        Description = "farm boss avec teleportations + vite que le farm normal",
        Default = false,
        Callback = function(Value)
            if Value then
                FarmBossTP() -- Active le farming
            else
                StopFarmBossTP() -- Stoppe proprement la boucle
            end
        end
    })


    Tabs.FarmTitle:AddSection("Options de Farm Title")
    Tabs.FarmTitle:AddToggle("FarmTitle", {
        Title = "Farm Titre",
        Description = "Farm les titre",
        Default = false,
        Callback = function(Value)
            toggleResetAndAttackLoop(Value)
        end
    })

    Tabs.Stats:AddSection("Suivi en Temps Réel")

Tabs.Stats:AddToggle("StatsTrackingToggle", {
    Title = "Activer Suivi des Stats",
    Description = "Affiche l'XP gagnée par seconde et le temps pour atteindre 100 niveaux.",
    Default = false,
    Callback = function(Value)
        if Value then
            StartStatsTracking(Tabs.Stats)
        else
            StopStatsTracking()
        end
    end
})

    
    


    -- Onglet PVP
    Tabs.PVP:AddSection("Détection Auto PVP")
    Tabs.PVP:AddToggle("PVPDetection", {
        Title = "Détection Auto PVP",
        Description = "Active ou désactive la détection automatique des joueurs proches.",
        Default = false,
        Callback = function(Value)
            isActive = Value
            if isActive then
                print("Détection PVP Activée")
            else
                print("Détection PVP Désactivée")
            end
        end
    })

    Tabs.PVP:AddSection("Fire Aura")

Tabs.PVP:AddToggle("FireAuraToggle", {
    Title = "Activer Fire Aura",
    Description = "Envoie des Fireballs sur le joueur le plus proche dans un rayon de 20 studs.",
    Default = false,
    Callback = function(Value)
        ToggleFireAura(Value)
    end
})

-- Interface Fluent UI
Tabs.PVP:AddSection("Hitbox Settings")

-- Toggle pour afficher/masquer la Hitbox
Tabs.PVP:AddToggle("HitboxVisibleToggle", {
    Title = "Afficher Hitbox",
    Description = "Affiche ou masque la Hitbox des joueurs.",
    Default = false,
    Callback = function(Value)
        hitboxVisible = Value
        print(Value and "Affichage des Hitbox activé." or "Affichage des Hitbox désactivé.")
        ApplyHitbox()
    end
})

-- Input pour définir la taille de la Hitbox
Tabs.PVP:AddInput("HitboxSizeInput", {
    Title = "Taille de la Hitbox",
    Placeholder = "Ex: 5",
    Default = "5",
    Numeric = true,
    Callback = function(Value)
        local newSize = tonumber(Value)
        if newSize then
            _G.HeadSize = newSize
            print("Nouvelle taille de la Hitbox :", _G.HeadSize)
            ApplyHitbox()
        else
            print("Valeur invalide pour la Hitbox.")
        end
    end
})

-- Toggle pour activer/désactiver la Hitbox
Tabs.PVP:AddToggle("HitboxToggle", {
    Title = "Activer la Hitbox",
    Description = "Active ou désactive l'application de la Hitbox.",
    Default = false,
    Callback = function(Value)
        ToggleHitbox(Value)
    end
})



    Tabs.Player:AddSection("Section Speed")
    -- Ajouter un Toggle pour activer/désactiver le Speed
    Tabs.Player:AddToggle("SpeedToggle", {
    Title = "Activer Speed",
    Description = "Augmente la vitesse de déplacement du joueur.",
    Default = false,
    Callback = function(Value)
        isSpeedEnabled = Value
        updateSpeed()
        print("Speed activé :", isSpeedEnabled)
    end
})

-- Ajouter un Slider pour ajuster la vitesse
Tabs.Player:AddSlider("SpeedSlider", {
    Title = "Vitesse du Joueur",
    Description = "Ajustez la vitesse du joueur.",
    Min = 16, -- Vitesse normale
    Max = 300, -- Vitesse maximale
    Default = 16, -- Valeur initiale
    Rounding = 1, -- Arrondi
    Callback = function(Value)
        speedValue = Value
        updateSpeed()
        print("Nouvelle vitesse réglée :", speedValue)
    end
})

    Tabs.Player:AddSection("Section jump")
    -- Ajouter un Toggle pour activer/désactiver le Jump
Tabs.Player:AddToggle("JumpToggle", {
    Title = "Activer Jump",
    Description = "Augmente la hauteur de saut du joueur.",
    Default = false,
    Callback = function(Value)
        isJumpEnabled = Value
        updateJumpPower()
        print("Jump activé :", isJumpEnabled)
    end
})

-- Ajouter un Slider pour ajuster le JumpPower
Tabs.Player:AddSlider("JumpSlider", {
    Title = "Hauteur du Saut",
    Description = "Ajustez la hauteur de saut du joueur.",
    Min = 50, -- Valeur par défaut de Roblox
    Max = 300, -- Valeur maximale
    Default = 50, -- Valeur initiale
    Rounding = 1, -- Arrondi
    Callback = function(Value)
        jumpPowerValue = Value
        updateJumpPower()
        print("Nouvelle hauteur de saut réglée :", jumpPowerValue)
    end
})

    Tabs.Player:AddSection("Section Fly")
    -- Bouton Delete Sound and GUI
    Tabs.Player:AddButton({
        Title = "Fly",
        Description = "Fly",
        Callback = function()
            Fly()
        end
    })

    -- Onglet Utility
    Tabs.Utility:AddSection("Anti-AFK")
    Tabs.Utility:AddToggle("AntiAfkToggle", {
        Title = "Activer Anti-AFK",
        Description = "Empêche Roblox de vous déconnecter pour inactivité.",
        Default = false,
        Callback = function(Value)
            ToggleAntiAfk(Value)
        end
    })
    
     -- Bouton Delete Sound and GUI
     Tabs.Utility:AddButton({
        Title = "Delete Sound and GUI",
        Description = "Supprime tous les sons et GUI dans le jeu.",
        Callback = function()
            DeleteSoundAndGUI()
        end
    })

    -- Bouton Delete Sound and GUI
    Tabs.Utility:AddButton({
        Title = "Mobile keyboard",
        Description = "Mobile keyboard for minimiz",
        Callback = function()
            MobileKey()
        end
    })
    Tabs.Utility:AddButton({
        Title = "Free x13",
        Callback = function()
            X13()
        end
    })
    Tabs.Utility:AddButton({
        Title = "Free fire",
        Description = "il faut que au moin 1 joueur a la fireball",
        Callback = function()
            FreeFireball()
        end
    })
    

-- Onglet Principal
Tabs.Main:AddParagraph({
    Title = "Bienvenue",
    Content = [[
✨ Dernières Mises à Jour ✨

🔧 Corrections de Bugs :
- Hitbox : Le problème d'affichage et de réinitialisation des hitboxes a été corrigé.
- Farm Level : Le script gère désormais correctement la téléportation vers les deux types de Dummy (Dummy normal et 5K Dummy).

🔥 Nouvelles Fonctionnalités :
- Fire Aura : 
   - Envoie automatiquement des Fireballs sur le joueur le plus proche dans un rayon de 30 studs.
   - La fréquence d'attaque est réglée pour éviter les spams excessifs.

- Menu Stats :
   - Suivi en temps réel de vos statistiques.
   - Affiche l'XP gagnée par seconde et le temps estimé pour atteindre 100 niveaux.
   - Formatage clair en heures, minutes et secondes pour plus de précision.

💬 Informations :
- Pour signaler un bug ou partager des suggestions, contacte-moi sur Discord : lf_29.
- Thème actuel : ]] .. theme .. [[
    ]]
})



    -- Onglet Paramètres
    Tabs.Settings:AddSection("Thème")
    Tabs.Settings:AddDropdown("ThemeSelector", {
        Title = "Changer de Thème",
        Values = {"Dark", "Light", "Amethyst", "Aqua", "Rose", "Darker"},
        Default = theme,
        Callback = function(SelectedTheme)
            currentTheme = SelectedTheme
            Window:Destroy()
            CreateWindow(currentTheme)
        end
    })

    Tabs.Noel:AddSection("Christmas event")
        -- Toggle Auto Candy
        Tabs.Noel:AddToggle("AutoCandy", {
            Title = "Auto Candy",
            Description = "Téléportation, frappe, et collecte automatique des bonbons.",
            Default = false,
            Callback = function(Value)
                if Value then
                    AutoCandy()
                else
                    StopAutoCandy()
                end
            end
        })

        Tabs.Noel:AddInput("CandyCoinInput", {
            Title = "Entrer la valeur de Candy Coin",
            Description = "Enter the number of Candy Coins to save.",
            Placeholder = "Ex : 9999",
            Numeric = true,
            Callback = function(Value)
                if tonumber(Value) then
                    -- Créer les arguments pour envoyer la valeur
                    local args = {
                        [1] = {
                            ["action"] = "save_coin",
                            ["newCandyCoin"] = tonumber(Value)
                        }
                    }
    
                    -- Envoi des arguments via RemoteEvent
                    game:GetService("ReplicatedStorage").Christmas2024.RemoteEvent:FireServer(unpack(args))
                    print("Valeur envoyée : " .. Value)
    
                    -- Notification que le joueur va quitter
                    Fluent:Notify({
                        Title = "Déconnexion",
                        Content = "Vous allez être déconnecté dans 5 secondes...",
                        Duration = 5
                    })
    
                    -- Attente de 5 secondes avant de quitter
                    wait(5)
                    game:GetService("Players").LocalPlayer:Kick("Re join a game to update your candy coins.")
                else
                    print("Veuillez entrer une valeur numérique valide.")
                end
            end
        })

    Window:SelectTab(1)
end

-- Boucle principale pour la détection PVP
RunService.RenderStepped:Connect(function()
    if isActive then
        for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (player.Character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance <= detectionDistance then
                    -- Simule une pression de la touche Q
                    local virtualInput = game:GetService("VirtualInputManager")
                    virtualInput:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                    wait(0.1) -- Anti-spam
                    break
                end
            end
        end
    end
end)

-- Initialisation
CreateWindow(currentTheme)
