extends Node

signal all_loaded


func _on_Timer_timeout() -> void:
	emit_signal("all_loaded")
	queue_free()
