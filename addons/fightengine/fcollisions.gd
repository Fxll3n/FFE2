@tool
extends EditorPlugin

const SETTING_PATH: String = "fcollision/config/"

func _enable_plugin() -> void:
	add_custom_type("CollisionBox2D", "Node2D", preload("res://addons/fcollisions/scripts/collision_box.gd"), preload("res://addons/fcollisions/icon.png"))
	add_custom_type("HitBox2D", "CollisionBox2D", preload("res://addons/fcollisions/scripts/hit_box.gd"), preload("res://addons/fcollisions/icon.png"))
	add_custom_type("HurtBox2D", "CollisionBox2D", preload("res://addons/fcollisions/scripts/hurt_box.gd"), preload("res://addons/fcollisions/icon.png"))
	
	_add_setting("tick_rate", 20,
		"Amount of collision ticks a second. Higher tickrates will create more precise collision at a higher process cost."
	)
	

func _disable_plugin() -> void:
	remove_custom_type("CollisionBox2D")
	remove_custom_type("HitBox2D")
	remove_custom_type("HurtBox2D")
	
	_remove_setting("tick_rate")

func _add_setting(setting_key: String, value: Variant, hint_string: String = "", type: int = typeof(value), hint: int = PROPERTY_HINT_NONE) -> void:
	var id := SETTING_PATH + setting_key
	if not ProjectSettings.has_setting(id):
		ProjectSettings.set_setting(id, value)
		ProjectSettings.add_property_info(
			{
				"name": id,
				"type": type,
				"hint": hint,
				"hint_string": hint_string
			}
		)

func _remove_setting(setting_key: String) -> void:
	if ProjectSettings.has_setting(SETTING_PATH + setting_key):
		ProjectSettings.set_setting(SETTING_PATH + setting_key, null)
