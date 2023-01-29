extends Spatial

const WALL_ATK := preload("res://Scenes/Tutorial/Tutorial_Atk2.tscn")

export var wave_dur := 1.5
var wave := 0
var finishing_wave = 8
var center_offset := 22.0
onready var next_wave: Timer = $NextWave


func _ready() -> void:
	EventBus.connect("avoidance_ended", self, "_on_avoidance_ended")


func start() -> void:
	wave = 0
	next_wave.start(1.0)


func _spawn_wave(speed: float, x_pos: float, gap: int) -> void:
	var wall_inst := WALL_ATK.instance()
	wall_inst.speed = Vector3(speed, 0.0, 0.0)
	wall_inst.translation = Vector3(x_pos, 0.0, 0.0)
	wall_inst.gap = gap
	add_child(wall_inst)


func spawn_next_wave() -> void:
	if wave < finishing_wave:
		var gap = 3 if wave <= 4 else 2
		if wave == finishing_wave-1:
			_spawn_wave(20, -12, gap)
			_spawn_wave(-20, 12, gap)
			next_wave.start(wave_dur + 1.0)
		else:
			next_wave.start(wave_dur)
			if wave % 2 == 0:
				_spawn_wave(20, -12, gap)
			else:
				_spawn_wave(-20, 12, gap)
		wave += 1
	else:
		EventBus.emit_signal("tutorial_phase_finished", 4)


func _on_avoidance_ended() -> void:
	next_wave.stop()


func _on_NextWave_timeout() -> void:
	spawn_next_wave()
