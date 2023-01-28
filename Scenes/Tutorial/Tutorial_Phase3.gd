extends Spatial

const SPIKEY_TUBE := preload("res://Scenes/Tutorial/Tutorial_Atk1.tscn")

var wave := 0
var finishing_wave = 3
var center_offset := 22.0
onready var next_wave: Timer = $NextWave


func _ready() -> void:
	EventBus.connect("avoidance_ended", self, "_on_avoidance_ended")


func start() -> void:
	wave = 0
	spawn_next_wave()


func spawn_next_wave() -> void:
	if wave < finishing_wave:
		next_wave.start()
		match wave:
			0:
				var tube1 := SPIKEY_TUBE.instance()
				tube1.translation = Vector3(-center_offset, 1.0, -center_offset/2)
				tube1.target_scale = 0.5
				var tube2 := SPIKEY_TUBE.instance()
				tube2.translation = Vector3(-center_offset, 1.0, center_offset/2)
				tube2.target_scale = 0.5
				add_child(tube1)
				add_child(tube2)
			1:
				var tube1 := SPIKEY_TUBE.instance()
				tube1.translation = Vector3(center_offset, 1.0, -center_offset/2)
				tube1.speed.x *= -1
				tube1.target_scale = 0.5
				var tube2 := SPIKEY_TUBE.instance()
				tube2.translation = Vector3(center_offset, 1.0, center_offset/2)
				tube2.speed.x *= -1
				tube2.target_scale = 0.5
				add_child(tube1)
				add_child(tube2)
			2:
				var tube1 := SPIKEY_TUBE.instance()
				tube1.translation = Vector3(0.0, 2.0, -center_offset)
				tube1.speed = Vector3(0, 0, 12)
				tube1.rotation_degrees.y = -90
				add_child(tube1)
		wave += 1
	else:
		EventBus.emit_signal("tutorial_phase_finished", 2)


func _on_avoidance_ended() -> void:
	next_wave.stop()


func _on_NextWave_timeout() -> void:
	spawn_next_wave()
