extends Spatial

const ARROW := preload("res://Scenes/Projectiles/FastArrowAttack.tscn")

export var spawning := false setget set_spawning
export var spawn_dur := 0.58 setget set_spawn_dur
export var spawn_radius = 10.0

var is_ready := false
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


func start() -> void:
	_spawn_projectile()
	spawn_timer.start(spawn_dur)


func _spawn_projectile() -> void:
	for player in get_tree().get_nodes_in_group("player"):
		var arrow_inst := ARROW.instance()
		arrow_inst.translation = player.global_translation + Vector3(spawn_radius, 0.0, 0.0).rotated(Vector3.UP, randf()*TAU)
		arrow_inst.look_at_pos = player.global_translation
		add_child(arrow_inst)


func _on_SpawnTimer_timeout() -> void:
	_spawn_projectile()
