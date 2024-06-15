local mod = FHAC
local game = Game()
local rng = RNG()
local room = game:GetRoom()

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == mod.Monsters.Neutralfly.Var then
        mod:NeutralflyAI(npc, npc:GetSprite(), npc:GetData())
    end
end, mod.Monsters.Neutralfly.ID)

function mod:NeutralflyAI(npc, sprite, d)
    local possibleinits = {}

    d.accel = 1
    
    if not d.init then
        d.entitypos = 500
        d.newpos = 0
        npc.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        npc.SpriteOffset = Vector(0,-12)
        npc.StateFrame = 60
        d.rounds = 0
        d.slowdown = 100
        d.speedup = 0
        d.rotation =  45 * rng:RandomInt(1, 8)
        d.state = "moving"
        sprite:Play("Idle")
        

        --here's some other shit to do
        d.accel = 0
        local speedup = npc.MaxHitPoints - npc.HitPoints
        d.newpos = npc.Position + Vector(10 + speedup, 10 + speedup):Rotated(45 * rng:RandomInt(1, 8))
        if not room:IsPositionInRoom(d.newpos, 0) then
            d.newpos = room:GetClampedPosition(d.newpos, 2)
        end
        npc.StateFrame = 0
        d.newpos = d.newpos - npc.Position

        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "idle" then
        --d.accel = 0
        npc.Velocity = npc.Velocity * 0.9
        d.slowdowntime = d.slowdowntime - 0.05
        sprite:Play("Idle")
        if npc.StateFrame == 100 then
                d.rounds = 0
                d.state = "moving"
        end
        
    end
    --thx erfly
    

    if d.state == "moving" then
                if d.rounds >= 4 then
                    d.slowdowntime = 0.9
                    d.rounds = 0
                    npc.StateFrame = 0
                    d.state = "idle"
                end
                if npc.StateFrame == 20 then
                    for i = 1, 360 do
                        d.newpos = npc.Position + Vector(20 + d.speedup, 20 + d.speedup):Rotated(i)
                        if room:IsPositionInRoom(d.newpos, 0) and not (room:GetGridCollisionAtPos(d.newpos) ~= 0) and room:CheckLine(npc.Position, d.newpos, 0, nil, false, false) == true then
                            table.insert(possibleinits, d.newpos)
                        end
                    end
                    if not mod:IsTableEmpty(possibleinits) then
                        d.newpos = possibleinits[math.random(#possibleinits)] - npc.Position
                    else
                        d.newpos = (npc:GetPlayerTarget().Position - npc.Position):Resized(2000/npc.Position:Distance(npc:GetPlayerTarget().Position))
                    end
                    d.rounds = d.rounds + 1
                    d.accel = 0
                    d.speedup = npc.MaxHitPoints - npc.HitPoints
                elseif npc.StateFrame > 30 then
                    npc.StateFrame = 0
                end

                if npc.StateFrame > 25 then
                    if mod:isScare(npc) then
                        npc.Velocity = mod:Lerp(npc.Velocity, Vector(2, 0), 1, 5, 5)
                    else
                        npc.Velocity = mod:Lerp(npc.Velocity, d.newpos, 0.1 + (d.accel * 0.01), 2, 2)
                        if d.newpos:Rotated(-90):GetAngleDegrees() < 0 then
                            sprite.FlipX = true
                        else
                            sprite.FlipX = false
                        end
                        if d.newpos:GetAngleDegrees() < 0 then
                            mod:spritePlay(sprite, "MovingUp")
                        else
                            mod:spritePlay(sprite, "MovingDown")
                        end
                        d.accel = d.accel + 1
                    end
                    --may as well
                    if not room:IsPositionInRoom(npc.Position, 0) then
                        d.newpos = (room:GetCenterPos() - npc.Position):Resized(1000/npc.Position:Distance(npc:GetPlayerTarget().Position))
                    end
                end
    end

    if d.isnotvalidspace then
        d.newpos = npc.Position + Vector(10 + d.speedup, 10 + d.speedup):Rotated(d.rotation)
        if room:CheckLine(npc.Position, d.newpos, 0, nil, false, false) == true then
        if not (room:GetGridCollisionAtPos(d.newpos) ~= 0 or not room:IsPositionInRoom(d.newpos, 0)) then
            d.isnotvalidspace = false
            return d.newpos
        end
        end
    end

end

