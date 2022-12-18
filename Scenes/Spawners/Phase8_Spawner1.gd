extends Spatial

const SPINNER := preload("res://Scenes/Universal/ProjectileRing.tscn")

export(PackedScene) var projectile: PackedScene
export var spinners := 0 setget set_spinners
export var projectiles_per_ring := 2
export var ring_segments := 5
export var projectile_padding := 2.0
export var hitboxes_on := false setget set_hitboxes_on

var is_ready := false
var vertical_padding := 0.0


func _ready() -> void:
	is_ready = true


func set_spinners(value: int) -> void:
	spinners = value
	if !is_ready:
		return
	var child_count := $Inner.get_child_count()
	if child_count < spinners:
		for i in range(spinners - child_count):
			_add_spinner()
	elif child_count > spinners and spinners >= 0:
		for i in range(child_count - spinners):
			_remove_spinner()


func _instance_new_spinner() -> Node:
	var spinner_inst := SPINNER.instance()
	spinner_inst.projectile = projectile
	spinner_inst.projectile_count = projectiles_per_ring
	spinner_inst.radius = 0.0
	spinner_inst.ring_segments = ring_segments
	spinner_inst.ring_padding = projectile_padding
	spinner_inst.y_rotation_spd = 0.0
	return spinner_inst


func _add_spinner() -> void:
	# Inner
	var inner_spinner_inst = _instance_new_spinner()
	inner_spinner_inst.translation.y += vertical_padding
	inner_spinner_inst.hitboxes_on = hitboxes_on
	if $Inner.get_child_count() > 0:
		inner_spinner_inst.rotation.y = $Inner.get_child(0).rotation.y
	$Inner.add_child(inner_spinner_inst)
	# Outer
	var outer_spinner_inst := _instance_new_spinner()
	outer_spinner_inst.radius = ring_segments * projectile_padding
	outer_spinner_inst.translation.y += vertical_padding
	outer_spinner_inst.hitboxes_on = hitboxes_on
	if $Outer.get_child_count() > 0:
		outer_spinner_inst.rotation.y = $Outer.get_child(0).rotation.y
	$Outer.add_child(outer_spinner_inst)
	
	vertical_padding += projectile_padding


func _remove_spinner() -> void:
	if $Inner.get_child_count() > 0:
		var last_child := $Inner.get_child_count() - 1
		$Inner.get_child(last_child).queue_free()
		$Outer.get_child(last_child).queue_free()


func smooth_rotate_halfs(target_angle: float, trans_type: int, duration: float, reverse_halfs: bool) -> void:
	if !is_ready:
		return
	for spinner in $Inner.get_children():
		spinner.smooth_rotate(target_angle, Tween.EASE_OUT, trans_type, duration)
	for spinner in $Outer.get_children():
		var _outer_target := -target_angle if reverse_halfs else target_angle
		spinner.smooth_rotate(_outer_target, Tween.EASE_OUT, trans_type, duration)


func set_hitboxes_on(value: bool) -> void:
	hitboxes_on = value
	if !is_ready:
		return
	for spinner in $Inner.get_children():
		spinner.hitboxes_on = value
	for spinner in $Outer.get_children():
		spinner.hitboxes_on = value


func shrink_all() -> void:
	for spinner in $Inner.get_children():
		spinner.shrink()
	for spinner in $Outer.get_children():
		spinner.shrink()
