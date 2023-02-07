extends Spatial

const RING := preload("res://Scenes/Universal/ProjectileRing.tscn")
const PROJECTILE := preload("res://Scenes/Projectiles/FastArrowAttack.tscn")

export var spawn_radius := 20.0
export var ring_scale := 1.5

func spawn_ring() -> void:
	var ring_inst := RING.instance()
	ring_inst.scale = Vector3.ONE * ring_scale
	ring_inst.projectile = PROJECTILE
	ring_inst.projectile_count = 11
	ring_inst.radius = spawn_radius
	ring_inst.y_rotation_spd = 0.0
	ring_inst.appear_animation = false
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(ring_inst, "rotation:y", TAU, 0.5)
	add_child(ring_inst)
	yield(get_tree(), "idle_frame")
	ring_inst.set_projectiles_variable("look_at_pos", global_translation)
	ring_inst.set_projectiles_variable("travel_spd", 140.0)
	ring_inst.set_projectiles_variable("rotation_spd", 40.0)
