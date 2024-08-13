class_name Villager
extends Node

@export var unique_name: String
var age: int


# basic ... speed - means that the speed would be "multiplyed" by age
@export_category("Personal values")
@export var basic_walk_speed: float
@export var basic_follow_speed: float
@export var basic_escape_speed: float
@export_range(5, 50) var basic_damage: int
@export_range(0.0, 1.0) var knowledge: float
@export_range(0.0, 1.0) var urgency: float
