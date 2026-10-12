@tool
extends EditorPlugin

const SETTING_PATH: String = "fight_engine/config/"

const COLLISION_BOX_3D_GIZMO = preload("res://addons/fightengine/nodes/3d/collision_box_3d_gizmo.gd")

var collision_box_3d_gizmo: EditorNode3DGizmoPlugin


func _add_nodes() -> void:
	add_custom_type("CollisionBox2D", "Node2D", preload("res://addons/fightengine/nodes/2d/collision_box_2d.gd"), preload("res://addons/fightengine/icons/at-icons/2d/box_wireframe.svg"))
	add_custom_type("HitBox2D", "CollisionBox2D", preload("res://addons/fightengine/nodes/2d/hit_box_2d.gd"), preload("res://addons/fightengine/icons/at-icons/2d/box.svg"))
	add_custom_type("HurtBox2D", "CollisionBox2D", preload("res://addons/fightengine/nodes/2d/hurt_box_2d.gd"), preload("res://addons/fightengine/icons/at-icons/2d/box.svg"))
	
	add_custom_type("CollisionBox3D", "Node3D", preload("res://addons/fightengine/nodes/3d/collision_box_3d.gd"), preload("res://addons/fightengine/icons/at-icons/3d/box_wireframe.svg"))
	add_custom_type("HitBox3D", "CollisionBox3D", preload("res://addons/fightengine/nodes/3d/hit_box_3d.gd"), preload("res://addons/fightengine/icons/at-icons/3d/box.svg"))
	add_custom_type("HurtBox3D", "CollisionBox3D", preload("res://addons/fightengine/nodes/3d/hurt_box_3d.gd"), preload("res://addons/fightengine/icons/at-icons/3d/box.svg"))

func _remove_nodes() -> void:
	remove_custom_type("CollisionBox2D")
	remove_custom_type("HitBox2D")
	remove_custom_type("HurtBox2D")

func _enter_tree() -> void:
	_add_setting("tick_rate", 20,
		"Amount of collision ticks a second. Higher tickrates will create more precise collision at a higher process cost."
	)
	
	_add_nodes()
	
	add_autoload_singleton("TickManager", "res://addons/fightengine/core/tick_manager.gd")
	
	collision_box_3d_gizmo = COLLISION_BOX_3D_GIZMO.new()
	add_node_3d_gizmo_plugin(collision_box_3d_gizmo)

func _exit_tree() -> void:
	_remove_nodes.call_deferred()
	
	remove_autoload_singleton("TickManager")
	
	_remove_setting("tick_rate")
	
	remove_node_3d_gizmo_plugin(collision_box_3d_gizmo)

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
