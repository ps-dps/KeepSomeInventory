from requests import get
import json
import os

base_url = "https://raw.githubusercontent.com/FabricMC/fabric/1.21/fabric-convention-tags-v2/src/generated/resources/data/c/tags/item/{}.json"
tags = [
    'raw_materials',
    'stones',
    'raw_blocks',
    'ores',
    'nuggets',
    'leathers',
    'strings',
    'ingots',
    'gems',
    'glass_blocks',
    'glass_panes',
    'glazed_terracottas',
    'dyes',
    'dusts',
    'concretes',
    'concrete_powders',
    'cobblestones',
    'coal',
    'clusters',
    'chests',
    'chains',
    'buds',
    'budding_blocks',
    'bricks',
    'bookshelves',
    'barrels',
    'storage_blocks',
]

cache = {}
all_items = []

def get_tag(tag: str) -> tuple[dict, bool]:
    if tag in cache:
        return (cache[tag], True)
    print(f'GET {tag}')
    result = get(base_url.format(tag))
    if result.status_code != 200:
        print(f'failed to get {tag}')
        print(result.status_code)
        print(result.text)
        return (None, True)
    cache[tag] = result.json()
    return (result.json(), False)

def get_c_subtags(json_tag: dict) -> list[str]:
    out = []
    for v in json_tag.get('values', []):
        print(v)
        if type(v) == str:
            vid = v
        else:
            vid = v['id']
        if vid.startswith('minecraft:') or vid.startswith('#minecraft:'): all_items.append(vid)

        if vid.split(':')[0] == '#c':
            out.append(vid[3:])
    return out

def create_full_tag(str_tag: str) -> list[tuple[str, dict]]:
    json_tag, already_exists = get_tag(str_tag)
    if already_exists:
        return []

    return [(str_tag, json_tag)] + [t for s in get_c_subtags(json_tag) for t in create_full_tag(s)]

os.makedirs('./src/data/c/tags/item', exist_ok=True)
os.makedirs('./src/data/pskeep2/tags/item', exist_ok=True)

for tag in tags:
    for str_tag, json_tag in create_full_tag(tag):
        folder_path = f'./src/data/c/tags/item/{"/".join(str_tag.split("/")[:-1])}'
        os.makedirs(folder_path, exist_ok=True)
        with open(f'./src/data/c/tags/item/{str_tag}.json', 'w') as f:
            f.write(json.dumps(json_tag))

with open('./src/data/pskeep2/tags/item/drop.json', 'w') as f:
    f.write(json.dumps({ "values": [{ "id": f'#c:{id}', "required": False } for id in tags]}))

with open('./dump.txt', 'w') as f:
    f.write('\n'.join(all_items))
