extends VBoxContainer

var event := 0
var unit_progress := 0.0
var bar_length := 0.0
onready var icon: TextureRect = $Icon


func _ready() -> void:
	rect_position.x = unit_progress * bar_length - rect_size.x/2
	var col := Color("ff2959")
	match event:
		Globals.TIMELINE_EVENTS.DEATH:
			icon.texture = load("res://Assets/UI/skull.png")
		Globals.TIMELINE_EVENTS.DAMAGE:
			icon.texture = load("res://Assets/UI/cross.png")
		Globals.TIMELINE_EVENTS.COIN:
			col = Color("f8d82c")
			icon.texture = load("res://Assets/UI/coin_small.png")
		Globals.TIMELINE_EVENTS.ITEM_1:
			col = Color("f8d82c")
			icon.texture = load("res://Assets/UI/speed_item.png")
		Globals.TIMELINE_EVENTS.ITEM_2:
			icon.texture = load("res://Assets/UI/jump_item.png")
		Globals.TIMELINE_EVENTS.ITEM_3:
			col = Color("52f3ff")
			icon.texture = load("res://Assets/UI/shield_item.png")
		Globals.TIMELINE_EVENTS.ITEM_4:
			col = Color("2cf894")
			icon.texture = load("res://Assets/UI/slowmo_item.png")
	icon.modulate = col
