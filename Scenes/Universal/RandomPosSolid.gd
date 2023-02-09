extends StaticBody

export var random_offset := Vector3(12.0, 0.0, 0.0)
export var scale_range := Vector2(5.0, 9.0)


func _ready() -> void:
	translation += Vector3(rand_range(random_offset.x, -random_offset.x), \
						   rand_range(random_offset.y, -random_offset.y), \
						   rand_range(random_offset.z, -random_offset.z))
	rotation_degrees.y = randf() * TAU
	scale = Vector3.ONE * rand_range(scale_range.x, scale_range.y)
