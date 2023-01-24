extends HBoxContainer

const JUMP := preload("res://Assets/UI/jump_item.png")
const SPEED := preload("res://Assets/UI/speed_item.png")
const SLOMO := preload("res://Assets/UI/slowmo_item.png")
const SHIELD := preload("res://Assets/UI/shield_item.png")
const DOT := preload("res://Scenes/UI/ItemDot.tscn")
const SFX_ABILITY := preload("res://Audio/SFX/bought_ability.wav")

export var ability := 0

var active_dots := 0
onready var item_icon: TextureRect = $ItemIcon
onready var dots_container: HBoxContainer = $BlackBar/Dots
onready var gem_cost: HBoxContainer = $GemCost
onready var buy_button: Button = $Buy


func _ready() -> void:
	var i := 0
	active_dots = Config.player_current_abilities[ability]
	gem_cost.cost(Config.ability_costs[active_dots])
	for bar in range(Config.MAX_ABILITIES):
		var dot_inst := DOT.instance()
		if i < active_dots:
			dot_inst.self_modulate = Color.white
		elif i == active_dots:
			dot_inst.hightlight_bar = true
		i += 1
		dots_container.add_child(dot_inst)
	# Color / Icon
	match ability:
		Globals.ABILITIES.MEGA_JUMP:
			item_icon.texture = JUMP
			item_icon.modulate = Color("f82c57")
			buy_button.text += "Jump"
		Globals.ABILITIES.SUPER_SPEED:
			item_icon.texture = SPEED
			item_icon.modulate = Color("f8d82c")
			buy_button.text += "Speed"
		Globals.ABILITIES.SLO_MO:
			item_icon.texture = SLOMO
			item_icon.modulate = Color("2cf894")
			buy_button.text += "SloMo"
		Globals.ABILITIES.SHIELD:
			item_icon.texture = SHIELD
			item_icon.modulate = Color("2cb5f8")
			buy_button.text += "Shield"
	dots_container.modulate = item_icon.modulate
	if active_dots == Config.MAX_ABILITIES:
		_max_abilities()


func _max_abilities() -> void:
	buy_button.disabled = true
	buy_button.text = "FULL"
	gem_cost.hide()


func _on_Buy_pressed() -> void:
	if active_dots == Config.MAX_ABILITIES or Config.player_points < Config.ability_costs[active_dots]:
		SoundManager.play_ui_sound(Globals.UI_ERROR)
		return
	active_dots += 1
	Config.player_current_abilities[ability] = active_dots
	Config.player_points -= Config.ability_costs[active_dots-1]
	Config.save_data()
	if active_dots == Config.MAX_ABILITIES:
		_max_abilities()
		SoundManager.play_ui_sound(Globals.UI_SUCCESS)
	else:
		gem_cost.cost(Config.ability_costs[active_dots])
	dots_container.get_child(active_dots-1).enable()
	if active_dots < Config.MAX_ABILITIES:
		dots_container.get_child(active_dots).highlight()
	SoundManager.play_ui_sound(SFX_ABILITY)
