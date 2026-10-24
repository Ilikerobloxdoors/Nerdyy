
---====== Load spawner ======

local Spawner = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/RegularVynixu/DOORS-Entity-Spawner-V2/main/init.luau"
))()

---====== Load achievements ======

local CustomAchievements = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/RegularVynixu/DOORS-Custom-Achievements/main/init.luau"
))()

---====== Achievement settings ======

local AchievementInfo = {
    Identifier = "GoStudy",
    Title = "Go Study",
    Desc = "Wear Glasses And Go Do Homework",
    Reason = "Survive The Mathematics Nerd",
    Image = "rbxassetid://646246988"
}

local achievementGranted = false
local entitySpawned = false
local entityKilledPlayer = false

local function GrantNERDDAchievement()
    if achievementGranted then
        return
    end

    achievementGranted = true

    CustomAchievements:Grant(AchievementInfo, {
        CheckOwned = true,
        Remember = true
    })
end

---====== Create NERDD ======

local entity = Spawner:Create({
    Entity = {
        Name = "NERDD",
        Asset = "https://github.com/Ilikerobloxdoors/Nerdyy/blob/main/NERD.rbxm",
        HeightOffset = 0
    },

    Lights = {
        Flicker = {
            Enabled = true,
            Duration = 2
        },
        Shatter = true,
        Repair = false
    },

    Earthquake = {
        Enabled = false
    },

    CameraShake = {
        Enabled = true,
        Range = 100,
        Values = {35, 50, 0.1, 0.5}
    },

    Movement = {
        Speed = 450,
        Delay = 3,
        Reversed = false
    },

    Rebounding = {
        Enabled = false,
        Type = "Ambush",
        Min = 1,
        Max = 1,
        Delay = 2
    },

    Damage = {
        Enabled = true,
        IgnoreHiding = false,
        Range = 40,
        Amount = 125
    },

    Crucifixion = {
        Type = "Curious",
        Enabled = true,
        Range = 40,
        Resist = false,
        Break = true
    },

    Death = {
        Type = "Guiding",
        Hints = {"Death", "Hints", "Go", "Here"},
        Cause = ""
    }
})

---====== Debug callbacks ======

entity:SetCallback("OnSpawned", function()
    entitySpawned = true
    entityKilledPlayer = false
    achievementGranted = false

    print("NERDD has spawned")
end)

entity:SetCallback("OnStartMoving", function()
    print("NERDD has started moving")
end)

entity:SetCallback("OnEnterRoom", function(room: Model, firstTime: boolean)
    if firstTime then
        print("NERDD entered room: " .. room.Name .. " for the first time")
    else
        print("NERDD entered room: " .. room.Name .. " again")
    end
end)

entity:SetCallback("OnLookAt", function(lineOfSight: boolean)
    if lineOfSight then
        print("Player is looking at NERDD")
    else
        print("Player view is obstructed")
    end
end)

entity:SetCallback("OnRebounding", function(startOfRebound: boolean)
    if startOfRebound then
        print("NERDD started rebounding")
    else
        print("NERDD finished rebounding")
    end
end)

entity:SetCallback("OnDespawning", function()
    print("NERDD is despawning")
end)

entity:SetCallback("OnDespawned", function()
    print("NERDD has despawned")

    -- A despawn alone does not prove survival.
    -- Grant only if the player was not killed by NERDD.
    if entitySpawned and not entityKilledPlayer then
        GrantNERDDAchievement()
    end

    entitySpawned = false
end)

entity:SetCallback("OnDamagePlayer", function(newHealth: number)
    if newHealth <= 0 then
        entityKilledPlayer = true
        print("NERDD killed the player")
    else
        print("NERDD damaged the player")
    end
end)

---====== Run entity ======

entity:Run(true)
