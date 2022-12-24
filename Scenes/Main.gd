extends Node


func _ready() -> void:
	VisualServer.set_default_clear_color(Color.black)
	Globals.start_main_menu()
