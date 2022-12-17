extends Spatial

const RING := preload("res://Scenes/Universal/RingShockwave.tscn")

export var auto_shoot := false setget set_auto_shoot
export var auto_shoot_freq := 5.0
export var auto_shoot_offset := 0.0
export var ring_target_scale := 25.0
export var ring_expand_dur := 3.0
export var rotate_spd := 100.0

var is_ready := false
onready var smashers: Position3D = $Smashers
onready var spike_ring: MeshInstance = $SpikeRing
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var timer: Timer = $Timer


func _process(delta: float) -> void:
	is_ready = true
	smashers.rotation_degrees.y += rotate_spd * delta
	spike_ring.rotation_degrees.y -= rotate_spd * delta


func set_auto_shoot(value: bool) -> void:
	auto_shoot = value
	if is_ready != true:
		return
	if auto_shoot:
		timer.start(auto_shoot_freq)
		timer.wait_time = auto_shoot_offset
	else:
		timer.stop()


func smash() -> void:
	animation_player.play("smash")
	var ring_inst := RING.instance()
	ring_inst.ring_target_scale = ring_target_scale
	ring_inst.ring_expand_dur = ring_expand_dur
	add_child(ring_inst)


func _on_Timer_timeout() -> void:
	smash()
