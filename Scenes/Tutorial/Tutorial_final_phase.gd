extends Spatial

const RING := preload("res://Scenes/Universal/ProjectileRing.tscn")
const PROJ := preload("res://Scenes/Tutorial/Tutorial_SpikySphere.tscn")

export var duration := 6.0
export var projectile_count := 4
onready var timer: Timer = $Timer


func _ready() -> void:
	EventBus.connect("avoidance_ended", self, "_on_avoidance_ended")


func _on_avoidance_ended() -> void:
	timer.stop()


func start() -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	timer.start(duration)
	var speed := 4.5
	var pos_offset := Vector3(0.0, 6.0, 0.0)
	for i in range(2):
		var ring_inst := RING.instance()
		ring_inst.projectile = PROJ
		ring_inst.projectile_count = projectile_count
		ring_inst.radius = 30.0
		ring_inst.y_rotation_spd = speed
		ring_inst.appear_animation = false
		ring_inst.translation = pos_offset * i
		add_child(ring_inst)
		var tween = create_tween()
		tween.tween_property(ring_inst, "radius", 0.0, duration)
		tween.tween_callback(ring_inst, "shrink")
		speed *= -1


func _on_Timer_timeout() -> void:
	EventBus.emit_signal("tutorial_phase_finished", 9)
