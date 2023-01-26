extends Spatial

const CIRCLE_TRANSITION := preload("res://Scenes/Universal/CircleTransition.tscn")
const REWIND_FX := preload("res://Scenes/RewindEffect.tscn")
const SLOMO_FX := preload("res://Scenes/UI/SlomoEffect.tscn")
const HIT_FX := preload("res://Scenes/UI/HitFX.tscn")

export var starting_hp := 2

var currently_restarting := false
var audio_stream_player: AudioStreamPlayer
onready var ability_border_fx: Control = $FX/AbilityBorderFX
onready var respawn_timer: Timer = $RespawnTimer
onready var player: KinematicBody = $Player
onready var hp_hud: Control = $UI/PlayerHUD/HPHUD
onready var player_hud: Control = $UI/PlayerHUD


func _ready() -> void:
	EventBus.connect("hp_changed", self, "_on_damage_taken")
	EventBus.connect("ability_used", self, "_on_ability_used")
	EventBus.connect("avoidance_ended", self, "_on_avoidance_ended")
	audio_stream_player = SoundManager.play_music(Globals.TUTORIAL_MUSIC, 0.0, "Music")
	hp_hud.set_bars(starting_hp)
	player.set_only_hp(starting_hp)


func _process(delta: float) -> void:
	if !currently_restarting:
		audio_stream_player.pitch_scale = Engine.time_scale


func _on_ability_used(ability_num: int) -> void:
	if ability_num == Globals.ABILITIES.SLO_MO:
		$FX.add_child(SLOMO_FX.instance())
	else:
		ability_border_fx.enable_effect(ability_num)


func _on_damage_taken(new_hp: int) -> void:
	$FX.add_child(HIT_FX.instance())


func _on_avoidance_ended() -> void:
	respawn_timer.start()


func _on_RespawnTimer_timeout() -> void:
	SoundManager.pause_music(0.3)
	var yaaah_its_rewind_time := REWIND_FX.instance()
	yaaah_its_rewind_time.connect("faded_in", self, "_on_rewind_faded_in")
	yaaah_its_rewind_time.connect("finished", self, "_on_rewind_finished")
	$FX.add_child(yaaah_its_rewind_time)


func _on_rewind_faded_in() -> void:
	player.revive(Vector3(0.0, 2.0, 0.0), starting_hp)
	hp_hud.set_bars(starting_hp)


func _on_rewind_finished() -> void:
	SoundManager.resume_music(0.3)
	player_hud.slide_in()
