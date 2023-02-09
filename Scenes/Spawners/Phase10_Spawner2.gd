extends Spatial

const SPIKEY_TUBE := preload("res://Scenes/Tutorial/Tutorial_Atk1.tscn")

export var roll_speed := 30.0

var wave_dur := 0.6
var wave := 0
var finishing_wave = 3
var center_offset := 30.0
var lifetime := 1.2
onready var next_wave: Timer = $NextWave


func _ready() -> void:
	EventBus.connect("avoidance_ended", self, "_on_avoidance_ended")


func start() -> void:
	wave = 0
	rotation_degrees.y = Util.choose([180.0, 90.0, 0.0])
	spawn_next_wave()


func spawn_next_wave() -> void:
	if wave < finishing_wave:
		next_wave.start(wave_dur)
		match wave:
			0:
				var tube1 := SPIKEY_TUBE.instance()
				tube1.translation = Vector3(-center_offset, 2.0, 0.0)
				tube1.speed = Vector3(roll_speed, 0, 0)
				tube1.lifetime = lifetime
				var tube2 := SPIKEY_TUBE.instance()
				tube2.translation = Vector3(center_offset, 2.0, 0.0)
				tube2.speed = Vector3(-roll_speed, 0, 0)
				tube2.lifetime = lifetime
				add_child(tube1)
				add_child(tube2)
			1:
				var tube1 := SPIKEY_TUBE.instance()
				tube1.translation = Vector3(0.0, 2.0, -center_offset)
				tube1.speed = Vector3(0, 0, roll_speed)
				tube1.rotation_degrees.y = -90
				tube1.lifetime = lifetime
				var tube2 := SPIKEY_TUBE.instance()
				tube2.translation = Vector3(0.0, 2.0, center_offset)
				tube2.speed = Vector3(0, 0, -roll_speed)
				tube2.rotation_degrees.y = 90
				tube2.lifetime = lifetime
				add_child(tube1)
				add_child(tube2)
			2:
				var tube1 := SPIKEY_TUBE.instance()
				tube1.translation = Vector3(-center_offset, 2.0, 0.0)
				tube1.speed = Vector3(roll_speed, 0, 0)
				tube1.lifetime = lifetime
				var tube2 := SPIKEY_TUBE.instance()
				tube2.translation = Vector3(-center_offset, 6.0, 0.0)
				tube2.speed = Vector3(roll_speed*.66, 0, 0)
				tube2.lifetime = lifetime
				var tube3 := SPIKEY_TUBE.instance()
				tube3.translation = Vector3(-center_offset, 10.0, 0.0)
				tube3.speed = Vector3(roll_speed*.33, 0, 0)
				tube3.lifetime = lifetime
				add_child(tube1)
				add_child(tube2)
				add_child(tube3)
		wave += 1
	else:
		EventBus.emit_signal("tutorial_phase_finished", 2)


func _on_avoidance_ended() -> void:
	next_wave.stop()


func _on_NextWave_timeout() -> void:
	spawn_next_wave()
