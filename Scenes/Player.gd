extends KinematicBody

const HITMARKER := preload("res://Scenes/PlayerHitmark.tscn")

export var walk_speed := 17.0
export var jump_vel := 35.0
export var djump_vel := 30.0
export var flying_vel := 73.0
export var gravity := 120.0
export var max_fall_vel := 100.0
export var friction := 20.0
export var input_buffer_dur := 0.2
export var coyote_time_dur := 0.2
export var lock_2d := false
export var flying := false
export var has_djump := false
export var cam_follow_y := false

export var hp := 1 setget set_hp

var input_vector := Vector3.ZERO
var velocity := Vector3.ZERO
var snap_vector := Vector3.DOWN
var is_dead := false
var coyote_time := 0.0
var input_buffer_time := 0.0
var buffered_input := ""

onready var n_mesh : Spatial = $Mesh/Armature
onready var n_player_animation_tree: AnimationTree = $Mesh/PlayerAnimationTree
onready var n_armature_animations: AnimationPlayer = $Mesh/ArmatureAnimations
onready var n_collision_shape: CollisionShape = $CollisionShape
onready var n_hitbox_shape: CollisionShape = $Hitbox/CollisionShape
onready var n_camera_pos: Position3D = $"%CameraPos"
onready var n_shadow_guide: RayCast = $ShadowGuide
onready var n_camera: Camera = $CameraPos/SpringArm/Camera
onready var n_dust_particles: Particles = $DustParticles


func _ready() -> void:
	pass


func set_hp(value: int) -> void:
	if value < hp:
		hit_effects()
	hp = value
	if hp <= 0:
		die()


func hit_effects() -> void:
	n_hitbox_shape.set_deferred("disabled", true)
	add_child(HITMARKER.instance())


func die() -> void:
	# Do death fx here
	is_dead = true
	snap_vector = Vector3.ZERO
	n_player_animation_tree.active = false
	yield(get_tree(), "idle_frame")
	n_mesh.look_at(n_camera.global_translation, Vector3.UP)
	n_mesh.rotate_y(PI)
	n_collision_shape.set_deferred("disabled", true)
	n_armature_animations.play("Fall")
	Util.time_slowdown(0.05, 0.5)
	yield(get_tree().create_timer(0.5), "timeout")
	velocity = Vector3(40.0, 30.0, 0.0).rotated(Vector3.UP, randf() * TAU)
	n_dust_particles.emitting = true
	n_dust_particles.amount = 16
	var rotate_tween = create_tween()
	rotate_tween.tween_property(n_mesh, "rotation", Vector3(15, 6, 9), 2.0)


func _physics_process(delta: float) -> void:
	if cam_follow_y and !is_dead:
		n_camera_pos.translation.y = lerp(n_camera_pos.translation.y, translation.y, 0.2)
	else:
		n_camera_pos.translation.y = 0.0
	
	_debug()
	_get_input()
	_apply_velocity()
	_animations()
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector3.UP, true)
	if is_dead:
		print(velocity)


func _debug() -> void:
	if Globals.debug_mode and Input.is_action_just_pressed("click") and not lock_2d:
		var mouse_pos = get_viewport().get_mouse_position()
		var drop_plane  = Plane.PLANE_XZ
		global_translation = drop_plane.intersects_ray(n_camera.project_ray_origin(mouse_pos),n_camera.project_ray_normal(mouse_pos))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and !is_on_floor() and !has_djump:
		input_buffer_time = input_buffer_dur
		buffered_input = "jump"


func _get_input() -> void:
	if is_dead:
		return
	var delta = get_physics_process_delta_time()
	coyote_time = max(0.0, coyote_time - delta)
	coyote_time = coyote_time_dur if is_on_floor() else coyote_time
	input_buffer_time = max(0.0, input_buffer_time - delta)
	
	if input_buffer_time <= 0.0:
		buffered_input = ""
	
	var xy_input := Input.get_vector("left", "right", "forward", "backward", 0.2)
	input_vector = Vector3.ZERO
	input_vector.x = xy_input.x
	input_vector.z = xy_input.y
	input_vector = input_vector.rotated(Vector3.UP, n_camera_pos.rotation.y)
	if lock_2d:
		input_vector.z = 0.0
		translation.z = lerp(translation.z, 0.0, 0.5)
	if !flying:
		if (Input.is_action_just_pressed("jump") or buffered_input == "jump") and (is_on_floor() or coyote_time > 0.0):
			has_djump = true
			input_vector.y = 1
			coyote_time = 0.0
			buffered_input = ""
		elif Input.is_action_just_pressed("jump") and has_djump:
			has_djump = false
			input_vector.y = 1


func _apply_velocity() -> void:
	var delta := get_physics_process_delta_time()
	
	velocity.y = 0.0 if !is_dead and is_on_floor() else max(-max_fall_vel, velocity.y - gravity*delta)
	
	if is_dead:
		return
	
	# Jump/Y Axis
	if is_on_floor():
		n_shadow_guide.hidden = true
		snap_vector = Vector3.DOWN
	if input_vector.y > 0 or flying:
		n_shadow_guide.hidden = false
		velocity.y = jump_vel if has_djump else djump_vel
		if flying:
			velocity.y = flying_vel
		snap_vector = Vector3.ZERO
	
	# X&Z Axis
	var XZ_input := Vector2(input_vector.x, input_vector.z)
	print(XZ_input)
	if XZ_input.length() != 0.0:
		velocity.x = input_vector.x * walk_speed
		velocity.z = input_vector.z * walk_speed
		_rotate_mesh(delta)
	else:
		var XZ_velocity := Vector2(velocity.x, velocity.z)
		var friction_vel := XZ_velocity.linear_interpolate(Vector2.ZERO, friction*delta)
		velocity.x = friction_vel.x
		velocity.z = friction_vel.y

	if !flying and Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y *= 0.5


func _rotate_mesh(delta: float) -> void:
	# Rotate the player mesh based on camera's orientation / movement
	if Vector2(velocity.x, velocity.z).length() > 0.0:
		transform = transform.orthonormalized()
		var look_dir := Vector2(input_vector.z, input_vector.x)
		# Convert basis to quaternion, keep in mind scale is lost
		var quat := Quat(n_mesh.transform.basis)
		var target_quat := Quat(Vector3(0.0, look_dir.angle(), 0.0))
		# Interpolate using spherical-linear interpolation (SLERP).
		var lerped_quat := quat.slerp(target_quat, delta * 10.0)
		# Apply lerped orientation
		n_mesh.transform.basis = Basis(lerped_quat)


func stop_cam_movement() -> void:
	if n_camera_pos.tween != null:
		n_camera_pos.tween.kill()
	n_camera_pos._on_SpringArm_finished_camera_rotation()
	n_camera_pos.shake_cam(0.0, 0.0)
	n_camera_pos.global_translation = Vector3.ZERO


func _animations() -> void:
	n_player_animation_tree.set_airborne_state(is_on_floor())
	var run_strength := clamp(Vector2(velocity.x, velocity.z).length() / (walk_speed * .7), 0.0, 1.0)
	n_player_animation_tree.set_run_strength(run_strength)
	n_player_animation_tree.set_vertical_velocity(velocity.y, djump_vel)
	if run_strength > 0.2 and is_on_floor():
		n_dust_particles.emitting = true
	else:
		n_dust_particles.emitting = false
	if input_vector.y != 0:
		n_player_animation_tree.flip_jump()


func _on_Hitbox_area_entered(area: Area) -> void:
	self.hp -= 1
