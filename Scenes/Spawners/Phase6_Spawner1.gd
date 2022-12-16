extends Spatial

const RING_SPAWNER := preload("res://Scenes/ShockwaveSpawner.tscn")

export var enabled := false setget set_enabled
export var amount := 6
export var radius := 30.0

var is_ready := false


func _ready() -> void:
	is_ready = true


func set_enabled(value: bool) -> void:
	enabled = value
	if not is_ready:
		return
	if enabled:
		spawn_projectiles()
	else:
		destroy_projectiles()


func spawn_projectiles() -> void:
	var angle := 0.0
	for i in range(amount):
		var spawner_inst := RING_SPAWNER.instance()
		var offset := Vector3(radius, 0.0, 0.0).rotated(Vector3.UP, angle)
		spawner_inst.translate(offset)
		add_child(spawner_inst)
		angle += TAU / amount


func destroy_projectiles() -> void:
	for spawner in get_children():
		spawner.queue_free()


func shoot_random() -> void:
	var rand_num := randi() % get_child_count() 
	get_child(rand_num).smash()


func shoot_specific(child_number: int) -> void:
	child_number = round(clamp(child_number, 0, get_child_count() - 1))
	get_child(child_number).smash()
