extends StaticBody

const TAIL := preload("res://Scenes/Building Blocks/WigglyRect.tscn")

export var tail_length := 5
export var tail_gap := Vector3(0.0, -0.25, 0.0)
export var wiggle_sep := 0.2
export var tail_scale_incr := -0.15
export var tail_start_scale := 0.8

onready var bottom: Position3D = $Bottom


func _ready() -> void:
	var tail_scale := tail_start_scale
	var start_delay := wiggle_sep
	var pos := tail_gap
	for tail_bit in range(tail_length):
		var tail_inst := TAIL.instance()
		tail_inst.translation = pos
		tail_inst.scale = Vector3(tail_scale, 1.0, tail_scale)
		tail_inst.start_delay = start_delay
		pos += tail_gap
		tail_scale += tail_scale_incr
		start_delay += wiggle_sep
		bottom.add_child(tail_inst)
