extends Node

const AVOIDANCE := preload("res://Scenes/Avoidance.tscn")


func _ready() -> void:
	Config.load_data()
