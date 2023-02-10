extends Spatial

const SPIKE_WALL := preload("res://Scenes/Tutorial/Tutorial_Spike_Wall.tscn")


func spawn_wall(pos: Vector3, speed: Vector3, phase: int) -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	var y_angle := Vector3(1, 0, 0).angle_to(speed)
	var spike_wall_inst := SPIKE_WALL.instance()
	spike_wall_inst.rotation.y = y_angle
	spike_wall_inst.speed = speed.abs()
	spike_wall_inst.translation = pos
	spike_wall_inst.phase = phase
	add_child(spike_wall_inst)
