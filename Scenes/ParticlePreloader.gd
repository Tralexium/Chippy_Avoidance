extends Node

signal all_loaded
onready var particles: Node = $Particles
onready var particles_2d: CanvasLayer = $"Particles/2D"


func _ready() -> void:
	for part in particles.get_children():
		if part is Particles:
			part.emitting = true
	for part in particles_2d.get_children():
		if part is Particles2D:
			part.emitting = true


func _on_Timer_timeout() -> void:
	emit_signal("all_loaded")
	queue_free()
