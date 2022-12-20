extends Spatial

export var phase_time_stamps := [0.0, 10.2, 24.5, 32.8, 43.0, 52.5, 63.5, 82.44]

var current_phase := 0
onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
onready var timeline: AnimationPlayer = $Timeline
onready var player: KinematicBody = $Player
onready var cam_path: Path = $CamPath


func _process(delta: float) -> void:
	if !Globals.debug_mode:
		return
	if Input.is_action_just_pressed("dev_skip_phase_up"):
		fast_forward_phase(1)
	if Input.is_action_just_pressed("dev_skip_phase_down"):
		fast_forward_phase(-1)


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
