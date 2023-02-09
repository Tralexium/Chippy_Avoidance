extends Spatial

const ARROW := preload("res://Scenes/Projectiles/FastArrowAttack.tscn")

export var spawning := false
export var center_offset := 25.0
export var spawn_dur := 0.6

var is_ready := false
var elapsed_time := 0.0
onready var degrees_0: Position3D = $Degrees0
onready var degrees_90: Position3D = $Degrees90
onready var degrees_180: Position3D = $Degrees180
onready var degrees_270: Position3D = $Degrees270


func _process(delta: float) -> void:
	if !spawning:
		return
	elapsed_time += delta
	if elapsed_time >= spawn_dur:
		elapsed_time -= spawn_dur
		var arrow_inst := ARROW.instance()
		arrow_inst.translation = Vector3(center_offset, 0.0, rand_range(-center_offset/2.0, center_offset/2.0))
		arrow_inst.look_at_pos = Vector3(-1, 0, 0)
		arrow_inst.rotation_degrees.y = 90.0
		arrow_inst.scale = Vector3.ONE * 1.5
		arrow_inst.travel_spd = 110.0
		arrow_inst.rotation_spd = 30.0
		arrow_inst.use_global_space = false
		Util.choose([degrees_0, degrees_90, degrees_180, degrees_270]).add_child(arrow_inst)
