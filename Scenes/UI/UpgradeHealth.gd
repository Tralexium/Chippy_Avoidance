extends HBoxContainer

const BAR := preload("res://Scenes/UI/UpgradeHPBar.tscn")
const UPGRADE_SFX := preload("res://Audio/SFX/bought_upgrade.wav")

var active_bars := 0
onready var health_bars_container: HBoxContainer = $BlackBar/HealthBars
onready var upgrade_button: Button = $Upgrade
onready var gem_cost: HBoxContainer = $GemCost


func _ready() -> void:
	var i := 0
	active_bars = Config.player_max_hp
	gem_cost.cost(Config.hp_costs[active_bars])
	if active_bars == Config.MAX_HP:
		_max_hp()
	for bar in range(Config.MAX_HP):
		var bar_inst := BAR.instance()
		if i < active_bars:
			bar_inst.self_modulate = Color("ff2558")
		elif i == active_bars:
			bar_inst.hightlight_bar = true
		i += 1
		health_bars_container.add_child(bar_inst)


func _max_hp() -> void:
	upgrade_button.disabled = true
	upgrade_button.text = "MAX HP"
	gem_cost.hide()


func _on_Upgrade_pressed() -> void:
	if active_bars == Config.MAX_HP or Config.player_points < Config.hp_costs[active_bars]:
		SoundManager.play_ui_sound(Globals.UI_ERROR)
		InputHelper.rumble_small()
		return
	active_bars += 1
	Config.player_max_hp = active_bars
	Config.player_points -= Config.hp_costs[active_bars-1]
	Config.save_data()
	if active_bars == Config.MAX_HP:
		_max_hp()
		SoundManager.play_ui_sound(Globals.UI_SUCCESS)
	else:
		gem_cost.cost(Config.hp_costs[active_bars])
	health_bars_container.get_child(active_bars-1).enable()
	if active_bars < Config.MAX_HP:
		health_bars_container.get_child(active_bars).highlight()
	SoundManager.play_ui_sound(UPGRADE_SFX)
