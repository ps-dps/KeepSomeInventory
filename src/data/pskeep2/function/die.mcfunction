advancement ~/ {
    "criteria": {
        "requirement": {
            "trigger": "minecraft:entity_hurt_player",
            "conditions": {
                "player": [
                    {
                        "condition": "minecraft:entity_properties",
                        "entity": "this",
                        "predicate": {
                            "nbt": "{Health:0f}"
                        }
                    }
                ]
            }
        }
    },
    "rewards": {
        "function": "pskeep2:die"
    }
}
advancement revoke @s only ~/

# store items before and after clearing
data modify storage pskeep2:main items.all set from entity @s Inventory
clear @s #pskeep2:drop
data modify storage pskeep2:main items.left set from entity @s Inventory

# if no items are left after clearing but were before -- drop all
unless data storage pskeep2:main items.left[0] if data storage pskeep2:main items.all[0] function ~/drop_all_recursive:
    data modify storage pskeep2:main drop.item set from storage pskeep2:main items.all[-1]
    function pskeep2:drop with storage pskeep2:main drop
    data remove storage pskeep2:main items.all[-1]
    if data storage pskeep2:main items.all[0] function ~/

# go through all items and drop the cleared ones
if data storage pskeep2:main items.all[0] function ~/drop_recursive:
    data modify storage pskeep2:main drop.item set from storage pskeep2:main items.left[-1]
    store result score #is_different pskeep2 data modify storage pskeep2:main drop.item set from storage pskeep2:main items.all[-1]
    if score #is_different pskeep2 matches 1 function pskeep2:drop with storage pskeep2:main drop
    data remove storage pskeep2:main items.all[-1]
    if score #is_different pskeep2 matches 0 data remove storage pskeep2:main items.left[-1]
    # if no items are left -- drop all to prevent unforseen behavior
    unless data storage pskeep2:main items.left[0] if data storage pskeep2:main items.all[0] return run function ~/../drop_all_recursive
    if data storage pskeep2:main items.all[0] function ~/
