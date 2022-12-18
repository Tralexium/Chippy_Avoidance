extends Spatial

const SPINNER := preload("res://Scenes/Universal/ProjectileRing.tscn")

export(PackedScene) var projectile: PackedScene
export var spinners := 1 setget set_spinners
export var projectiles_per_ring := 2
export var ring_segments := 5
export var projectile_padding := 2.0


var is_ready := false


func _ready() -> void:
	is_ready = true
	set_spinners(spinners)


func set_spinners(value: int) -> void:
	spinners = value
	if !is_ready:
		return
	var child_count := $Inner.get_child_count()
	if child_count < spinners:
		_add_spinner()
	elif child_count > spinners:
		_remove_spinner()


func _add_spinner() -> void:
	if $Inner.get_child_count() == 0:
		# Inner
		var inner_spinner_inst := SPINNER.instance()
		inner_spinner_inst.projectile = projectile
		inner_spinner_inst.projectile_count = projectiles_per_ring
		inner_spinner_inst.radius = 0.0
		inner_spinner_inst.ring_segments = ring_segments
		inner_spinner_inst.ring_padding = projectile_padding
		inner_spinner_inst.y_rotation_spd = 0.0
		$Inner.add_child(inner_spinner_inst)
		# Outer
		var outer_spinner_inst := inner_spinner_inst.duplicate()
		outer_spinner_inst.radius = ring_segments * projectile_padding
		outer_spinner_inst.y_rotation_spd = 0.0
		$Outer.add_child(inner_spinner_inst)
	else:
		# Inner
		var last_child := $Inner.get_child_count() - 1
		var inner_spinner_inst := $Inner.get_child(last_child).duplicate()
		inner_spinner_inst.translation.y += projectile_padding
		$Inner.add_child(inner_spinner_inst)
		# Outer
		var outer_spinner_inst := $Outer.get_child(last_child).duplicate()
		outer_spinner_inst.translation.y += projectile_padding
		$Outer.add_child(outer_spinner_inst)


func _remove_spinner() -> void:
	if $Inner.get_child_count() > 0:
		var last_child := $Inner.get_child_count() - 1
		$Inner.get_child(last_child).queue_free()
		$Outer.get_child(last_child).queue_free()


func smooth_rotate_halfs(target_angle: float, ease_type: int, duration: float, reverse_halfs) -> void:
	if !is_ready:
		return
	for ring in $Inner.get_children():
		ring.smooth_rotate(target_angle, ease_type, Tween.TRANS_CUBIC, duration)
	for ring in $Outer.get_children():
		var _outer_target := -target_angle if reverse_halfs else target_angle
		ring.smooth_rotate(_outer_target, ease_type, Tween.TRANS_CUBIC, duration)


func toggle_hitbox(value: bool) -> void:
	for spinner in $Inner.get_children():
		spinner.toggle_hitbox(value)
	for spinner in $Outer.get_children():
		spinner.toggle_hitbox(value)
