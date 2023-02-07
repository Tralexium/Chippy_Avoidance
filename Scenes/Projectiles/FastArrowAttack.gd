extends KinematicBody

export var travel_spd := 70.0
export var rotation_spd := 20.0
export var travel_dist := 100.0
export var look_at_pos := Vector3.ZERO setget set_look_at_pos
export var rotation_axis := Vector3(0, 0, 1)
export var is_2d := false

var velocity := Vector3.ZERO
var distance_traveled := 0.0
var is_shrinking := false
var is_ready := false


func _ready() -> void:
	is_ready = true
	set_look_at_pos(look_at_pos)
	if is_2d:
		rotation.z += PI/2.0


func _physics_process(delta: float) -> void:
	if velocity.length() > 0.0 and !is_shrinking:
		var last_pos := translation
		velocity = move_and_slide(velocity)
		distance_traveled += (last_pos - translation).length()
		rotation.z += rotation_spd * delta
		if distance_traveled >= travel_dist:
			shrink()


func set_look_at_pos(value: Vector3) -> void:
	look_at_pos = value
	if is_ready:
		look_at(look_at_pos, Vector3.UP)


func shrink() -> void:
	if is_shrinking:
		return
	is_shrinking = true
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(self, "scale", Vector3.ZERO, 0.5)
	tween.tween_callback(self, "queue_free").set_delay(0.5)


func _on_WarningBeam_finished() -> void:
	velocity = global_translation.direction_to(look_at_pos) * travel_spd
