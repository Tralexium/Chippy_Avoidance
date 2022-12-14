extends Spatial

export var steps := 5
export var step_dist := 6.3
export var step_dur := 0.25
export var jump_height := 3.0

var step_counter := 0
var has_stepped_back := false
onready var hazard: Area = $Hazard


func _ready() -> void:
	hazard.scale = Vector3.ZERO
	var tween := create_tween().set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC).tween_property(hazard, "scale", Vector3.ONE, 0.5)


func step(backwards: bool = false) -> void:
	has_stepped_back = backwards
	var move_offset := step_dist if backwards else -step_dist
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(hazard, "rotation_degrees:z", hazard.rotation_degrees.z - 90.0*sign(move_offset), step_dur)
	tween.tween_property(hazard, "translation:x", hazard.translation.x + move_offset, step_dur)
	yield(tween, "finished")
	step_counter += 1
	if step_counter >= steps:
		shrink()


func jump() -> void:
	has_stepped_back = false
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(hazard, "translation:y", hazard.translation.y + jump_height, step_dur)


func shrink() -> void:
	if has_stepped_back:
		return
	var tween := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(hazard, "rotation_degrees:y", 360.0, step_dur)
	tween.tween_property(hazard, "scale", Vector3.ZERO, step_dur)
	tween.tween_callback(self, "queue_free").set_delay(step_dur)
