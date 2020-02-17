-- init.lua

-- API object
sounditems = {}
sounditems.registered_items = {}

-- support for MT game translation.
local S = minetest.get_translator("sounditems")

local handlers = {}

function sounditems.register(name, def)
	if not name:find(":") then
		name = "sounditems:" .. name
	end

	if not def.sound then
		def.sound.name = "partyhorn"
        def.sound.length = 1
        def.sound.gain = 1
	end

	minetest.register_craftitem(":" .. name, {
		description = def.description,
		inventory_image = def.inventory_image,

		on_use = function(itemstack, user, pointed_thing)
            local name = user:get_player_name()

            if not handlers[name] then
                handlers[name] = 0
            end

            -- Check if players last sound isn't playing
            if handlers[name] == 0 then
                handlers[name] = 1

		        local handle = minetest.sound_play(def.sound.name, {
                    pos = user:get_pos(),
                    object = minetest.get_player_by_name(name),
                    gain = def.sound.gain,
                    max_hear_distance = 100
                })

                minetest.after(def.sound.length, function(handle)
	                minetest.sound_stop(handle)
                    handlers[user:get_player_name()] = 0
                end, handle)

                return itemstack
	        end
        end
	})
end

sounditems.register("partyhorn", {
	description = S("Party Horn"),
	inventory_image = "sounditems_partyhorn.png",
    sound = {name = "sounditems_partyhorn", length = 4.6, gain = 3},
})
