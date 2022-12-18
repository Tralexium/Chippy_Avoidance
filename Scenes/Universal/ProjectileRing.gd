extends Spatial

export(PackedScene) var projectile: PackedScene
export var projectile_count := 2
export var radius := 6.0
export var ring_segments := 1
export var ring_padding := 3.0
export var y_rotation_spd := 3.0
export var velocity := Vector3.ZERO

var ring_array := []


func _ready() -> void:
	$Icon.hide()
	scale = Vector3.ZERO
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector3.ONE, 0.5)
	_create_projectiles()


func _create_projectiles() -> void:
	var inst_offset = TAU / projectile_count
	var ring_pos = 0.0
	var padding := 0.0
	var inst_array := []
	for ring in range(ring_segments):
		for i in range(projectile_count):
			var projectile_inst := projectile.instance()
			inst_array.push_back(projectile_inst)
			projectile_inst.translation = Vector3(radius+padding, 0.0, 0.0).rotated(Vector3.UP, ring_pos)
			ring_pos += inst_offset
			add_child(projectile_inst)
		padding += ring_padding
		ring_pos = 0.0
		ring_array.push_back(inst_array)
		inst_array.clear()


func _process(delta: float) -> void:
	# Update the position
	translation += velocity * delta
	# Update the Y rotation
	# Sidenote: Ideally you should point to a 3D position and rotate
	# the basis towards it. The following is a half-assed solution!
	if rotation_degrees.z >= 90.0:
		rotation.x += y_rotation_spd * delta
	else:
		rotation.y += y_rotation_spd * delta
	# Update the ring padding & radius
	var inst_offset = TAU / projectile_count
	var padding := 0.0
	for ring in ring_array:
		for projectile in ring:
			projectile.translation = Vector3(radius+padding, 0.0, 0.0).rotated(Vector3.UP, inst_offset)
		padding += ring_padding
	# Despawn if no instances are left
	if get_child_count() == 0:
		queue_free()


func smooth_rotate(target_angle: float, ease_type: int, trans_type: int, duration: float) -> void:
	y_rotation_spd = 0.0
	var tween = create_tween().set_ease(ease_type).set_trans(trans_type)
	tween.tween_property(self, "rotation:y", target_angle, duration)


func toggle_hitbox(value: bool) -> void:
	if !ring_array[0][0].has_variable("disabled"):
		return
	for ring in ring_array:
		for projectile in ring:
			projectile.disabled = value


func shrink() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.5)
	tween.tween_callback(self, "queue_free").set_delay(0.5)
