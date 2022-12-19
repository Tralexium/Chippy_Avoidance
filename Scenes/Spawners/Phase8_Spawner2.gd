extends Spatial

const PROJECTILE := preload("res://Scenes/Projectiles/Phase2_Atk3.tscn")

export var frequency := .3
export var at_player_freq := 4
export var random_spawn_rad := 17.0
var shots_fired := 0


func start() -> void:
	$SpawnFreq.start(frequency)


func stop() -> void:
	$SpawnFreq.stop()


func spawn_projectile() -> void:
	shots_fired += 1
	var projectile_inst = PROJECTILE.instance()
	projectile_inst.area_radius = 6.0
	add_child(projectile_inst)
	
	if shots_fired % at_player_freq == 0:
		var player_pos = get_tree().get_nodes_in_group("player")[0].global_translation
		projectile_inst.translation = Vector3(player_pos.x, translation.y, player_pos.z)
	else:
		var rand_pos = Vector2(randf() * random_spawn_rad, 0.0).rotated(randf() * TAU)
		projectile_inst.translation = Vector3(rand_pos.x, translation.y, rand_pos.y)


func _on_SpawnFreq_timeout() -> void:
	spawn_projectile()
