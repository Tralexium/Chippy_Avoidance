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
		scale.y = starting_scale
		var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
		tween.tween_property(self, "opacity", 0.5, 1.0)
		tween.tween_property(self, "scale:x", starting_scale/2.0, 1.0)
		tween.tween_property(self, "scale:y", starting_scale/2.0, 1.0)
		tween.set_trans(Tween.TRANS_LINEAR).tween_property(self, "rotation:y", PI * warning_dur, warning_dur-0.25)
		tween.set_parallel(false).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK).tween_property(self, "opacity", 0.0, 0.25)
		tween.set_parallel(true).tween_property(self, "scale:x", 0.0, 0.25)
		tween.tween_property(self, "scale:y", 0.0, 0.25)
		tween.tween_callback(self, "queue_free").set_delay(0.25)
	
	elapsed_time += delta
	var blink_rate : float = lerp(max_blinking_rate, min_blinking_rate, warning_dur - elapsed_time)
	var blink_amnt := sin(elapsed_time * blink_rate) * blink_strength
	modulate = color + Color(blink_amnt, blink_amnt, blink_amnt)
