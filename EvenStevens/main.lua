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
			pickup:Remove()
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_LITTLE_STEVEN, pos, Vector.Zero, nil)
		-- if pickup ID is Little Steven and last killed variant was Steven, then
		elseif pickup.SubType == CollectibleType.COLLECTIBLE_LITTLE_STEVEN and lastKilledVariant == NPC_VARIANT_STEVEN then
			lastKilledVariant = 0
			local pos = pickup.Position
			-- swap out original drop for Steven
			pickup:Remove()
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_STEVEN, pos, Vector.Zero, nil)
		end
	end
end

EvenStevens:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EvenStevens.OnNPCDeath)
EvenStevens:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, EvenStevens.OnPickupSpawned)