extends StaticBody

export var random_pos_radius := Vector3(12.0, 0.0, 0.0)


func _ready() -> void:
	translation += Vector3(randf() * random_pos_radius.x - random_pos_radius.x/2, \
						   randf() * random_pos_radius.y - random_pos_radius.y/2, \
						   randf() * random_pos_radius.z - random_pos_radius.z/2)
	rotation_degrees.y = randf() * TAU
	scale = Vector3.ONE * rand_range(5.0, 9.0)
