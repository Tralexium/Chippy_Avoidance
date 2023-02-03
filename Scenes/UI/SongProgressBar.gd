extends HBoxContainer

export var duration := 136.0

var tween : SceneTreeTween
onready var progress_bar: ProgressBar = $ProgressBar
onready var percent: Label = $Percent


func _ready() -> void:
	EventBus.connect("avoidance_ended", self, "_on_avoidance_ended")
	visible = Config.show_bar and !Globals.in_tutorial
	percent.visible = Config.show_percentage
	tween = create_tween().set_parallel()
	tween.tween_property(progress_bar, "value", 100.0, duration)


func _process(delta: float) -> void:
	if percent.visible:
		percent.text = str(round(progress_bar.value)) + "%"


func _on_avoidance_ended() -> void:
	tween.stop()
