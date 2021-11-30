-- VARIABLES 
local camera = workspace.CurrentCamera
local CollectionService = game:GetService("CollectionService")
local localplr = game.Players.LocalPlayer
local PlayerCharacter = {}
local me = getgenv().CHAR
PlayerCharacter.TAG_NAME = "PlayerCharacter"

-- SETTINGS, FEEL FREE TO CHANGE
local settings = {
RagDolls = false,
Center = true,
Part = "Head",
}
-- FUNCTIONS

function createObject(object,parent)
    Instance.new(object,parent)
end

function createInt(parent)
    local e = Instance.new("IntValue",parent)
    e.Name = "esp"
end

spawn(function()
    game:GetService("RunService").Heartbeat:Connect(function()
        getgenv().CHAR = game.Players.LocalPlayer.Character
    end)
end)

function getWeapon(character)
   local weapon = nil
   local player = game.Players:FindFirstChild(character)
   if player:FindFirstChild("GunInventory") ~= nil then
       for i,v in pairs(player.GunInventory:GetChildren()) do
            if v == player.CurrentSelectedObject.Value then
                weapon = v
           end
       end
    end
   return weapon
end

function roundNumber(num, numDecimalPlaces)
    return math.floor(num * 10^numDecimalPlaces) / 10^numDecimalPlaces
end

-- ADDING ESP TO AVAILABLE PLAYERS
local function Name(character)
    if getgenv().CHAR:FindFirstChild("HumanoidRootPart") ~= nil and character:FindFirstChild("HumanoidRootPart") ~= nil and character:FindFirstChild("Humanoid") ~= nil and character:FindFirstChild("FacingPart") ~= nil and (character.HumanoidRootPart.Position - getgenv().CHAR.HumanoidRootPart.Position).magnitude < 1750 and getgenv().CHAR:FindFirstChild("HumanoidRootPart") ~= nil then
    createInt(character)
    local NameTag = Drawing.new("Text")
    NameTag.Visible = false
    NameTag.Center = settings.Center
    NameTag.Outline = false
    NameTag.Size = 12
    NameTag.Color = Color3.new(255,0,0) --> or any color, using FromRGB|
    NameTag.Outline = true
    local function UPDATER()
        local update
        update = game:GetService("RunService").RenderStepped:Connect(function()
            if character ~= nil and character:FindFirstChild("HumanoidRootPart") ~= nil and character:FindFirstChild("Humanoid") ~= nil and character:FindFirstChild("Humanoid").Health > 0 and character:FindFirstChild("FacingPart") ~= nil and character.Name ~= "RagDoll" or settings.RagDolls == true then
                        local vector, onscreen = camera:WorldToViewportPoint(character[settings.Part].Position)

                        if onscreen and game.Players:FindFirstChild(tostring(character)) ~= nil and getWeapon(tostring(character)).Value ~= nil and getgenv().CHAR:FindFirstChild("HumanoidRootPart") then
                            NameTag.Position = Vector2.new(vector.X,vector.Y)
                            NameTag.Visible = true
                            local weapon = getWeapon(tostring(character))
                            NameTag.Text = character.Name .. "|" .. tostring(weapon.Value) .. "|" .. roundNumber((character.HumanoidRootPart.Position - getgenv().CHAR:FindFirstChild("HumanoidRootPart").Position).magnitude/2.958,2) .. "m"
                        else
                            NameTag.Visible = false
                        end
                    else
                        NameTag.Visible = false
                        NameTag:Remove()
                        update:Disconnect()
                    end
                end)
            end
        coroutine.wrap(UPDATER)()
    end
end

while wait(0.5) do
for _,v in pairs(CollectionService:GetTagged(PlayerCharacter.TAG_NAME)) do
    if settings.RagDolls or v.Name ~= "RagDoll" and v.Name ~= localplr.Name and v:FindFirstChild("esp") == nil and getgenv().CHAR:FindFirstChild("HumanoidRootPart") ~= nil then
        coroutine.wrap(Name)(v) 
        print(v)
    end
end
end
