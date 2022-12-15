extends Spatial

const SCYTHE := preload("res://Scenes/Projectiles/Phase4_Atk1.tscn")

export var enabled := false setget set_get_enabled
export var spawn_freq := 0.3
export var spawn_after_steps := 2
export var pillar_length := 6.3
export var center_offset := 3
export var spawn_heights := [0.5, 7.0]

var is_ready := false
var step_counter := 0
onready var scythes: Position3D = $Scythes
onready var step_timer: Timer = $Step


func _ready() -> void:
	is_ready = true


func set_get_enabled(value: bool) -> void:
	enabled = value
	if not is_ready:
		return
	if enabled:
		step_timer.start(spawn_freq)
	else:
		step_timer.stop()
		shrink_scythes()


func spawn_scythe_random() -> void:
	var starting_edge := round(rand_range(1.0, 2.0))
	var angle := (PI/2)*starting_edge
	var rand_offset := round(rand_range(-2.49, 2.49)) * pillar_length
	var y_pos : float = spawn_heights[randi() % spawn_heights.size()]
	var starting_pos := Vector3(pillar_length*center_offset, y_pos, rand_offset).rotated(Vector3.UP, angle)
	
	var scythe_inst := SCYTHE.instance()
	scythe_inst.translation = starting_pos
	scythe_inst.move_dir = Vector3.RIGHT.rotated(Vector3.UP, angle + PI)
	scythes.add_child(scythe_inst)


func shrink_scythes() -> void:
	for scythe in scythes.get_children():
		scythe.shrink()


func _on_Step_timeout() -> void:
	spawn_scythe_random()
