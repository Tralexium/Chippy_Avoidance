extends VBoxContainer

onready var time_label: Label = $TotalTime/Label
onready var deaths_label: Label = $Deaths/Label


func _ready() -> void:
	time_label.text = Util.time_convert(round(Config.total_play_time))
	deaths_label.text = str(Config.total_deaths)
