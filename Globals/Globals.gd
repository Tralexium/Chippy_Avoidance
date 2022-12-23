extends Node

var debug_mode := true


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quick restart"):
		get_tree().change_scene("res://Scenes/Avoidance.tscn")
