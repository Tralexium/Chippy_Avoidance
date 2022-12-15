extends Spatial

const PROJECTILE := preload("res://Scenes/Projectiles/Phase1_Atk1.tscn")

export var spawning := false setget set_spawning
export var spawn_frequency := 0.2 setget set_spawn_frequency
export var spawn_amount := 1
export var projectile_spacing := 1.1
export var projectile_spawn_area := 20

var spawn_positions := []
var is_ready := false

onready var spawner: Timer = $Spawner


func _ready() -> void:
	is_ready = true


func fill_spawn_array() -> void:
	var pos := Vector3.ZERO
	var offset := Vector3.ZERO
	for i in range(projectile_spawn_area):
		offset = Vector3(i * projectile_spacing, 0.0, 0.0)
		spawn_positions.push_back(offset)
		if i != 0:
			spawn_positions.push_back(-offset)
	spawn_positions.shuffle()


func set_spawning(value: bool) -> void:
	spawning = true
	if not is_ready:
		return
	if value:
		spawner.wait_time = spawn_frequency
		spawner.start()
	else:
		spawner.stop()


func spawn_row(amount: int, x_offset: float, padding: float, airborne_dur: float, delay_increase: float, reverse: bool = false) -> void:
	var starting_x := (amount*padding)/2.0 if reverse else -(amount*padding)/2.0
	starting_x += x_offset
	var starting_pos := Vector3(starting_x, translation.y, translation.z)
	padding = -padding if reverse else padding
	for i in range(amount):
		var projectile_inst := PROJECTILE.instance()
		var inst_pos := starting_pos + Vector3(padding * i, 0.0, 0.0)
		projectile_inst.translate(inst_pos)
		projectile_inst.air_borne_dur = airborne_dur + delay_increase*i
		add_child(projectile_inst)


func set_spawn_frequency(value: float) -> void:
	spawn_frequency = value
	if not is_ready:
		return
	spawner.wait_time = spawn_frequency


func _on_Spawner_timeout() -> void:
	for i in range(spawn_amount):
		if spawn_positions.empty():
			fill_spawn_array()
		var spawn_pos : Vector3 = spawn_positions.pop_back()
		var projectile_inst := PROJECTILE.instance()
		projectile_inst.translate(spawn_pos)
		add_child(projectile_inst)
