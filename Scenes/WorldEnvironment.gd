extends WorldEnvironment


func _ready() -> void:
	Config.connect("bloom_changed", self, "_on_bloom_changed")


func _on_bloom_changed(is_active: bool) -> void:
	environment.glow_enabled = is_active
