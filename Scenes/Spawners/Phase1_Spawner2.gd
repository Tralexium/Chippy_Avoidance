extends Spatial

const RING := preload("res://Scenes/Universal/ProjectileRing.tscn")
const PROJECTILE := preload("res://Scenes/Projectiles/Phase1_Atk2.tscn")

export var orb_count := 2
export var radius := 6.0


func spawn_orb_ring(hor_position: float, hor_velocity: float) -> void:
	var spawn_position = Vector3(hor_position, 0, 0)
	var ring_inst := RING.instance()
	ring_inst.translation = spawn_position
	ring_inst.projectile = PROJECTILE
	ring_inst.projectile_count = orb_count
	ring_inst.radius = radius
	ring_inst.velocity = Vector3.RIGHT * hor_velocity
	ring_inst.y_rotation_spd = 3.0 * sign(-hor_velocity)
	add_child(ring_inst)


func _on_NextWave_timeout() -> void:
	pass # Replace with function body.
