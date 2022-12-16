extends Spatial

export var move_rad := 40.0
export var rotate_spd := -360.0
onready var mesh_instance: MeshInstance = $MeshInstance


func _process(delta: float) -> void:
	mesh_instance.rotation_degrees.y += rotate_spd * delta


func move_to_rand_pos() -> void:
	var chosen_pos := Vector3(randf() * move_rad, translation.y, translation.z).rotated(Vector3.UP, randf() * TAU)
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "translation", chosen_pos, 0.5)
