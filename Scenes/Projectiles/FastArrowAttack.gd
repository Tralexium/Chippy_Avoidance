extends KinematicBody

export var travel_spd := 200.0
export var rotation_spd := 10.0
export var travel_dist := 50.0
export var look_at_pos := Vector3.ZERO

var velocity := Vector3.ZERO
var distance_traveled := 0.0
var is_shrinking := false


func _ready() -> void:
	if look_at_pos.length() > 0.0:
		look_at(look_at_pos, Vector3.UP)


func _physics_process(delta: float) -> void:
	if velocity.length() > 0.0 and !is_shrinking:
		velocity = move_and_slide(velocity)
		distance_traveled += velocity.length()
		rotation.z += rotation_spd * delta
		if distance_traveled >= travel_dist:
			shrink()


func shrink() -> void:
	if is_shrinking:
		return
	is_shrinking = true
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(self, "scale", Vector3.ZERO, 0.5)
	tween.tween_callback(self, "queue_free").set_delay(0.5)


func _on_WarningBeam_finished() -> void:
	velocity = (Vector3.ONE * travel_spd) * rotation.normalized()
