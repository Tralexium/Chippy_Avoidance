extends Spatial

const PROJECTILE := preload("res://Scenes/Projectiles/Phase2_Atk3.tscn")


func spawn_projectile() -> void:
	var projectile_inst = PROJECTILE.instance()
	var player_pos = get_tree().get_nodes_in_group("player")[0].global_translation
	add_child(projectile_inst)
	projectile_inst.translation = Vector3(player_pos.x, translation.y, player_pos.z)
