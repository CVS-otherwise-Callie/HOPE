local mod = FHAC
local rng = RNG()
local game = Game()
local player = Isaac.GetPlayer()
--this will get used at some point i swear
FHAC.Scripts = {
    Monsters = {
		Fivehead = include("scripts.iam.monsters.fivehead"),
		Floater = include("scripts.iam.monsters.floater"),
		Neutralfly = include("scripts.iam.monsters.neutralfly"),
		Dried = include("scripts.iam.monsters.dried"),
		Erythorcyte = include("scripts.iam.monsters.erythorcyte"),
		Wost = include("scripts.iam.monsters.wost"),
		Schmoot = include("scripts.iam.monsters.schmoot"),
		Snidge = include("scripts.iam.monsters.snidge"),
	},

	Items = {
		StinkyMushroom = include("scripts.iam.items.stinky mushroom"),
	},

	Jokes = {
		Gaperrr = include("scripts.iam.jokes.gaprrr"),
	},

    DSS = {
		DeadSeaScrolls = include("scripts.iam.deadseascrolls.deadseascrolls")
	},
    
    Characters = {
        Johannes = include("scripts.iam.characters.johannes")
    },

	Config = {
		include("scripts.iam.musicconfig")
	}
}

--uh

if mod.Savedata.DeathFortunes then
	FHAC:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function() 
		if rng:RandomInt(1, 3) == 1 then 
			FHAC:ShowFortune() 
		end 
	end)
end

mod.LuaFont = Font()
mod.LuaFont:Load("font/luamini.fnt")

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if not FiendFolio then
		--i kept going back and forth but this is weirdly very efficient
		--cus what happened was I said "i'll do it differently" nut thren I took notes and it was the exact samw idea sooooo 
		local currentRoom = StageAPI.GetCurrentRoom()
		local roomDescriptorData = game:GetLevel():GetCurrentRoomDesc().Data
		local center = StageAPI.GetScreenCenterPosition()
		local br = StageAPI.GetScreenBottomRight()
		local scale = 1
		local text = ""
		local vartext = ""
		local bcenter = Vector(center.X, br.Y - 152 * 2)
		local ismodtext = false
		local icon = Sprite()

		if currentRoom and currentRoom.Layout then
			text = text .. tostring(currentRoom.Layout.Variant) .. " " .. currentRoom.Layout.Name
		else
			local useVar = roomDescriptorData.Variant
			if useVar >= 24000 and useVar <= 75000 then
				ismodtext = true
				useVar = useVar - 23999
				text = "(HOPE) "
			end

			text = text .. roomDescriptorData.Name
			vartext = "- " .. tostring(useVar) .. " -"
		end

		if not ismodtext then

			--dont question the process
			if roomDescriptorData.Type ~= 5 then
				if text and string.find(text, "New Room") or string.find(text, "copy") or string.find(text, "Copy") or text == "" or string.find(text, "Shop") or string.find(text, "Dungeon") then
					text = game:GetLevel():GetName()
				end
			end

			if roomDescriptorData.Type ~= 5 and roomDescriptorData.Type ~= 6 and roomDescriptorData.Type ~= 27 and roomDescriptorData.Type >= 2 then
				text = text .. ": " .. mod:GetRoomNameByType(roomDescriptorData.Type)
			elseif roomDescriptorData.Type == 5 then
				text = mod:removeSubstring(text, "(copy)")
				text = mod:removeSubstring(text, "()") -- WHAT THE FUCCKCKCCKKCKCCKK
			elseif roomDescriptorData.Type == 6 then
				text = mod:GetRoomNameByType(roomDescriptorData.Type) .. ": " .. text
			end
		
			text = "- " .. text .. " -"

		end
		local size = mod.LuaFont:GetStringWidth(text) * scale
		local varsize = mod.LuaFont:GetStringWidth(vartext) * scale

		--bcenter = player.Position
		mod.LuaFont:DrawStringScaled(text, bcenter.X - (size/2), bcenter.Y, scale, scale, KColor(1,1,1,0.5), 0, false)
		mod.LuaFont:DrawStringScaled(vartext, bcenter.X - (varsize / 2), bcenter.Y + 10, scale, scale, KColor(1,1,1,0.5), 0, false)
		icon:Load("gfx/characters/johanneshair.anm2", true)
		icon:Render(bcenter, Vector.Zero, Vector.Zero)
		icon:Play("Idle")
	end
end)