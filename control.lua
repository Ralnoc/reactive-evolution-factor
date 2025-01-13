local _reduction_factors = require("evolution_factors")

---Check if table has entity name.
---@param tab table - Table to check.
---@param val string - Name to check for.
---@return boolean - True if value is present, false if value is missing.
local function has_entity(tab, type, name)
    if tab and tab[type] and tab[type][name] then
        return true
    end
    return false
end

---Add additional reduction factors to the evolution factor storage table.
---@param r_values table - Table of factors to add. Format: {["type"] = {["name"] = factor}}
---@param r_values[type] string - The type of factor to add. (e.g. "unit", "unit-spawner", "turret")
---@param r_values[type][name] string - The name of the factor to add. (e.g. "small-biter", "small-worm-turret")
---@param r_values[type][name] number - The factor to add. (e.g. 0.00003, 0.00006)
remote.add_interface("reactive-evolution-factor", {
    add_reduction_value = function(r_values)
        for type, values in pairs(r_values) do
            if not has_entity(storage.evolution_reduction_factors, type) then
                storage.evolution_reduction_factors[type] = {}
            end
            for name, value in pairs(values) do
                storage.evolution_reduction_factors[type][name] = value
            end
        end
    end
})

function print(msg)
    game.players[1].print(msg)
end

script.on_configuration_changed(function()
    if not storage.evolution_reduction_factors then
        storage.evolution_reduction_factors = _reduction_factors
    end
end)

script.on_init(function()
    storage.evolution_reduction_factors = _reduction_factors
    game.map_settings.enemy_evolution.destroy_factor = 0.0
    game.map_settings.enemy_evolution.pollution_factor = settings.startup["reactive-evolution-factor-pollution-factor"].value
end)

local function reduction_debug_msg()
    if (settings.global["reactive-evolution-factor-enable-debug"].value) then
        local current_surface = game.players[1].surface
        print("Evolution Factors -  Standard Reduction = " .. string.format( "%.15f", settings.global["reactive-evolution-factor-standard-reduction-factor"].value) ..
                "\nDestroy = " .. string.format( "%.15f", game.forces.enemy.get_evolution_factor_by_killing_spawners(current_surface)) ..
                "\nPollution = " .. string.format( "%.15f", game.forces.enemy.get_evolution_factor_by_pollution(current_surface)) ..
                "\nTime = " .. string.format( "%.15f", game.forces.enemy.get_evolution_factor_by_time(current_surface)) ..
                "\nEvolution = " .. string.format( "%.15f", game.forces.enemy.get_evolution_factor(current_surface)))
    end
end

script.on_event(defines.events.on_entity_died, function(event)
    local dead_entity = event.entity
    local reduction_value = 0.0
    local altered_evolution = 0.0
    local current_surface = dead_entity.surface
    local current_evolution = game.forces.enemy.get_evolution_factor(current_surface)
    local dead_entity_type = dead_entity.type
    local dead_entity_name = dead_entity.name
    local enable_debug = DEBUG or (settings.global["reactive-evolution-factor-enable-debug"].value)
    local gearing_for_war_enabled = settings.global["reactive-evolution-factor-aliens-gear-for-war"].value
    local pollution_reduction_factors = storage.evolution_reduction_factors

	if settings.global["reactive-evolution-factor-reduction-factor"].value >= 1 then
        if current_evolution > settings.global["reactive-evolution-factor-minimum-evolution-factor"].value then
            if enable_debug then
                print("Has Entity ".. dead_entity_name .."(".. dead_entity_type ..") in reduction factor: " .. tostring(has_entity(pollution_reduction_factors, dead_entity_type, dead_entity_name)))
            end
            if dead_entity_type ~= "unit" then
                if has_entity(pollution_reduction_factors, dead_entity_type, dead_entity_name) then
                    local entity_reduction_factor = pollution_reduction_factors[dead_entity_type][dead_entity_name]
                    if entity_reduction_factor then
                        reduction_value = entity_reduction_factor * (settings.global["reactive-evolution-factor-reduction-factor"].value / 100)
                    else
                        reduction_value = settings.global["reactive-evolution-factor-standard-reduction-factor"].value * (settings.global["reactive-evolution-factor-reduction-factor"].value / 100)
                    end
                end
            end
        end

        if reduction_value > 0.0 then
            if current_evolution < 1.0 then
                altered_evolution = (current_evolution - (reduction_value * (1 - current_evolution)))
                if altered_evolution > settings.global["reactive-evolution-factor-minimum-evolution-factor"].value then
                    game.forces.enemy.set_evolution_factor(altered_evolution, current_surface)
                else
                    game.forces.enemy.set_evolution_factor(settings.global["reactive-evolution-factor-minimum-evolution-factor"].value, current_surface)
                end
            else
                game.forces.enemy.set_evolution_factor(0.99, current_surface)
            end

            if gearing_for_war_enabled then
                game.forces.enemy.set_evolution_factor_by_pollution(game.forces.enemy.get_evolution_factor_by_pollution(current_surface) + (settings.global["reactive-evolution-factor-evolution-increment-factor"].value * reduction_value), current_surface)
                game.forces.enemy.set_evolution_factor_by_time(game.forces.enemy.get_evolution_factor_by_time(current_surface) + ((settings.global["reactive-evolution-factor-evolution-increment-factor"].value * reduction_value) / 10), current_surface)
            end

            if enable_debug then
                print("\nEvolution Factors (" .. current_surface.name .. ")" ..
                        "\nEntity Destroyed (" .. dead_entity_name .. ")" ..
                        "\nCurrent Evolution: " .. string.format( "%.15f", current_evolution) ..
                        "\nAltered Evolution: " .. string.format( "%.15f", altered_evolution) ..
                        "\nStandard Reduction = " .. string.format( "%.15f", settings.global["reactive-evolution-factor-standard-reduction-factor"].value) ..
                        "\nReduction = " .. string.format( "%.15f", reduction_value) ..
                        "\nDestroy = " .. string.format( "%.15f", game.forces.enemy.get_evolution_factor_by_killing_spawners(current_surface)) ..
                        "\nPollution = " .. string.format( "%.15f", game.forces.enemy.get_evolution_factor_by_pollution(current_surface)) ..
                        "\nTime = " .. string.format( "%.15f", game.forces.enemy.get_evolution_factor_by_time(current_surface)) ..
                        "\nEvolution = " .. string.format( "%.15f", game.forces.enemy.get_evolution_factor(current_surface))
                )
            end
        end
    end
end
)

-- Ticks to time conversion: 60 ticks = 1 second
script.on_nth_tick(60*30, reduction_debug_msg) -- 60 ticks * 30 seconds