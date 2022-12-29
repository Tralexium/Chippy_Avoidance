extends VBoxContainer

const TIMELINE_EVENT := preload("res://Scenes/UI/TimelineEvent.tscn")

export(Array) var events := [] 
export var progress := 60.0

var events_shown := 0
onready var event_reveal: Timer = $EventReveal
onready var bar: ProgressBar = $Bar


func introduce_events() -> void:
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(bar, "value", progress, 0.5)
	event_reveal.start()


func _on_EventReveal_timeout() -> void:
	if events_shown < events.size():
		var event_inst := TIMELINE_EVENT.instance()
		event_inst.event = events[events_shown][0]
		event_inst.unit_progress = events[events_shown][1]
		event_inst.bar_length = rect_size.x
		events_shown += 1
		$Events.add_child(event_inst)
	else:
		event_reveal.stop()
