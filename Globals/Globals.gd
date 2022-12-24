extends Node

var debug_mode := true
var god_mode := false

const MAIN_MENU := preload("res://Scenes/UI/MainMenu.tscn")
const AVOIDANCE := preload("res://Scenes/Avoidance.tscn")


func _process(delta: float) -> void:
	if debug_mode and Input.is_action_just_pressed("quick restart"):
		start_avoidance()


func start_main_menu() -> void:
	var main_node := get_node("/root/Main")
	if main_node.has_node("MainMenu"):
		main_node.get_node("MainMenu").queue_free()
	main_node.add_child(MAIN_MENU.instance())


func start_avoidance() -> void:
	var main_node := get_node("/root/Main")
	if main_node.has_node("Avoidance"):
		main_node.get_node("Avoidance").queue_free()
	main_node.add_child(AVOIDANCE.instance())
