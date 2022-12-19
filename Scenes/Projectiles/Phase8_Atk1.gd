extends KinematicBody

export var gravity := 1.5
export var bounce_force := 40.0

var rotate_spd := -360.0
var life_time := 0.0  # not in use
var accel := 0.0  # not in use
var velocity := Vector3.ZERO
onready var mesh: MeshInstance = $MeshInstance


func _ready() -> void:
	mesh.scale = Vector3.ZERO
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(mesh, "scale", Vector3.ONE, 0.5)
	yield(get_tree(), "idle_frame")
	velocity *= rand_range(0.5, 1.5)


func _process(delta: float) -> void:
	mesh.rotation_degrees.y += rotate_spd * delta


func _physics_process(delta: float) -> void:
	velocity.y -= gravity
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity.y = bounce_force


func _on_VisibilityNotifier_camera_exited(camera: Camera) -> void:
	queue_free()
