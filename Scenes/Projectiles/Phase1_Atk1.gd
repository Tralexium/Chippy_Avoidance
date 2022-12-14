extends KinematicBody

export var air_borne_dur := 2.0
export var fall_gravity := 10.0
export var bounce_gravity := 1.0
export var bounce_force := 20.0
export var bounce_max_angle := 10.0
export var bounce_in_z_axis := false

var velocity := Vector3.ZERO
var gravity := 0.0
var has_bounced := false

onready var mesh: MeshInstance = $Mesh
onready var warning_beam: Sprite3D = $WarningBeam
onready var collision_shape: CollisionShape = $CollisionShape


func _ready() -> void:
	mesh.scale = Vector3.ZERO
	warning_beam.warning_dur = air_borne_dur
	warning_beam.starting_scale = 10.0
	var tween := create_tween().set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC).tween_property(mesh, "scale", Vector3.ONE, 0.5)
	tween.tween_callback(self, "fall").set_delay(air_borne_dur - 0.5)


func _physics_process(delta: float) -> void:
	velocity.y -= gravity
	var collision = move_and_collide(velocity * delta)
	if !has_bounced and collision:
		has_bounced = true
		var bounce_x_angle := deg2rad(rand_range(-bounce_max_angle, bounce_max_angle))
		var bounce_z_angle := deg2rad(rand_range(-bounce_max_angle, bounce_max_angle)) if bounce_in_z_axis else 0.0
		velocity = Vector3(bounce_x_angle, 1.0, bounce_z_angle).normalized() * bounce_force
		collision_shape.disabled = true
		gravity = bounce_gravity


func fall() -> void:
	gravity = fall_gravity


func _on_VisibilityNotifier_camera_exited(camera: Camera) -> void:
	queue_free()
