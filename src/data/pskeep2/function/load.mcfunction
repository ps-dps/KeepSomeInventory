
append function_tag minecraft:load { "values": [ "pskeep2:load" ]}

scoreboard objectives add pskeep2 dummy

store result score #keep_inventory pskeep2 gamerule keepInventory
if score #keep_inventory pskeep2 matches 0 tellraw @a {
    "translate":"pskeep2.error.keep_inventory_off",
    "fallback":"Gamerule \"keepInventory\" was set to \"true\" for \"KeepSomeInventory\" to work!",
    "color":"red",
}
gamerule keepInventory true
