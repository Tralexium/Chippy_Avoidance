extends Node


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Globals.can_pause = false
	Config.load_data()


func _on_ParticlePreloader_all_loaded() -> void:
	VisualServer.set_default_clear_color(Color.black)
	get_tree().change_scene_to(Globals.MAIN_MENU)
