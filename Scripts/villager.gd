class_name Villager
extends Node

@export var body: CharacterBody2D

@export var unique_name: String
var age: int
@export var family: int
@export var job: Enums.Job = Enums.Job.Jobless
@export var gender: Enums.Gender = Enums.Gender.Male
@export var house: Node2D

# basic ... speed - means that the speed would be "multiplied" by age
@export_category("Personal values")
@export var basic_walk_speed: float
@export var basic_follow_speed: float
@export var basic_escape_speed: float
@export_range(5, 50) var basic_damage: int
@export_range(0.0, 1.0) var knowledge: float
@export_range(0.0, 1.0) var urgency: float


@export_category("variables")
@export var exhaustion: float = 0
