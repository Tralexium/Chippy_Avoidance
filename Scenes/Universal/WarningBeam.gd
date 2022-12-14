extends Sprite3D

export var warning_dur := 2.0
export var starting_scale := 4.0
export var color := Color("ff4646")
export var blink_strength := 0.1

var min_blinking_rate := 10.0
var max_blinking_rate := 20.0
var elapsed_time := 0.0
var initialized := false


func _ready() -> void:
	opacity = 0.0


func _process(delta: float) -> void:
	if !initialized:
		initialized = true
		scale.x = starting_scale
		var tween := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT).set_parallel()
		tween.tween_property(self, "opacity", 0.6, warning_dur)
		tween.tween_property(self, "scale:x", 0.0, warning_dur)
	
	elapsed_time += delta
	var blink_rate : float = lerp(max_blinking_rate, min_blinking_rate, warning_dur - elapsed_time)
	var blink_amnt := sin(elapsed_time * blink_rate) * blink_strength
	modulate = color + Color(blink_amnt, blink_amnt, blink_amnt)
