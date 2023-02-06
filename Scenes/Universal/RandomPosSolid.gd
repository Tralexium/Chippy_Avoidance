extends StaticBody

export var random_pos_radius := Vector3(12.0, 0.0, 0.0)


func _ready() -> void:
	translation += Vector3(randf() * random_pos_radius.x, randf() * random_pos_radius.y, randf() * random_pos_radius.z)
	rotation_degrees.y = randf() * TAU
	scale = Vector3.ONE * rand_range(5.0, 8.5)
