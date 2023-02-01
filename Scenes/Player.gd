extends KinematicBody

const HITMARKER := preload("res://Scenes/PlayerHitmark.tscn")
const SFX_HIT := preload("res://Audio/SFX/player_hit.wav")
const SFX_FATAL_HIT := preload("res://Audio/SFX/player_fatal_hit.wav")
const SFX_FATAL_LAUNCH := preload("res://Audio/SFX/player_fatal_launch.wav")
const SFX_ABILITY_JUMP := preload("res://Audio/SFX/ability_megajump.wav")
const SFX_ABILITY_JUMP_EXP := preload("res://Audio/SFX/ability_megajump_expired.wav")
const SFX_ABILITY_SPEED := preload("res://Audio/SFX/ability_speedup.wav")
const SFX_ABILITY_SPEED_EXP := preload("res://Audio/SFX/ability_speedup_expired.wav")

signal all_abilities_expired
signal ability_expired(ability)

export var walk_speed := 17.0
export var super_speed := 26.0
export var jump_vel := 35.0
export var mega_jump_vel := 50.0
export var djump_vel := 30.0
export var flying_vel := 73.0
export var gravity := 120.0
export var max_fall_vel := 100.0
export var friction := 20.0
export var input_buffer_dur := 0.2
export var coyote_time_dur := 0.2
export var lock_2d := false setget set_lock_2d
export var flying := false
export var has_djump := false
export var cam_follow_y := false
export var shielded := false
export var iframe_immunity := false
export var iframes_dur := 2.0
export var shield_iframes_dur := 1.0

var input_vector := Vector3.ZERO
var velocity := Vector3.ZERO
var snap_vector := Vector3.DOWN
var is_dead := false
var coyote_time := 0.0
var input_buffer_time := 0.0
var previous_fall_spd := 0.0
var slomo_compensation := 1.0
var buffered_input := ""
var abilities_in_use := []

onready var hp := Config.player_max_hp setget set_hp
onready var n_mesh : Spatial = $Mesh/Armature
onready var n_character_mesh : Spatial = $Mesh/Armature/Skeleton/Character
onready var n_player_animation_tree: AnimationTree = $Mesh/PlayerAnimationTree
onready var n_armature_animations: AnimationPlayer = $Mesh/ArmatureAnimations
onready var n_iframe_anim: AnimationPlayer = $IFrameAnim
onready var n_collision_shape: CollisionShape = $CollisionShape
onready var n_hitbox_shape: CollisionShape = $Hitbox/CollisionShape
onready var n_camera_pos: Position3D = $"%CameraPos"
onready var n_shadow_guide: RayCast = $ShadowGuide
onready var n_camera: Camera = $CameraPos/SpringArm/Camera
onready var n_dust_particles: Particles = $DustParticles
onready var n_mega_jump_dur: Timer = $MegaJumpDur
onready var n_super_speed_dur: Timer = $SuperSpeedDur
onready var n_shield_dur: Timer = $ShieldDur
onready var n_speed_trail: ImmediateGeometry = $Mesh/Armature/SpeedTrail
onready var n_mega_jump_part: Particles = $Mesh/MegaJumpPart
onready var n_player_shield: MeshInstance = $Mesh/PlayerShield
onready var n_iframes_timer: Timer = $IFrames
onready var n_djump_part: Particles = $Mesh/DJumpPart
onready var n_death_beams: Particles = $Mesh/DeathBeams
onready var n_death_sparkles: Particles = $Mesh/DeathSparkles
onready var n_step_sfx: Timer = $StepSFX
# SFX
onready var audio_jump: AudioStreamPlayer3D = $StereoSFX/Jump
onready var audio_djump: AudioStreamPlayer3D = $StereoSFX/DJump
onready var audio_mega_jump: AudioStreamPlayer3D = $StereoSFX/MegaJump
onready var audio_step: AudioStreamPlayer3D = $StereoSFX/Step
onready var audio_land: AudioStreamPlayer3D = $StereoSFX/Land
onready var audio_land_light: AudioStreamPlayer3D = $StereoSFX/LandLight


func _ready() -> void:
	EventBus.connect("ability_used", self, "_on_ability_used")
	EventBus.connect("slomo_finished", self, "_on_slomo_finished")


