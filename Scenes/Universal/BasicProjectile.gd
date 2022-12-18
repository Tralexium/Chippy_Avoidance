extends Spatial

export var disabled := false setget set_disabled

var is_ready := false
onready var collision_shape: CollisionShape = $Hitbox/CollisionShape


func _ready() -> void:
	is_ready = true
	set_disabled(disabled)


func set_disabled(value: bool) -> void:
	disabled = value
	if !is_ready:
		return
	collision_shape.disabled = disabled
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	if disabled:
		tween.tween_property(self, "scale", Vector3.ONE * 0.3, 0.5)
	else:
		tween.tween_property(self, "scale", Vector3.ONE, 0.5)
