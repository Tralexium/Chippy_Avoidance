extends Spatial

const ARROW := preload("res://Scenes/Projectiles/FastArrowAttack.tscn")

export var spawn_radius = 10.0

onready var spawn_timer: Timer = $SpawnTimer


func start() -> void:
	_spawn_projectile()
	spawn_timer.start()


func _spawn_projectile() -> void:
	for player in get_tree().get_nodes_in_group("player"):
		var arrow_inst := ARROW.instance()
		arrow_inst.look_at_pos = player.global_translation
		add_child(arrow_inst)


func _on_SpawnTimer_timeout() -> void:
	_spawn_projectile()
