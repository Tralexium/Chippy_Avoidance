extends Node
# This static class holds any utility functions that are useful to have globally


# Wrapper for call_group_flags(tree.GROUP_CALL_REALTIME, groupName, funcName)
func call_group(groupName: String, funcName: String) -> void:
	var tree := get_tree()
	tree.call_group_flags(tree.GROUP_CALL_REALTIME, groupName, funcName)

func get_camera() -> Camera2D:
	var tree := get_tree()
	return tree.current_scene.find_node("PlayerController").get_node("Camera") as Camera2D

func get_view_position() -> Vector2:
	return get_camera().get_camera_screen_center() - get_viewport().get_visible_rect().size / 2

func choose(items: Array):
	return items[randi() % items.size()]

func time_slowdown(time_scale: float, duration: float) -> void:
	Engine.time_scale = time_scale
	yield(get_tree().create_timer(time_scale * duration), "timeout")
	Engine.time_scale = 1.0
