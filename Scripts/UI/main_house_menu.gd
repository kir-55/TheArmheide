extends Menu


var village_control: Node
@export var villager_list: ItemList



# Called when the node enters the scene tree for the first time.
func _ready():
	village_control = get_node("/root/Game/VillageControl")
	load_villager_data()

func _on_tab_container_tab_changed(tab):
	if tab == 0:
		load_villager_data()


func load_villager_data():
	for villager in village_control.villagers:
		villager_list.add_item(villager.name)
