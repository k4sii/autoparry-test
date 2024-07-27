canautoparry = call
                            if canautoparry then
                                startautoparry()
                            else
                                for i,v in next, parrycon do
                                    v:Disconnect()
                                end
                                table.clear(parrycon)
                            end
                        end

local canautoparry = true 
local canautorapture = false
local canautospam = true 
local canautocurve = false
local parrydist = 1.65
local oldparrydist = 1.65
local autospamspeed = 12
local parrycon = {}

startautoparry = function()
    spawn(function()
        local raptureremote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("PlrRaptured")
        local lasthit = tick()
        local reset = nil
        local spamnoti = true
        local canhit = true
        table.insert(parrycon, game:GetService("RunService").PreRender:Connect(function()
            if not canautoparry then
                for i,v in next, parrycon do
                    v:Disconnect()
                end
                table.clear(parrycon)
            end
            local ball, mag, ballpos, istraining = getnearestball()
            if ball and mag and ballpos and isballtargetingplr() then
                
                reset = true 
                local speed = ball.AssemblyLinearVelocity.Magnitude
                local speedy = ball.AssemblyLinearVelocity.Y
                local args = {
                    [1] = 0.5,
                    [2] = canautocurve and cframes[math.random(1, #cframes)] or CFrame.new(0,0,0),
                    [3] = getcloseplr() and {[tostring(getcloseplr().Name)] = getcloseplr().Character.PrimaryPart.Position} or getplrs(),
                    [4] = {
                        [1] = math.random(200, 500),
                        [2] = math.random(100, 200)
                    },
                    [5] = false
                }
                local magplr = 40
                if canautospam and canautoparry and not istraining then
                    local plrname = getfrom()
                    if plrname and getplr(plrname) and getplrmag(getplr(plrname).PrimaryPart) then 
                        magplr = getplrmag(getplr(plrname).PrimaryPart)
                    end
                    if tick() - lasthit < 0.35 or 24 >= magplr and canhit and speed >= 300 then
                        for i = 1, autospamspeed do
                            if 23.5 < mag and speed <= 210 then
                                task.wait(mag/170)
                            end
                            if spamnoti then
                                spamnoti = false
                                guilib:notify({
                                    title = "Auto Spam Trigger", 
                                    info = "Auto spam has been triggered!", 
                                    dur = 4
                                })
                                task.delay(8, function()
                                    spamnoti = true 
                                end)
                            end
                            for i = 1,autospamspeed do
                                hitremote:FireServer(unpack(args))
                                if not magplr or getplr(plrname):FindFirstChildWhichIsA("Humanoid").Health < 0.1 or  magplr >= 26 or 270 >= speed or tick() - lasthit > 0.85 or not lp.Character:IsDescendantOf(game:GetService("Workspace"):FindFirstChild("Alive")) or not canautoparry then
                                    break
                                end
                            end        
                        end
                    end
                end
                if canautorapture then
                    if (speed / mag) >= (parrydist - 0.05) then
                        raptureremote:FireServer(unpack(args))
                    end
                end
                speed -= 15
                if lp.Character:FindFirstChildWhichIsA("Humanoid") and lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection ~= Vector3.zero then
                    speed -= 2.75
                end
                if (speed / mag) >= (parrydist) and speed > 50 or 25 > mag then
                    if canautoparry and canhit and speed > 0 then
                        if speedy > 30 and speed >= 280 then
                            task.wait(speedy/(speed/0.5))
                        end
                        canhit = false
                        hitremote:FireServer(unpack(args))
                        task.delay(2, function()
                            canhit = true
                        end)
                    end
                end
            else
                if reset then
                    canhit = true
                    if not isballtargetingplr() or not ball then
                        lasthit = tick()
                    end
                    reset = nil
                end
            end
        end))
    end)
end
