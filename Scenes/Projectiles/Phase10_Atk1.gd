extends Spatial

const HAZARD_MAT := preload("res://Resources/Materials/hazard_mat.tres")
const NONHAZARD_MAT := preload("res://Resources/Materials/nonhazard_mat.tres")

export var spin_spd := 10.0
export var spin_dir := 1.0
export var shrink_amnt := 0.7
export var disabled := false setget set_disabled

var is_ready := false
var tween : SceneTreeTween
onready var hitbox: Area = $Hitbox
onready var collision_shape: CollisionShape = $Hitbox/CollisionShape
onready var mesh_instance: MeshInstance = $Hitbox/MeshInstance


func _ready() -> void:
	is_ready = true
	set_disabled(disabled)
	hitbox.translation.y = -200.0
	tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(hitbox, "translation:y", 0.0, 0.4)


func _process(delta: float) -> void:
	rotation.y += (spin_spd * spin_dir) * delta
	hitbox.scale.x -= shrink_amnt * delta
	hitbox.scale.z -= shrink_amnt * delta
	if hitbox.scale.x <= 0.0:
		queue_free()


func set_disabled(value: bool) -> void:
	disabled = value
	if !is_ready:
		return
	collision_shape.disabled = disabled
	if disabled:
		mesh_instance.material_override = NONHAZARD_MAT
	else:
		mesh_instance.material_override = HAZARD_MAT
