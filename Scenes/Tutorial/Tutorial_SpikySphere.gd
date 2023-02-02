# This script is a modified version of 'BasicProjectile.gd'
extends Spatial

const HAZARD_MAT := preload("res://Resources/Materials/hazard_mat.tres")
const NONHAZARD_MAT := preload("res://Resources/Materials/nonhazard_mat.tres")

export var disabled := false setget set_disabled
export var appear_animation := true
export var target_scale := Vector3(3.0, 3.0, 3.0)
export var rotation_spd := Vector3(0.0, -8.0, 0.0)
export var mesh : Mesh = null

var is_ready := false
onready var collision_shape: CollisionShape = $Hitbox/CollisionShape
onready var mesh_instance: MeshInstance = $MeshInstance


func _ready() -> void:
	is_ready = true
	set_disabled(disabled)
	if mesh != null:
		mesh_instance.mesh = mesh
	if appear_animation:
		scale = Vector3.ZERO
		var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(self, "scale", target_scale, 0.5)
	else:
		scale = target_scale


func _process(delta: float) -> void:
	rotation += rotation_spd * delta


func set_disabled(value: bool) -> void:
	disabled = value
	if !is_ready:
		return
	collision_shape.disabled = disabled
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	if disabled:
		mesh_instance.material_override = NONHAZARD_MAT
		tween.tween_property(mesh_instance, "scale", Vector3.ONE * 0.3, 0.5)
	else:
		mesh_instance.material_override = HAZARD_MAT
		tween.tween_property(mesh_instance, "scale", Vector3.ONE, 0.5)


func shrink() -> void:
	collision_shape.disabled = true
	var tween := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.5)
	tween.tween_callback(self, "queue_free").set_delay(0.5)
