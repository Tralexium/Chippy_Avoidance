extends Control

var audio_stream_player: AudioStreamPlayer
onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	Engine.time_scale = Config.SLOMO_SPD
	audio_stream_player = SoundManager.play_music(Globals.AVOIDANCE_MUSIC, 0.0, "Music")
	audio_stream_player.pitch_scale = Config.SLOMO_SPD
	yield(get_tree().create_timer(Config.item_slomo_dur), "timeout")
	animation_player.play("fade_out")


func _speed_up_time() -> void:
	var tween := create_tween().set_parallel()
	tween.tween_property(Engine, "time_scale", 1.0, 0.5)
	tween.tween_property(audio_stream_player, "pitch_scale", 1.0, 0.5)
	tween.tween_callback(self, "queue_free").set_delay(1.0)


func _exit_tree() -> void:
	EventBus.emit_signal("slomo_finished")
