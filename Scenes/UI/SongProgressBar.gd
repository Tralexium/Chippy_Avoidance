extends HBoxContainer

export var duration := 136.0

onready var progress_bar: ProgressBar = $ProgressBar
onready var percent: Label = $Percent


func _ready() -> void:
	visible = Config.show_bar
	percent.visible = Config.show_percentage
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", 100.0, duration)


func _process(delta: float) -> void:
	if percent.visible:
		percent.text = str(round(progress_bar.value)) + "%"
