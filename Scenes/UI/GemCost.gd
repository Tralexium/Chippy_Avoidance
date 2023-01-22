extends HBoxContainer

onready var label: Label = $Label


func cost(new_cost: int) -> void:
	label.text = str(new_cost)
