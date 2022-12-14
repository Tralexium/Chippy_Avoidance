extends Spatial

const CUBE := preload("res://Scenes/Projectiles/Phase3_Atk1.tscn")

export var enabled := false setget set_get_enabled
export var step_freq := 0.3
export var spawn_after_steps := 2
export var step_length := 6.3
export var step_center_offset := 3

var is_ready := false
var step_counter := 0
onready var cubes: Position3D = $Cubes
onready var step_timer: Timer = $Step


func _ready() -> void:
	is_ready = true


func set_get_enabled(value: bool) -> void:
	enabled = value
	if not is_ready:
		return
	if enabled:
		step_timer.start(step_freq)
	else:
		step_timer.stop()


func spawn_cube_random() -> void:
	var starting_edge := randi() % 4
	var angle := (PI/2)*starting_edge
	var rand_offset := round(rand_range(-2.49, 2.49)) * step_length
	var starting_pos := Vector3(step_length*step_center_offset, 0.0, rand_offset).rotated(Vector3.UP, angle)
	
	var cube_inst := CUBE.instance()
	cube_inst.translation = starting_pos
	cube_inst.rotation.y = angle
	cubes.add_child(cube_inst)


func step_cubes() -> void:
	for cube in cubes.get_children():
		cube.step()
	if step_counter % spawn_after_steps == 0:
		spawn_cube_random()
	step_counter += 1


func step_timer_cubes_backwards() -> void:
	for cube in cubes.get_children():
		cube.step(true)


func jump_cubes() -> void:
	for cube in cubes.get_children():
		cube.jump()


func shrink_cubes() -> void:
	for cube in cubes.get_children():
		cube.shrink()


func _on_Step_timeout() -> void:
	step_cubes()
