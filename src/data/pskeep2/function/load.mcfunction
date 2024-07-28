
append function_tag minecraft:load { "values": [ "pskeep2:load" ]}

scoreboard objectives add pskeep2 dummy

store result score #keep_inventory pskeep2 gamerule keepInventory
if score #keep_inventory pskeep2 matches 0 tellraw @a {
    "translate":"pskeep2.error.keep_inventory_off",
    "fallback":"Gamerule \"keepInventory\" was set to \"true\" for \"KeepSomeInventory\" to work!",
    "color":"red",
}
gamerule keepInventory true

scoreboard players set #2 pskeep2 2
scoreboard players set #5 pskeep2 5
scoreboard players set #6 pskeep2 6
scoreboard players set #9 pskeep2 9
scoreboard players set #-81 pskeep2 -81
scoreboard players set #-325 pskeep2 -325