func _on_ability_used(ability_num: int) -> void:
	InputHelper.rumble_medium()
	var shader := n_character_mesh.material_overlay as ShaderMaterial
	abilities_in_use.push_back(ability_num)
	match ability_num:
		Globals.ABILITIES.MEGA_JUMP:
			n_mega_jump_dur.start(Config.item_jump_dur)
			n_mega_jump_part.emitting = true
			SoundManager.play_sound(SFX_ABILITY_JUMP)
		Globals.ABILITIES.SUPER_SPEED:
			n_super_speed_dur.start(Config.item_speed_dur)
			n_speed_trail.show()
			SoundManager.play_sound(SFX_ABILITY_SPEED)
		Globals.ABILITIES.SHIELD:
			shielded = true
			n_player_shield.scale_to(2.0)
			n_shield_dur.start(Config.item_shield_dur)


func set_lock_2d(value: bool) -> void:
	if value != lock_2d:
		EventBus.emit_signal("switched_projection")
	lock_2d = value


func set_hp(value: int) -> void:
	if is_dead:
		return
	Globals.run_stats["damage_taken"] = Config.player_max_hp - value
	EventBus.emit_signal("hp_changed", value)
	if value < hp:
		hit_effects(value)
	hp = value
	if hp <= 0 and !is_dead and !Config.infinite_hp:
		die()


func set_only_hp(value: int) -> void:
	hp = value


func hit_effects(new_hp: int) -> void:
	iframe_immunity = true
	n_iframe_anim.play("iframes")
	n_iframes_timer.start(iframes_dur)
	var hitmarker := HITMARKER.instance()
	hitmarker.translation = $Mesh/MegaJumpPart.translation
	hitmarker.shrink_dur = 0.1 if new_hp > 0 else 0.05
	if new_hp > 0:
		n_camera_pos.shake_cam_instant(1.0, 0.2)
		InputHelper.rumble_medium()
		SoundManager.play_sound(SFX_HIT)
	if !abilities_in_use.has(Globals.ABILITIES.SLO_MO) and new_hp > 0:
		Util.time_slowdown(0.2, 0.2)
	add_child(hitmarker)


func die() -> void:
	# Do death fx here
	is_dead = true
	n_death_beams.emitting = true
	n_step_sfx.stop()
	expire_all_abilities()
	EventBus.emit_signal("avoidance_ended")
	InputHelper.rumble_medium()
	SoundManager.play_sound(SFX_FATAL_HIT)
	snap_vector = Vector3.ZERO
	n_player_animation_tree.active = false
	yield(get_tree(), "idle_frame")
	n_mesh.look_at(n_camera.global_translation, Vector3.UP)
	n_mesh.rotate_y(PI)
	n_collision_shape.set_deferred("disabled", true)
	n_armature_animations.play("Fall")
	Util.time_slowdown(0.05, 0.6)
	yield(get_tree().create_timer(0.6 * 0.05), "timeout")
	velocity = Vector3(80.0, 60.0, 0.0).rotated(Vector3.UP, randf() * TAU)
	if lock_2d:
		velocity.z = 0.0
	n_dust_particles.emitting = true
	n_death_sparkles.emitting = true
	n_dust_particles.amount = 16
	n_camera_pos.shake_cam_instant(5.0, 0.4)
	var rotate_tween = create_tween()
	rotate_tween.tween_property(n_mesh, "rotation", Vector3(30, 12, 18), 2.0)
	InputHelper.rumble_large()
	SoundManager.play_sound(SFX_FATAL_LAUNCH)


func revive(spawn_location: Vector3, restore_hp: int) -> void:
	global_translation = spawn_location
	is_dead = false
	n_player_animation_tree.active = true
	hp = restore_hp if restore_hp > 0 else 1
	n_dust_particles.emitting = false
	n_dust_particles.amount = 3
	n_mesh.rotation = Vector3.ZERO
	n_collision_shape.set_deferred("disabled", false)


func expire_all_abilities() -> void:
	n_mega_jump_dur.start(0.05)
	n_super_speed_dur.start(0.05)
	n_shield_dur.start(0.05)


