import requests
import json
import os

should_drop_if_includes = ["compass", "clock", "_sword", "_axe", "_pickaxe", "_hoe", "_shovel", "trident", "bow", "shield",
    "shears", "flint_and_steel", "_on_a_stick", "spyglass", "fishing_rod", "written_book", "writable_book",
    "bucket", "firework_rocket", "arrow", "map", "_boat", "_raft", "minecart", "saddle", "_horse_armor", "golden_apple",
    "totem_of_undying", "potion", "goat_horn", "ender_eye", "ender_pearl", "torch", "_helmet", "_chestplate",
    "_leggings", "_boots", "elytra", "carved_pumpkin", "skeleton_skull", "head", "mace", "wolf_armor"]

blocked_common_tags = ["#c:hidden_from_recipe_viewers", "#c:dyed/black", "#c:dyed/blue", "#c:dyed/brown", "#c:dyed/cyan", "#c:dyed/gray",
    "#c:dyed/green", "#c:dyed/light_blue", "#c:dyed/light_gray", "#c:dyed/lime", "#c:dyed/magenta", "#c:dyed/orange", "#c:dyed/pink",
    "#c:dyed/purple", "#c:dyed/red", "#c:dyed/white", "#c:dyed/yellow"]

blocked_vanilla_tags = ["#minecraft:beacon_payment_items", "#minecraft:camel_food", "#minecraft:cat_food", "#minecraft:cod_food",
    "#minecraft:fox_food", "#minecraft:frog_food", "#minecraft:goat_food", "#minecraft:hoglin_food", "#minecraft:ignored_by_piglin_babies",
    "#minecraft:llama_food", "#minecraft:llama_tempt_items", "#minecraft:ocelot_food", "#minecraft:panda_food", "#minecraft:parrot_poisonous_food",
    "#minecraft:pig_food", "#minecraft:piglin_food", "#minecraft:rabbit_food", "#minecraft:sheep_food", "#minecraft:strider_food",
    "#minecraft:trim_materials", "#minecraft:turtle_food"]

all_items_url = "https://raw.githubusercontent.com/misode/mcmeta/registries/item/data.min.json"

res = requests.get(all_items_url)
all_items: list[str] = res.json()

filtered_items = [f'minecraft:{i}' for i in all_items if not any([s in i for s in should_drop_if_includes])]

all_vanilla_tags_url = "https://raw.githubusercontent.com/misode/mcmeta/summary/data/tag/item/data.min.json"

res = requests.get(all_vanilla_tags_url)
all_vanilla_tags: dict[str, dict[str, list[str]]] = res.json()

fully_included_vanilla_tags = []
remaining_items = filtered_items.copy()

for tag_name, tag_content in all_vanilla_tags.items():
    values = tag_content["values"]
    if all([i in filtered_items for i in values]):
        full_tag_name = f'#minecraft:{tag_name}'
        if full_tag_name in blocked_vanilla_tags:
            continue
        fully_included_vanilla_tags.append(full_tag_name)
        remaining_items = [i for i in remaining_items if i not in values]

common_tags_dir = "./common_tags/c"
fully_included_common_tags = []

for root, dirs, files in os.walk(common_tags_dir):
    for tag_name in files:
        with open(os.path.join(root, tag_name), "r") as f:
            tag_content = json.load(f)

            values = tag_content["values"]
            if isinstance(values, dict):
                values = {v['id'] for v in values}

            if all([i in filtered_items for i in values]):
                subfolder = root.removeprefix(common_tags_dir)
                if subfolder:
                    subfolder = subfolder[1:] + "/"
                full_tag_name = f'#c:{subfolder}{tag_name.removesuffix(".json")}'
                if full_tag_name in blocked_common_tags:
                    continue
                fully_included_common_tags.append(full_tag_name)

remaining_items.sort()
fully_included_vanilla_tags.sort()
fully_included_common_tags.sort()

with open('./src/data/pskeep2/tags/item/drop.json', 'w') as f:
    json.dump({ "values": [{ "id": id, "required": False } for id in remaining_items + fully_included_vanilla_tags + fully_included_common_tags]}, f)
