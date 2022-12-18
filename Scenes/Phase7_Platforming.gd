extends Spatial

var HAZARDS := preload("res://Scenes/Phase7_Platforming_Hazards.tscn")


func spawn_hazards() -> void:
	add_child(HAZARDS.instance())


func remove_hazards() -> void:
	if has_node("Platforming_Hazards"):
		get_node("Platforming_Hazards").queue_free()