func _physics_process(delta: float) -> void:
	if !is_dead:
		if cam_follow_y:
			n_camera_pos.translation.y = lerp(n_camera_pos.translation.y, translation.y, 0.2)
		else:
			n_camera_pos.translation.y = 0.0
	
	_debug()
	_get_input()
	_apply_velocity()
	_animations()
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector3.UP, true)


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
	
	var xy_input := Input.get_vector("left", "right", "forward", "backward", 0.0)
	var joystick_input := Input.get_vector("left_stick", "right_stick", "forward_stick", "backward_stick", 0.2)
	input_vector = Vector3.ZERO
	input_vector.x = xy_input.x + joystick_input.x
	input_vector.z = xy_input.y + joystick_input.y
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
			if abilities_in_use.has(Globals.ABILITIES.MEGA_JUMP):
				audio_mega_jump.play()
				InputHelper.rumble_small()
			else:
				audio_jump.play()
		elif Input.is_action_just_pressed("jump") and (has_djump or Config.infinite_jump):
			has_djump = false
			input_vector.y = 1
			n_djump_part.emitting = true
			audio_djump.play()
			InputHelper.rumble_small()
			EventBus.emit_signal("tutorial_phase_finished", 1)
	Globals.run_stats["jumps"] += input_vector.y


func _apply_velocity() -> void:
	var delta := get_physics_process_delta_time()
	
	slomo_compensation = max(1.0, 2.0 - Engine.time_scale)
	
	if velocity.y < 0.0:
		previous_fall_spd = velocity.y
	velocity.y = 0.0 if !is_dead and is_on_floor() else max(-max_fall_vel, velocity.y - (gravity*pow(slomo_compensation, 2.25)*delta))
	
	if is_dead:
		return
	
	# Jump/Y Axis
	if is_on_floor():
		if snap_vector == Vector3.ZERO:
			if previous_fall_spd <= -max_fall_vel:
				n_camera_pos.shake_cam_instant(1.0, 0.3)
				audio_land.play()
				InputHelper.rumble_medium()
			else:
				audio_land_light.play()
		n_shadow_guide.hidden = true
		snap_vector = Vector3.DOWN
	if input_vector.y > 0 or flying:
		n_shadow_guide.hidden = false
		var _jump_vel := mega_jump_vel if abilities_in_use.has(Globals.ABILITIES.MEGA_JUMP) else jump_vel
		velocity.y = _jump_vel if has_djump else djump_vel
		if flying:
			velocity.y = flying_vel
		snap_vector = Vector3.ZERO
		velocity.y *= min(slomo_compensation, 1.3)
	
	if !flying and Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y *= 0.5
	
	# X&Z Axis
	var XZ_input := Vector2(input_vector.x, input_vector.z)
	Globals.run_stats["steps"] += XZ_input.length() / 10.0
	if XZ_input.length() > 0.05:
		var _spd := super_speed if abilities_in_use.has(Globals.ABILITIES.SUPER_SPEED) else walk_speed
		_spd *= slomo_compensation
		velocity.x = input_vector.x * _spd
		velocity.z = input_vector.z * _spd
		_rotate_mesh(delta)
	else:
		var XZ_velocity := Vector2(velocity.x, velocity.z)
		var friction_vel := XZ_velocity.linear_interpolate(Vector2.ZERO, (friction*slomo_compensation)*delta)
		velocity.x = friction_vel.x
		velocity.z = friction_vel.y
	
	n_step_sfx.wait_time = 0.16 * Engine.time_scale
	if XZ_input.length() > 0.05 and is_on_floor():
		if n_step_sfx.is_stopped():
			n_step_sfx.start()
			_on_StepSFX_timeout()
	else:
		n_step_sfx.stop()


func _rotate_mesh(delta: float) -> void:
	# Rotate the player mesh based on camera's orientation / movement
	if Vector2(velocity.x, velocity.z).length() > 0.05:
		transform = transform.orthonormalized()
		var look_dir := Vector2(input_vector.z, input_vector.x)
		# Convert basis to quaternion, keep in mind scale is lost
		var quat := Quat(n_mesh.transform.basis)
		var target_quat := Quat(Vector3(0.0, look_dir.angle(), 0.0))
		# Interpolate using spherical-linear interpolation (SLERP).
		var lerped_quat := quat.slerp(target_quat, (10.0 * slomo_compensation) * delta)
		# Apply lerped orientation
		n_mesh.transform.basis = Basis(lerped_quat)


