extends HBoxContainer

onready var label: Label = $Label


func _ready() -> void:
	EventBus.connect("points_changed", self, "_on_points_changed")
	label.text = str(Config.player_points)


func _on_points_changed(new_points: int) -> void:
	label.text = str(new_points)
