extends Spatial

const EYE_BLINK := preload("res://Scenes/Universal/EyeBlinkTransition.tscn")
const STATS_MENUS := preload("res://Scenes/UI/StatsScreen.tscn")
const CIRCLE_TRANSITION := preload("res://Scenes/Universal/CircleTransition.tscn")
const FADE_TRANSITION := preload("res://Scenes/Universal/FadeRect.tscn")
const SLOMO_FX := preload("res://Scenes/UI/SlomoEffect.tscn")
const HIT_FX := preload("res://Scenes/UI/HitFX.tscn")

export var phase_time_stamps := [0.0, 10.2, 24.5, 32.8, 43.0, 52.5, 63.5, 82.44, 107.5, 118.0]

var current_phase := 0
var audio_stream_player: AudioStreamPlayer
var currently_restarting := false
onready var timeline: AnimationPlayer = $Timeline
onready var player: KinematicBody = $Player
onready var cam_path: Path = $CamPath
onready var ability_border_fx: Control = $FX/AbilityBorderFX


func _init() -> void:
	spawn_blink_overlay(1.25, true)


func _ready() -> void:
	Globals.can_pause = true
	Globals.in_tutorial = false
	Globals.reset_run_stats()
	EventBus.emit_signal("avoidance_started")
	EventBus.connect("hp_changed", self, "_on_damage_taken")
	EventBus.connect("ability_used", self, "_on_ability_used")
	EventBus.connect("avoidance_ended", self, "_on_avoidance_ended")
	EventBus.connect("coin_collected", self, "_on_coin_collected")
	EventBus.connect("avoidance_restart", self, "_on_avoidance_restart")
	EventBus.connect("goto_menu", self, "_on_goto_menu")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	audio_stream_player = SoundManager.play_music(Globals.AVOIDANCE_MUSIC, 0.0, "Music")
	audio_stream_player.seek(0.0)


func _process(delta: float) -> void:
	if !currently_restarting:
		audio_stream_player.pitch_scale = Engine.time_scale
	if !Globals.debug_mode:
		return
	if Input.is_action_just_pressed("dev_skip_phase_up"):
		fast_forward_phase(1)
	if Input.is_action_just_pressed("dev_skip_phase_down"):
		fast_forward_phase(-1)
	if Input.is_action_just_pressed("quick restart"):
		_on_avoidance_restart()


func fast_forward_phase(skip_phases: int) -> void:
	var found_phase := phase_time_stamps.size()
	var current_time := audio_stream_player.get_playback_position()
	for time_stamp in phase_time_stamps.size():
		found_phase -= 1
		if current_time > phase_time_stamps[found_phase]:
			break
	current_phase = int(clamp(found_phase + skip_phases, 0, phase_time_stamps.size() - 1))
	var audio_pos : float = phase_time_stamps[current_phase]
	for hazard in get_tree().get_nodes_in_group("hazard"):
		hazard.queue_free()
	cam_path.end()
	player.stop_cam_movement()
	audio_stream_player.seek(audio_pos)
	timeline.seek(audio_pos, true)


func spawn_blink_overlay(speed: float, reverse: bool) -> void:
	var blink_inst := EYE_BLINK.instance()
	blink_inst.speed = speed
	blink_inst.reverse = reverse
	add_child(blink_inst)


func _on_damage_taken(new_hp: int) -> void:
	var event : int = Globals.TIMELINE_EVENTS.DAMAGE if new_hp > 0 else Globals.TIMELINE_EVENTS.DEATH
	var song_position := audio_stream_player.get_playback_position()
	var unit_position := song_position / audio_stream_player.stream.get_length()
	Globals.timeline_events.push_back([event, unit_position])
	$FX.add_child(HIT_FX.instance())


func _on_coin_collected() -> void:
	var event : int = Globals.TIMELINE_EVENTS.COIN
	var song_position := audio_stream_player.get_playback_position()
	var unit_position := song_position / audio_stream_player.stream.get_length()
	Globals.timeline_events.push_back([event, unit_position])


func _on_ability_used(ability_num: int) -> void:
	var song_position := audio_stream_player.get_playback_position()
	var unit_position := song_position / audio_stream_player.stream.get_length()
	Globals.timeline_events.push_back([ability_num, unit_position])
	if ability_num == Globals.ABILITIES.SLO_MO:
		$FX.add_child(SLOMO_FX.instance())
	else:
		ability_border_fx.enable_effect(ability_num)


func _on_avoidance_ended() -> void:
	var song_position := audio_stream_player.get_playback_position()
	var unit_position := song_position / audio_stream_player.stream.get_length()
	timeline.stop()
	ability_border_fx.fade_out()
	var mus_bus := SoundManager.get_default_music_bus()
	AudioServer.set_bus_effect_enabled(mus_bus, 0, true)
	SoundManager.music.fade_volume(audio_stream_player, 0, -15, 1.0)
	Globals.can_pause = false
	Globals.run_stats["survival_time"] = song_position
	Globals.run_stats["unit_survival_time"] = unit_position
	Config.total_deaths += 1
	Config.total_play_time += song_position
	var stats_ui := STATS_MENUS.instance()
	$UI.add_child(stats_ui)


func _spawn_transition(back_to_menu: bool) -> void:
	if currently_restarting:
		return
	currently_restarting = true
	player.iframe_immunity = true
	create_tween().tween_property(audio_stream_player, "pitch_scale", 0.01, 0.5)
	var transition_inst := CIRCLE_TRANSITION.instance()
	transition_inst.connect("finished", self, "_on_transition_finished", [back_to_menu])
	add_child(transition_inst)


func spawn_fade_transition() -> void:
	var fade_inst := FADE_TRANSITION.instance()
	fade_inst.delete_on_fade = true
	fade_inst.fade_dur = 1.4
	$UI.add_child(fade_inst)


func _on_avoidance_restart() -> void:
	_spawn_transition(false)

func _on_goto_menu() -> void:
	_spawn_transition(true)


func _on_transition_finished(back_to_menu: bool) -> void:
	Engine.time_scale = 1.0
	var mus_bus := SoundManager.get_default_music_bus()
	AudioServer.set_bus_effect_enabled(mus_bus, 0, false)
	if back_to_menu:
		get_tree().change_scene_to(Globals.MAIN_MENU)
	else:
		get_tree().reload_current_scene()


func _on_Player_all_abilities_expired() -> void:
	ability_border_fx.fade_out()


func _on_Player_ability_expired(ability) -> void:
	ability_border_fx.disable_effect(ability)