func stop_cam_movement() -> void:
	if n_camera_pos.tween != null:
		n_camera_pos.tween.kill()
	n_camera_pos._on_SpringArm_finished_camera_rotation()
	n_camera_pos.shake_cam(0.0, 0.0)
	n_camera_pos.global_translation = Vector3.ZERO


func _animations() -> void:
	if is_dead:
		return
	n_player_animation_tree.set("parameters/TimeScale/scale", slomo_compensation)
	n_player_animation_tree.set_airborne_state(is_on_floor())
	var run_strength := clamp(Vector2(velocity.x, velocity.z).length() / (walk_speed * .7), 0.0, 1.0)
	n_player_animation_tree.set_run_strength(run_strength)
	n_player_animation_tree.set_vertical_velocity(velocity.y, djump_vel)
	if run_strength > 0.2 and is_on_floor():
		n_dust_particles.emitting = true
	else:
		n_dust_particles.emitting = false
	if input_vector.y != 0 and has_djump:
		n_player_animation_tree.flip_jump()
	
	# Ability outline
	var col := Color.black
	if abilities_in_use.has(Globals.ABILITIES.MEGA_JUMP):
		col += Color("f82c57")
	if abilities_in_use.has(Globals.ABILITIES.SUPER_SPEED):
		col += Color("f8d82c")
	if abilities_in_use.has(Globals.ABILITIES.SLO_MO):
		col += Color("2cf894")
	if abilities_in_use.has(Globals.ABILITIES.SHIELD):
		col += Color("52f3ff")
	var shader := n_character_mesh.material_overlay as ShaderMaterial
	shader.set_shader_param("outline_color", col)


func _damage_inflicted(node: Node) -> void:
	if !Globals.god_mode:
		if shielded:
			n_player_shield.fracture()
			n_iframes_timer.start(shield_iframes_dur)
			n_iframe_anim.play("iframes")
			iframe_immunity = true
			shielded = false
			_remove_ability_effects(Globals.ABILITIES.SHIELD)
			InputHelper.rumble_medium()
		if node.is_in_group("insta_killer"):
			self.hp = 0
		elif !iframe_immunity:
			self.hp -= 1


func _on_Hitbox_area_entered(area: Area) -> void:
	_damage_inflicted(area)


func _on_Hitbox_body_entered(body: Node) -> void:
	_damage_inflicted(body)


func _remove_ability_effects(ability_num: int) -> void:
	var index := abilities_in_use.find(ability_num)
	if index != -1:
		if !is_dead:
			match ability_num:
				Globals.ABILITIES.MEGA_JUMP:
					SoundManager.play_sound(SFX_ABILITY_JUMP_EXP)
				Globals.ABILITIES.SUPER_SPEED:
					SoundManager.play_sound(SFX_ABILITY_SPEED_EXP)
		abilities_in_use.remove(index)
		emit_signal("ability_expired", ability_num)
		if abilities_in_use.empty() and ability_num != Globals.ABILITIES.SLO_MO:
			emit_signal("all_abilities_expired")


func _on_MegaJumpDur_timeout() -> void:
	n_mega_jump_part.emitting = false
	_remove_ability_effects(Globals.ABILITIES.MEGA_JUMP)


func _on_SuperSpeedDur_timeout() -> void:
	n_speed_trail.hide()
	_remove_ability_effects(Globals.ABILITIES.SUPER_SPEED)


func _on_ShieldDur_timeout() -> void:
	if !shielded:
		return
	n_player_shield.scale_to(0.0)
	_remove_ability_effects(Globals.ABILITIES.SHIELD)


func _on_slomo_finished() -> void:
	_remove_ability_effects(Globals.ABILITIES.SLO_MO)


func _on_IFrames_timeout() -> void:
	n_iframe_anim.stop()
	iframe_immunity = false
	n_character_mesh.visible = true


func _on_StepSFX_timeout() -> void:
	audio_step.play()
	audio_step.pitch_scale = rand_range(0.9, 1.0)


func _on_PlayerShield_hidden() -> void:
	shielded = false


func _on_VisibilityNotifier_screen_exited() -> void:
	if Globals.currently_quiting:
		return
	if shielded:
		n_player_shield.fracture()
		n_iframes_timer.start(shield_iframes_dur)
		iframe_immunity = true
		shielded = false
		_remove_ability_effects(Globals.ABILITIES.SHIELD)
	self.hp = 0
