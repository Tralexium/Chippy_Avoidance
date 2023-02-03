extends ColorRect

export var next_scene : PackedScene


func finished() -> void:
	get_tree().change_scene_to(next_scene)
