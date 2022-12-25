extends Spatial

onready var bounce_delay: Timer = $BounceDelay
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var detach_player: Area = $DetachPlayer

var delayed_anim := "" 
var has_fallen := false


func fall() -> void:
	has_fallen = true
	animation_player.playback_speed = 1.0
	animation_player.play("fall")

func _detach_player() -> void:
	for player in detach_player.get_overlapping_bodies():
		player.snap_vector = Vector3.ZERO
		player.translation.y += 1


func rise() -> void:
	if !has_fallen:
		return
	has_fallen = false
	animation_player.playback_speed = 1.0
	animation_player.play("rise")


func bounce_down(delay: float, speed_multiplier: float = 1.0) -> void:
	animation_player.playback_speed = speed_multiplier
	if delay > 0.0:
		bounce_delay.start(delay)
		delayed_anim = "bounce_down"
	else:
		animation_player.play("bounce_down")


func bounce_down_hard(delay: float, speed_multiplier: float = 1.0) -> void:
	animation_player.playback_speed = speed_multiplier
	if delay > 0.0:
		bounce_delay.start(delay)
		delayed_anim = "bounce_down_hard"
	else:
		animation_player.play("bounce_down_hard")


func bounce_up(delay: float, speed_multiplier: float = 1.0) -> void:
	animation_player.playback_speed = speed_multiplier
	if delay > 0.0:
		bounce_delay.start(delay)
		delayed_anim = "bounce_up"
	else:
		animation_player.play("bounce_up")


func _on_BounceDelay_timeout() -> void:
	animation_player.play(delayed_anim)
