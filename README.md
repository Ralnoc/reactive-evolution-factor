# Reactive Evolution Factor
Fork of [Evolution-Reduction-Redux](https://github.com/bkrumholz/Evolution-Reduction-Redux/tree/master)

## Overview
**Reactive Evolution Factor** is a mod for Factorio that dynamically updates the process of calculating the evolution factor of enemy forces. It introduces a 
unique mechanic where destroying enemy turrets and unit-spawners reduces the evolution factor, adding strategic depth to combat and base-building.

## Features

1. **Dynamic Evolution Reduction**:
   - Each turret and spawner entity contributes a unique reduction value to the evolution factor upon destruction.
   - Has a standard reduction value for which it will default to, in case it does not have a defined reduction value.
   - Encourages targeted destruction of high-value enemy structures to slow enemy evolution.

2. **Customization for Modders**:
   - Other mod creators can integrate with this mod to define custom reduction values for new turrets and spawners
   - This allows seamless integration of custom entities into the evolution reduction system.

3. **Settings**:
   - Adjust available settings through in-game mod settings window.
   - Enable or disable debug messages to monitor evolution factor changes in real-time.

4. **Balanced Gameplay**:
   - Reduction values are carefully calibrated to maintain a balanced gameplay experience.

## Factorio Space Age Turrets and Unit Spawn Reductions

The following default reduction values are included:

### Turrets
| Entity Name             | Reduction Value |
|-------------------------|-----------------|
| small-worm-turret       | 0.00003         |
| medium-worm-turret      | 0.00006         |
| big-worm-turret         | 0.00009         |
| behemoth-worm-turret    | 0.00015         |

### Unit Spawners
| Entity Name             | Reduction Value |
|-------------------------|-----------------|
| biter-spawner           | 0.012           |
| spitter-spawner         | 0.010           |
| gleba-spawner-small     | 0.010           |
| gleba-spawner           | 0.012           |

These values can be extended by other mods using the provided API.

## Installation

### In-Game Browser Installation
1. Open the in-game mod manager.
2. Search for "Reactive Evolution Factor".
3. Install the mod and restart the game.

### Manual Installation
1. Download the mod from the [Factorio Mods Portal](https://mods.factorio.com/).
2. Place the mod's `.zip` file into the `mods` folder in your Factorio installation directory.
3. Enable the mod through the in-game mod manager.

## Usage

- Upon destroying enemy turrets or spawners, the evolution factor will automatically decrease based on the configured reduction values.
- Monitor evolution factor value changes using the debug messages if enabled.

## Logged Events

Leveraging the [Events Logger](https://mods.factorio.com/mod/events-logger) mod, Reactive Evolution Factor logs the following event to the `game-events.json` file:
```json
{
  "surface": "The name of the current surface.",
  "dead_entity_name": "The name of the entity that was destroyed.",
  "current_evolution": "The current evolution factor before the reduction.",
  "altered_evolution": "The evolution factor after the reduction.",
  "standard_reduction": "The standard reduction factor value.",
  "reduction_factor": "The calculated reduction factor for the destroyed entity.",
  "destruction_factor": "The evolution factor contributed by killing spawners on the current surface.",
  "pollution_factor": "The evolution factor contributed by pollution on the current surface.",
  "time_factor": "The evolution factor contributed by time on the current surface.",
  "final_evolution_factor": "The final evolution factor after all calculations."
}
```

### For Mod Developers

By default, any `turret` or `unit-spawner` entities that Reactive Evolution Factor is unaware of will receive the default reduction vaulue of `0.002`. 
If you wish to have a unique value for your custom entity, you can integrate them from your mods using the following API:

```lua
remote.call("reactive-evolution-factor", "add_reduction_value", {
    ["turret"] = {
        ["custom-turret"] = 0.00005
    },
    ["unit-spawner"] = {
        ["custom-spawner"] = 0.015
    }
})
```

This makes Reactive Evolution Factor aware of the new entities and applies the specified reduction values when they are destroyed.

## Debugging

Enable debug messages through the in-game settings to observe detailed information about:
- Current evolution factor.
- Entity destroyed that triggered the evolution factor change.
- Reduction values applied for each destroyed entity.
- Real-time evolution factor breakdown (time, pollution, destruction).

## License

This mod is released under the [MIT License](https://opensource.org/licenses/MIT). Feel free to modify and distribute it as long as credit is given to the original creator.

## Contributing

Contributions are welcome! If you have ideas for improvement or additional features, please submit a pull request or create an issue in the 
Repository [at this location](https://github.com/Ralnoc/reactive-evolution-factor/issues).

---

