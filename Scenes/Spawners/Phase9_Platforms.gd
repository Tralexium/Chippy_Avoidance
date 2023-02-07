extends Spatial

const PLATFORM := preload("res://Scenes/Universal/RandomPosSolid.tscn")

export var vertical_speed := 0
export var platforms := 15
export var seperation := Vector2(20.0, 5.0)


func spawn() -> void:
	if get_child_count() > 0:
		return
	for i in range(platforms):
		var plat_inst := PLATFORM.instance()
		plat_inst.translation.y = -seperation.y * i
		plat_inst.random_pos_radius = Vector3(seperation.x if i > 0 else 0.0, 2.0, 0.0)
		if i == 0:
			plat_inst.scale_range = Vector2(10.0, 10.0)
		add_child(plat_inst)


func despawn() -> void:
	for platform in get_children():
		platform.queue_free()


func _process(delta: float) -> void:
	global_translation.y += vertical_speed * delta
