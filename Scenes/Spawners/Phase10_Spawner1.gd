extends Spatial

const SPIKE_RING := preload("res://Scenes/Projectiles/Phase10_Atk1.tscn")

export var spawning := false setget set_spawning
export var spawn_dur := 0.58 setget set_spawn_dur
export var spin_speed := 10.0 setget set_spin_speed
export var shrink_amnt := 0.7 setget set_shrink_amnt
export var disabled := false setget set_disabled

var is_ready := false
var speed_multiplier := 1.0
onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	is_ready = true


func set_spawning(value: bool) -> void:
	spawning = true
	if not is_ready:
		return
	if value:
		start()
	else:
		spawn_timer.stop()


func set_spawn_dur(duration: float) -> void:
	spawn_dur = duration
	if spawning:
		start()


func set_shrink_amnt(value: float) -> void:
	shrink_amnt = value
	for ring in get_children():
		if not ring is Timer:
			ring.shrink_amnt = shrink_amnt


func set_spin_speed(value: float) -> void:
	spin_speed = value
	for ring in get_children():
		if not ring is Timer:
			ring.spin_spd = value


func set_disabled(value: bool) -> void:
	disabled = value
	for ring in get_children():
		if not ring is Timer:
			ring.disabled = value


func start() -> void:
	_spawn_projectile()
	spawn_timer.start(spawn_dur)


func _spawn_projectile() -> void:
	var spike_ring_inst := SPIKE_RING.instance()
	spike_ring_inst.shrink_amnt = shrink_amnt
	spike_ring_inst.spin_spd = spin_speed
	spike_ring_inst.spin_dir = speed_multiplier
	speed_multiplier *= -1
	add_child(spike_ring_inst)


func _on_SpawnTimer_timeout() -> void:
	_spawn_projectile()
