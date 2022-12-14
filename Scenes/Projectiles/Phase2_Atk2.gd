extends Spatial

export var velocity := Vector3.ZERO setget set_velocity
export var accel := 0.0
export var life_time := 1.9

var is_ready := false

onready var n_life_timer: Timer = $LifeTime


func _ready() -> void:
	set_as_toplevel(true)
	is_ready = true
	n_life_timer.start(life_time)


func set_velocity(value: Vector3) -> void:
	velocity = value
	if is_ready and value.length() > 0:
		look_at(global_translation + value, Vector3.UP)


func _process(delta: float) -> void:
	velocity += velocity.normalized() * (accel*delta)
	global_translate(velocity * delta)


func shrink() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.25)
	tween.tween_callback(self, "queue_free").set_delay(0.25)


func _on_VisibilityNotifier_camera_exited(camera: Camera) -> void:
	shrink()


func _on_LifeTime_timeout() -> void:
	shrink()
