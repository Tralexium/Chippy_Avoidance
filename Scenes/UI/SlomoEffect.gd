extends Control

const SLOMO_SFX := preload("res://Audio/SFX/ability_slowdown.wav")
var audio_stream_player: AudioStreamPlayer
onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	Engine.time_scale = Config.SLOMO_SPD
	SoundManager.play_sound(SLOMO_SFX)
	yield(get_tree().create_timer(Config.item_slomo_dur), "timeout")
	animation_player.play("fade_out")


func _speed_up_time() -> void:
	var tween := create_tween().set_parallel()
	tween.tween_property(Engine, "time_scale", 1.0, 0.5)
	tween.tween_callback(self, "queue_free").set_delay(1.0)


func _exit_tree() -> void:
	EventBus.emit_signal("slomo_finished")
