local EvenStevens = RegisterMod("EvenStevens", 1)
local ID_BOSS_STEVEN = 20
local NPC_VARIANT_STEVEN = 1
local NPC_VARIANT_STEVEN_BABY = 11
local lastKilledVariant = 0

---@param npc EntityNPC
function EvenStevens:OnNPCDeath(npc)
	if npc:GetBossID() == ID_BOSS_STEVEN then -- Steven & Steven Baby = Boss ID 20
		lastKilledVariant = npc.Variant
	end
end

---@param pickup EntityPickup
function EvenStevens:OnPickupSpawned(pickup)
	if pickup.Type == EntityType.ENTITY_PICKUP and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
		-- if pickup ID is Steven and last killed variant was Steven Baby, then
		if pickup.SubType == CollectibleType.COLLECTIBLE_STEVEN and lastKilledVariant == NPC_VARIANT_STEVEN_BABY then
			lastKilledVariant = 0
			local pos = pickup.Position
			-- swap out original drop for Little Steven
			pickup:Morph(pickup.Type, pickup.Variant, CollectibleType.COLLECTIBLE_LITTLE_STEVEN)
		-- if pickup ID is Little Steven and last killed variant was Steven, then
		elseif pickup.SubType == CollectibleType.COLLECTIBLE_LITTLE_STEVEN and lastKilledVariant == NPC_VARIANT_STEVEN then
			lastKilledVariant = 0
			local pos = pickup.Position
			-- swap out original drop for Steven
			pickup:Morph(pickup.Type, pickup.Variant, CollectibleType.COLLECTIBLE_STEVEN)
		end
	end
end

EvenStevens:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EvenStevens.OnNPCDeath)
EvenStevens:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, EvenStevens.OnPickupSpawned)