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

# clear all items with a vanishing enchantment to remove permanently
clear @s *[enchantments~[{enchantments:vanishing_curse}]]
# store items before and after clearing
data modify storage pskeep2:main items.all set from entity @s Inventory
clear @s #pskeep2:drop
data modify storage pskeep2:main items.left set from entity @s Inventory

# if no items are left after clearing but were before -- drop all
unless data storage pskeep2:main items.left[0] if data storage pskeep2:main items.all[0] function ~/drop_all_recursive:
    data modify storage pskeep2:main drop.item set from storage pskeep2:main items.all[-1]
    function pskeep2:drop/item with storage pskeep2:main drop
    data remove storage pskeep2:main items.all[-1]
    if data storage pskeep2:main items.all[0] function ~/

# go through all items and drop the cleared ones
if data storage pskeep2:main items.all[0] function ~/drop_recursive:
    data modify storage pskeep2:main drop.item set from storage pskeep2:main items.left[-1]
    store result score #is_different pskeep2 data modify storage pskeep2:main drop.item set from storage pskeep2:main items.all[-1]
    if score #is_different pskeep2 matches 1 function pskeep2:drop/item with storage pskeep2:main drop
    data remove storage pskeep2:main items.all[-1]
    if score #is_different pskeep2 matches 0 data remove storage pskeep2:main items.left[-1]
    # if no items are left -- drop all to prevent unforseen behavior
    unless data storage pskeep2:main items.left[0] if data storage pskeep2:main items.all[0] return run function ~/../drop_all_recursive
    if data storage pskeep2:main items.all[0] function ~/

execute function ~/drop_xp:
    #> https://minecraft.wiki/w/Experience#Leveling_up
    # set up variables
    store result score .level pskeep2 store result score .xp pskeep2 store result score #level_squared pskeep2 xp query @s levels
    store result score .points pskeep2 xp query @s points
    scoreboard players operation #level_squared pskeep2 *= #level_squared pskeep2
    # calculate level² coefficient
    if score .level pskeep2 matches 17..31 scoreboard players operation #level_squared pskeep2 *= #5 pskeep2
    if score .level pskeep2 matches 32.. scoreboard players operation #level_squared pskeep2 *= #9 pskeep2
    # calculate level coefficient
    if score .level pskeep2 matches 1..16 scoreboard players operation .xp pskeep2 *= #6 pskeep2
    if score .level pskeep2 matches 17..31 scoreboard players operation .xp pskeep2 *= #-81 pskeep2
    if score .level pskeep2 matches 32.. scoreboard players operation .xp pskeep2 *= #-325 pskeep2
    # divide to correct for .5 values
    if score .level pskeep2 matches 17.. scoreboard players operation #level_squared pskeep2 /= #2 pskeep2
    if score .level pskeep2 matches 17.. scoreboard players operation .xp pskeep2 /= #2 pskeep2
    # add flat values
    if score .level pskeep2 matches 17..31 scoreboard players add .xp pskeep2 360
    if score .level pskeep2 matches 32.. scoreboard players add .xp pskeep2 2220
    # add everything up
    scoreboard players operation .xp pskeep2 += #level_squared pskeep2
    store result storage pskeep2:main drop.xp int 1 scoreboard players operation .xp pskeep2 += .points pskeep2
    # drop xp orb
    function pskeep2:drop/xp with storage pskeep2:main drop
    # reset player xp
    xp set @s 0 levels
    xp set @s 0 points
