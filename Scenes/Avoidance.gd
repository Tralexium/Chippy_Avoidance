extends Spatial

const EYE_BLINK := preload("res://Scenes/Universal/EyeBlinkTransition.tscn")
const STATS_MENUS := preload("res://Scenes/UI/StatsScreen.tscn")
const CIRCLE_TRANSITION := preload("res://Scenes/Universal/CircleTransition.tscn")

export var phase_time_stamps := [0.0, 10.2, 24.5, 32.8, 43.0, 52.5, 63.5, 82.44]

var current_phase := 0
var audio_stream_player: AudioStreamPlayer
var currently_restarting := false
onready var timeline: AnimationPlayer = $Timeline
onready var player: KinematicBody = $Player
onready var cam_path: Path = $CamPath


func _init() -> void:
	spawn_blink_overlay(1.25, true)


func _ready() -> void:
	Globals.can_pause = true
	Globals.reset_run_stats()
	EventBus.emit_signal("avoidance_started")
	EventBus.connect("hp_changed", self, "_on_damage_taken")
	EventBus.connect("ability_used", self, "_on_ability_used")
	EventBus.connect("avoidance_ended", self, "_on_avoidance_ended")
	EventBus.connect("avoidance_restart", self, "_on_avoidance_restart")
	var mus_bus := SoundManager.get_default_music_bus()
	AudioServer.set_bus_effect_enabled(mus_bus, 0, false)
	audio_stream_player = SoundManager.play_music(Globals.AVOIDANCE_MUSIC, 0.0, "Music")
	audio_stream_player.seek(0.0)
	audio_stream_player.pitch_scale = 1.0


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to(Globals.MAIN_MENU)
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
	var event : int = Globals.TIMELINE_EVENTS.DAMAGE if new_hp > 1 else Globals.TIMELINE_EVENTS.DEATH
	var song_position := audio_stream_player.get_playback_position()
	var unit_position := song_position / audio_stream_player.stream.get_length()
	Globals.timeline_events.push_back([event, unit_position])


func _on_ability_used(ability_num: int) -> void:
	var song_position := audio_stream_player.get_playback_position()
	var unit_position := song_position / audio_stream_player.stream.get_length()
	Globals.timeline_events.push_back([ability_num, unit_position])


func _on_avoidance_ended() -> void:
	var song_position := audio_stream_player.get_playback_position()
	var unit_position := song_position / audio_stream_player.stream.get_length()
	timeline.stop()
	var mus_bus := SoundManager.get_default_music_bus()
	AudioServer.set_bus_effect_enabled(mus_bus, 0, true)
	SoundManager.music.fade_volume(audio_stream_player, 0, -15, 1.0)
	Globals.can_pause = false
	Globals.run_stats["survival_time"] = song_position
	Globals.run_stats["unit_survival_time"] = unit_position
	var stats_ui := STATS_MENUS.instance()
	$CanvasLayer.add_child(stats_ui)


func _on_avoidance_restart() -> void:
	currently_restarting = true
	create_tween().tween_property(audio_stream_player, "pitch_scale", 0.01, 0.5)
	var transition_inst := CIRCLE_TRANSITION.instance()
	transition_inst.connect("tree_exited", self, "_on_transition_finished")
	add_child(transition_inst)


func _on_transition_finished() -> void:
	get_tree().reload_current_scene()
