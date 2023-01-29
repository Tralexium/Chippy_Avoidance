extends Spatial

const SPIKEY_TUBE := preload("res://Scenes/Tutorial/Tutorial_Atk1.tscn")
const COIN := preload("res://Scenes/Coin.tscn")

var wave_dur := 4.0

var coins_collected := 0
var coins_required := 4
var center_offset := 22.0
var coin_positions := [
	Vector3(-9, 5, -9), 
	Vector3(9, 5, 9), 
	Vector3(9, 5, -9), 
	Vector3(-9, 5, 9),
]
onready var next_wave: Timer = $NextWave


func _ready() -> void:
	EventBus.connect("avoidance_ended", self, "_on_avoidance_ended")
	EventBus.connect("coin_collected", self, "_on_coin_collected")


func start() -> void:
	coins_collected = 0
	next_wave.start()
	_spawn_coin()


func _spawn_coin() -> void:
	var coin := COIN.instance()
	coin.translation = coin_positions[coins_collected]
	add_child(coin)


func _on_avoidance_ended() -> void:
	next_wave.stop()


func _on_coin_collected() -> void:
	coins_collected += 1
	if coins_collected == coins_required:
		next_wave.stop()
		for tube in get_children():
			if tube.is_in_group("hazard"):
				tube.shrink()
		EventBus.emit_signal("tutorial_phase_finished", 5)
	else:
		_spawn_coin()


func _on_NextWave_timeout() -> void:
	var tube1 := SPIKEY_TUBE.instance()
	tube1.translation = Vector3(-center_offset, 1.0, -center_offset/2)
	tube1.target_scale = 0.5
	var tube2 := SPIKEY_TUBE.instance()
	tube2.translation = Vector3(center_offset, 1.0, center_offset/2)
	tube2.target_scale = 0.5
	tube2.speed.x *= -1
	add_child(tube1)
	add_child(tube2)
