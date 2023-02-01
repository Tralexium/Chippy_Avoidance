extends Control

const SLOMO_SFX := preload("res://Audio/SFX/ability_slowdown.wav")
var audio_stream_player: AudioStreamPlayer
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var timer: Timer = $Timer


func _ready() -> void:
	EventBus.connect("avoidance_ended", self, "_fade_out")
	EventBus.connect("tutorial_phase_finished", self, "_fade_out")
	Engine.time_scale = Config.SLOMO_SPD
	SoundManager.play_sound(SLOMO_SFX)
	timer.start(Config.item_slomo_dur)


func _speed_up_time() -> void:
	var tween := create_tween().set_parallel()
	tween.tween_property(Engine, "time_scale", 1.0, 0.5)
	tween.tween_callback(self, "queue_free").set_delay(1.0)


func _exit_tree() -> void:
	EventBus.emit_signal("slomo_finished")


func _fade_out(phase_not_used: int = -1) -> void:
	timer.stop()
	animation_player.play("fade_out")


func _on_Timer_timeout() -> void:
	_fade_out()
