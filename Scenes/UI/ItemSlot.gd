extends Panel

const JUMP := preload("res://Assets/UI/jump_item.png")
const SPEED := preload("res://Assets/UI/speed_item.png")
const SLOMO := preload("res://Assets/UI/slowmo_item.png")
const SHIELD := preload("res://Assets/UI/shield_item.png")


export(Config.ABILITIES) var ability: int
export var reload_dur := 10.0

var initial_color : Color
onready var action := "item " + str(ability+1)
onready var icon: TextureRect = $Icon
onready var amount: Label = $Amount
onready var particles: Particles2D = $Particles
onready var button_icon: TextureRect = $ButtonIcon
onready var circle_reload: TextureProgress = $CircleReload


func _ready() -> void:
	var ability_count : int = Config.player_current_abilities[ability]
	amount.text = str(ability_count)
	if Config.infinite_items:
		amount.visible = false
	elif ability_count == 0:
		circle_reload.value = 100.0
		button_icon.visible = false
	match ability:
		Config.ABILITIES.MEGA_JUMP:
			icon.texture = JUMP
			icon.modulate = Color("f82c57")
		Config.ABILITIES.SUPER_SPEED:
			icon.texture = SPEED
			icon.modulate = Color("f8d82c")
		Config.ABILITIES.SLO_MO:
			icon.texture = SLOMO
			icon.modulate = Color("2cf894")
		Config.ABILITIES.SHIELD:
			icon.texture = SHIELD
			icon.modulate = Color("2cb5f8")
	if ability_count == 0:
		icon.modulate = Color.white
	initial_color = icon.modulate
	amount.modulate = icon.modulate
	var mat := particles.process_material as ParticlesMaterial
	mat.color = icon.modulate
	_update_button_icon(InputHelper.has_gamepad())


func _unhandled_input(event: InputEvent) -> void:
	if not Globals.can_pause:
		return
	if event is InputEventKey and event.is_pressed():
		_update_button_icon(false)
	elif event is InputEventJoypadButton and event.is_pressed():
		_update_button_icon(true)
	
	if event.is_action_pressed(action) and (Config.player_current_abilities[ability] > 0 or Config.infinite_items) and circle_reload.value == 0.0:
		Config.set_player_ability_count(ability, true)
		Globals.run_stats["items_used"] += 1
		_flash_effect()


func _flash_effect() -> void:
	var ability_count : int = Config.player_current_abilities[ability]
	icon.modulate = Color.white
	amount.modulate = Color.white
	amount.text = str(ability_count)
	circle_reload.value = 100.0
	button_icon.visible = false
	particles.emitting = true
	if ability_count > 0 or Config.infinite_items:
		var tween := create_tween().set_parallel()
		tween.tween_property(icon, "modulate", initial_color, reload_dur)
		tween.tween_property(amount, "modulate", initial_color, reload_dur)
		tween.tween_property(circle_reload, "value", 0.0, reload_dur)


func _update_button_icon(has_gamepad: bool = false) -> void:
	var icon_texture : StreamTexture
	var current_device := InputHelper.guess_device_name()
	if not has_gamepad or current_device == InputHelper.DEVICE_KEYBOARD:
		var key := InputHelper.get_action_key(action)
		icon_texture = load("res://Assets/Controller & Key Prompts/Keyboard/" + key + "_Key_Light.png")
	elif current_device == InputHelper.DEVICE_PLAYSTATION_CONTROLLER:
		var button := InputHelper.get_action_button(action)
		icon_texture = InputHelper.SONY_GAMEPAD_TEXTURES[button]
	button_icon.texture = icon_texture


func _on_CircleReload_value_changed(value: float) -> void:
	if value == 0.0:
		button_icon.visible = true
