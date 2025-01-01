# <img src="src/pack.png" height=25> Keep Some Inventory

**Isn't it annoying when you die and your items are far away and surrounded by danger?**

With this data pack no longer, since you **keep your fighting equipment** like weapons, tools and armor **on you when dying**!

## Overview
**Personally I don't like** playing with the `keepInventory` gamerule set to `true` because it feels cheap to go somewhere dangerous **without the risk** of losing anything.
This data pack aims to give dangerous areas their **risk back** while still allowing you to **use your best equipment** that you spent hours on farming, crafting and enchanting.

## Features
- When dying, you **keep all your equipment** on you while still **dropping your resources**.
- Your items **will not splatter**, they all stay at the exact location you died at, **no items flying into lava or off of cliffs**.
- At the location of your death you can collect **all your experience** and it is **not limited** to about 7 levels, like in vanilla minecraft.
- After dying, your **items and experience will despawn after 10 minutes** instead of despawning after the normal 5 minutes.

## Compatability
- This pack will most likely **not work** together with grave packs or packs doing anything to items on death.
- This pack makes use of **vanilla item tags** and the **convention of common `c` tags** used by mod loaders, and may therefore be compatible with mods - no guarantee.
- You can **modify the items that should be dropped** on death by opening the zip/jar and modifying the tag located at `data/pskeep2/tags/item/drop.json`.

## CraftBukkit Servers (Spigot, Paper, Purpur, etc.)
This datapack works with CraftBukkit, provided you set `/gamerule keepInventory true` in each world, because CraftBukkit has separate gamerules for each world (the Nether and the End are considered separate worlds).
Not setting the keepInventory rule to true that world or dimension will cause the default Minecraft death and drop item behaviour.

---
[![PuckiSilver on GitHub](https://raw.githubusercontent.com/PuckiSilver/static-files/main/link_logos/GitHub.png)](https://github.com/PuckiSilver)[![PuckiSilver on modrinth](https://raw.githubusercontent.com/PuckiSilver/static-files/main/link_logos/modrinth.png)](https://modrinth.com/user/PuckiSilver)[![PuckiSilver on PlanetMinecraft](https://raw.githubusercontent.com/PuckiSilver/static-files/main/link_logos/PlanetMinecraft.png)](https://planetminecraft.com/m/PuckiSilver)[![PuckiSilver on PayPal](https://raw.githubusercontent.com/PuckiSilver/static-files/main/link_logos/PayPal.png)](https://paypal.me/puckisilver)
