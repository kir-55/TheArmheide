extends Menu


var current_villager: Villager

var village_control: Node
@export var villager_list: ItemList
@export var villager_info_text: RichTextLabel

@export var job_option_panel: OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	village_control = get_node("/root/Game/VillageControl")
	load_villager_data()
	for job_name in Enums.Job.keys():
		job_option_panel.add_item(job_name)



func load_villager_data():
	for villager in village_control.villagers:
		villager_list.add_item(villager.name)




func _on_item_list_item_selected(index):
	current_villager = village_control.villagers[index]
	villager_info_text.clear()
	villager_info_text.append_text("[center][b][color=EFFFC8]" + current_villager.name + "[/color][/b][/center]\n\n")
	villager_info_text.append_text("Age: " + str(current_villager.age) + "\n")
	villager_info_text.append_text("Job: " + Enums.Job.keys()[current_villager.job] + "\n")
	job_option_panel.visible = true
	job_option_panel.selected = current_villager.job


func _on_button_pressed():
	if village_control.set_villager_job(current_villager, job_option_panel.selected) != false:
		villager_list.clear()
		load_villager_data()
	else:
		villager_info_text.append_text("[b][color=FF0000]Failed to set job![/color][/b]\n")
	
