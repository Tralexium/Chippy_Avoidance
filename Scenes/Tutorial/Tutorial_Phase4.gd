extends Spatial

export var wave_dur := 3.5

var wave := 0
var finishing_wave = 3
var center_offset := 22.0
onready var next_wave: Timer = $NextWave
onready var spawner: Spatial = $Phase1_Spawner2


func _ready() -> void:
	EventBus.connect("avoidance_ended", self, "_on_avoidance_ended")


func start() -> void:
	wave = 0
	next_wave.start(1.0)


func spawn_next_wave() -> void:
	if wave < finishing_wave:
		next_wave.start(wave_dur)
		match wave:
			0:
				spawner.spawn_orb_ring(-30, 15)
			1:
				spawner.spawn_orb_ring(30, -15)
			2:
				spawner.spawn_orb_ring(30, -15)
				spawner.spawn_orb_ring(-30, 15)
		wave += 1
	else:
		EventBus.emit_signal("tutorial_phase_finished", 3)


func _on_avoidance_ended() -> void:
	next_wave.stop()


func _on_NextWave_timeout() -> void:
	spawn_next_wave()
