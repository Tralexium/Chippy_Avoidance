extends Spatial

const ORB := preload("res://Scenes/Projectiles/Phase2_Atk1.tscn")
const ARROW := preload("res://Scenes/Projectiles/Phase2_Atk2.tscn")
const BOUNCY := preload("res://Scenes/Projectiles/Phase8_Atk1.tscn")

export var enabled := false setget set_enabled
export var bouncy := false
export var orb_count := 2
export var orb_center_distance := 22.0
export var auto_shoot_freq := 0.05
export var rotation_spd := 1.5

var is_ready := false
var add_rotation := 0.0
onready var auto_shoot: Timer = $AutoShoot


func _ready() -> void:
	is_ready = true
	auto_shoot.wait_time = auto_shoot_freq


func _process(delta: float) -> void:
	add_rotation += rotation_spd * delta
	if $Orbs.get_child_count() == 0:
		return
	var offset_angle = TAU / orb_count
	var i = 0
	for orb in $Orbs.get_children():
		orb.translation = Vector3.RIGHT.rotated(Vector3.UP, offset_angle*i + add_rotation) * orb_center_distance
		i += 1


func set_enabled(value: bool) -> void:
	enabled = value
	auto_shoot.stop()
	if not is_ready:
		return
	if enabled:
		_spawn_orbs()
	else :
		_despawn_orbs()


func _spawn_orbs() -> void:
	var offset_angle = TAU / orb_count
	for i in range(orb_count):
		var orb_inst = ORB.instance()
		if bouncy:
			orb_inst.projectile = BOUNCY
		else:
			orb_inst.projectile = ARROW
		orb_inst.translate(Vector3.RIGHT.rotated(Vector3.UP, offset_angle*i) * orb_center_distance)
		$Orbs.add_child(orb_inst)


func set_distance(distance: float, duration: float) -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(self, "orb_center_distance", distance, duration)


func _despawn_orbs() -> void:
	if $Orbs.get_child_count() == 0:
		return
	for orb in $Orbs.get_children():
		orb.queue_free()


func rotate_spawner(target_angle: float, duration: float, ease_type: int = Tween.EASE_IN_OUT, trans_type: int = Tween.TRANS_LINEAR) -> void:
	var tween = create_tween().set_ease(ease_type).set_trans(trans_type)
	tween.tween_property(self, "rotation_degrees:y", rotation_degrees.y + target_angle, duration)


func start_reverse_shooting() -> void:
	auto_shoot.start()


func shoot(amount: int, inverse_angle: bool = false, accel: float = 0.0) -> void:
	if not enabled:
		return
	for orb in $Orbs.get_children():
		orb.shoot_at(Vector3(0.0, translation.y, 0.0), amount, 25.0, deg2rad(90.0), inverse_angle, accel)


func _on_AutoShoot_timeout() -> void:
	shoot(1, true, 40.0)
