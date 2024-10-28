extends Node

@export var terrain: Node2D
var houses: Array[Node2D]
var towers: Array[Node2D]

@export var villagers_amount = 5
@export var jobs: Array[JobType]

@export var villager_prefab: PackedScene
@export var villagers: Array[Villager]

@export var possible_names: Array[String]


func _ready():
	houses = terrain.generate_houses(villagers_amount/2 + villagers_amount%2)
	towers = terrain.generate_towers()
	
	for i in range(villagers_amount / 2):
		generate_villager(i, Enums.Gender.Male)
		generate_villager(i, Enums.Gender.Female)
	if villagers_amount % 2 == 1:
		generate_villager(villagers_amount/2, Enums.Gender.Male)
	
func generate_villager(family: int, gender: Enums.Gender):
	var villager := Villager.new()
	villager.name = possible_names.pick_random()
	villager.gender = gender
	villager.family = family
	villager.house = houses[family]
	
	
	var villager_instance = villager_prefab.instantiate()
	
	villager_instance.global_position = houses[family].global_position + Vector2(0, -30)
	add_child(villager_instance)
	
	villager.body = villager_instance
	villagers.append(villager)
	villager_instance.villager_data = villager
	
	set_villager_job(villager, Enums.Job.Guard)
	
func set_villager_job(villager: Villager, job: Enums.Job):
	var state_machine = villager.body.get_node("StateMachine")
	var job_instance
	
	
	for job_type in jobs:
		if job_type.type == job:
			job_instance = Node.new()
			job_instance.set_script(job_type.job)
			job_instance.name = "Job"
			
	if !job_instance:
		print("Job does not exist")
		return false
		
	job_instance.villager = villager.body
	job_instance.villager_ai = villager.body
	job_instance.type = job
	
	if job == Enums.Job.Guard:
		if towers[0].occupience < towers[0].max_capacity and towers[1].occupience < towers[1].max_capacity:
			if towers[0].occupience == towers[1].occupience:
				if abs(towers[0].global_position.x - villager.house.global_position.x) < abs(towers[0].global_position.x - villager.house.global_position.x):
					towers[0].occupience += 1
					job_instance.work_place = towers[0]
				else:
					towers[1].occupience += 1
					job_instance.work_place = towers[1]
			elif towers[0].occupience < towers[1].occupience:
					towers[0].occupience += 1
					job_instance.work_place = towers[0]
			else:
				towers[1].occupience += 1
				job_instance.work_place = towers[1]
		elif towers[0].occupience < towers[0].max_capacity:
				towers[0].occupience += 1
				job_instance.work_place = towers[0]
		elif towers[1].occupience < towers[1].max_capacity:
			towers[1].occupience += 1
			job_instance.work_place = towers[1]
		else:
			#unable to give the guard job
			print("failed to give a job")
			return false
		
		
	
	villager.job = job

	for child in state_machine.get_children():
		if child is Job:
			
			if child.type == Enums.Job.Guard:
				child.work_place.occupience -= 1
				print("occupience removed")
			child.name = "blablabla"
			child.queue_free()
	
	state_machine.add_child(job_instance, true)
	villager.body.get_node("StateMachine").load_states()
	return true
