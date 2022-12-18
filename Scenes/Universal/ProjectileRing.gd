extends Spatial

export(PackedScene) var projectile: PackedScene
export var projectile_count := 2
export var radius := 6.0
export var ring_segments := 1
export var ring_padding := 3.0
export var y_rotation_spd := 3.0
export var velocity := Vector3.ZERO
export var hitboxes_on := true setget set_hitboxes_on

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
	for ring in range(ring_segments):
		var inst_array := []
		for i in range(projectile_count):
			var projectile_inst := projectile.instance()
			inst_array.push_back(projectile_inst)
			projectile_inst.translation = Vector3(radius+padding, 0.0, 0.0).rotated(Vector3.UP, ring_pos)
			if projectile_inst.get("disabled") != null:
				projectile_inst.disabled = !hitboxes_on
			ring_pos += inst_offset
			add_child(projectile_inst)
		padding += ring_padding
		ring_pos = 0.0
		ring_array.push_back(inst_array)


func _process(delta: float) -> void:
	# Despawn if no instances are left
	if get_child_count() == 0:
		queue_free()
		return
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
#	var inst_offset = TAU / projectile_count
#	var ring_pos = 0.0
#	var padding := 0.0
#	for ring in ring_array:
#		for projectile in ring:
#			if !projectile:
#				continue
#			projectile.translation = Vector3(radius+padding, 0.0, 0.0).rotated(Vector3.UP, ring_pos)
#			ring_pos += inst_offset
#		padding += ring_padding


func smooth_rotate(target_angle: float, ease_type: int, trans_type: int, duration: float) -> void:
	y_rotation_spd = 0.0
	var tween = create_tween().set_ease(ease_type).set_trans(trans_type)
	tween.tween_property(self, "rotation:y", deg2rad(target_angle), duration)


func shrink() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.5)
	tween.tween_callback(self, "queue_free").set_delay(0.5)


func set_hitboxes_on(value: bool) -> void:
	hitboxes_on = value
	if ring_array.empty():
		return
	if ring_array[0][0].get("disabled") == null:
		return
	for ring in ring_array:
		for projectile in ring:
			if !projectile:
				continue
			projectile.disabled = !value
