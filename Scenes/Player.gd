extends KinematicBody

export var walk_speed := 17.0
export var jump_vel := 35.0
export var djump_vel := 30.0
export var flying_vel := 73.0
export var gravity := 1.9
export var max_fall_vel := 100.0
export var input_buffer_dur := 0.1
export var coyote_time_dur := 0.2
export var lock_2d := false
export var flying := false
export var cam_follow_y := false

export var hp := 3 setget set_hp

var input_vector := Vector3.ZERO
var velocity := Vector3.ZERO
var snap_vector := Vector3.DOWN
var has_djump := false
var is_dead := false
var coyote_time := 0.0
var input_buffer_time := 0.0
var buffered_input := ""

onready var n_mesh : MeshInstance = $MeshInstance
onready var n_collision_shape: CollisionShape = $CollisionShape
onready var n_animation_player : AnimationPlayer = $AnimationPlayer
onready var n_hitbox_shape: CollisionShape = $Hitbox/CollisionShape
onready var n_camera_pos: Position3D = $"%CameraPos"
onready var n_shadow_guide: RayCast = $ShadowGuide


func _ready() -> void:
	pass


func set_hp(value: int) -> void:
	hp = value
	if hp <= 0:
		die()


func die() -> void:
	# Do death fx here
	is_dead = true
	n_mesh.hide()
	n_collision_shape.set_deferred("disabled", true)


func _physics_process(delta: float) -> void:
	if cam_follow_y:
		n_camera_pos.translation.y = lerp(n_camera_pos.translation.y, translation.y, 0.2)
	else:
		n_camera_pos.translation.y = 0.0
	if is_dead:
		return
	
	_get_input()
	_apply_velocity()
	_animations()
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector3.UP, true)


func _input(event: InputEvent) -> void:
	input_buffer_time = input_buffer_dur
	if event.is_action_pressed("player_jump") and !is_on_floor():
		buffered_input = "player_jump"


func _get_input() -> void:
	var delta = get_physics_process_delta_time()
	coyote_time = max(0.0, coyote_time - delta)
	coyote_time = coyote_time_dur if is_on_floor() else coyote_time
	input_buffer_time = max(0.0, input_buffer_time - delta)
	
	if input_buffer_time <= 0.0:
		buffered_input = ""
	
	input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	input_vector.z = Input.get_action_strength("player_backward") - Input.get_action_strength("player_forward")
	input_vector = input_vector.rotated(Vector3.UP, n_camera_pos.rotation.y).normalized()
	if lock_2d:
		input_vector.z = 0.0
		translation.z = lerp(translation.z, 0.0, 0.5)
	if (Input.is_action_just_pressed("player_jump") or buffered_input == "player_jump") and (is_on_floor() or coyote_time > 0.0):
		has_djump = true
		input_vector.y = 1
		coyote_time = 0.0
	elif Input.is_action_just_pressed("player_jump") and has_djump:
		has_djump = false
		input_vector.y = 1


func _apply_velocity() -> void:
	var delta = get_physics_process_delta_time()
	
	velocity.y = 0.0 if is_on_floor() else max(-max_fall_vel, velocity.y - gravity)
	
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
	velocity.x = input_vector.x * walk_speed
	velocity.z = input_vector.z * walk_speed

	if !flying and Input.is_action_just_released("player_jump") and velocity.y > 0.0:
		velocity.y *= 0.5
	
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
	pass


func hit_effects() -> void:
	pass


func _on_Hitbox_area_entered(area: Area) -> void:
	self.hp -= 1
	n_hitbox_shape.set_deferred("disabled", true)
	hit_effects()
