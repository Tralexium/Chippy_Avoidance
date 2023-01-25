extends CanvasLayer

onready var debug: MarginContainer = $DEBUG


func show_debug() -> void:
	debug.show()


func hide_debug() -> void:
	debug.hide()
