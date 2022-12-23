extends Label

func _ready() -> void:
	Config.connect("show_fps_changed", self, "_on_show_fps_changed")


func _process(delta: float) -> void:
	text = str(round(Engine.get_frames_per_second())) + "fps"


func _on_show_fps_changed(value: bool) -> void:
	visible = value
