extends AnimationTree

var previous_run_strength := 0.0
var run_strength_lerp_spd := 50.0


func set_run_strength(input_strength: float) -> void:
	var delta := get_process_delta_time()
	var strength : float = lerp(previous_run_strength, input_strength, run_strength_lerp_spd*delta)
	previous_run_strength = input_strength
	set("parameters/run_blend/blend_amount", strength)


func set_vertical_velocity(y_velocity: float, jump_force: float) -> void:
	var unit_value := clamp(y_velocity / jump_force, 0.0, 1.0)
	set("parameters/air_blend/blend_amount", unit_value)


func set_airborne_state(is_on_floor: bool) -> void:
	var state := int(!is_on_floor)
	set("parameters/in_air_state/current", state)


func flip_jump() -> void:
	set("parameters/flip_jump_one_shot/active", true)
