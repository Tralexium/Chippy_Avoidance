extends Node


func _on_ParticlePreloader_all_loaded() -> void:
	VisualServer.set_default_clear_color(Color.black)
	get_tree().change_scene_to(Globals.MAIN_MENU)
