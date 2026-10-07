## Abstract base class for 2D collision detection boxes using custom physics query ticks.
@tool
@abstract
class_name CollisionBox2D extends Node2D

## Internal Area2D node used for physics spatial query state.
@onready var area: Area2D = Area2D.new()

## Internal CollisionShape2D node defining the collision bounds.
@onready var collider: CollisionShape2D = CollisionShape2D.new()

## Determines whether this collision box is currently active and processing collisions.
@export var active: bool = false

## Lifetime of the collision box in ticks. Set to -1 for unlimited.
@export_range(-1, 100, 1,"hide_control", "suffix:ticks") var lifetime: int = -1:
	set(value):
		lifetime = value
		_tick_counter = value

## Maximum number of collisions allowed. Set to -1 for unlimited.
@export_range(-1, 100, 1,"hide_control") var max_collisions: int = -1:
	set(value):
		max_collisions = value
		_collisions_left = value

## The 2D shape used for physics collision queries.
@export var shape: Shape2D:
	set(value):
		shape = value
		if collider == null: return
		collider.shape = value

## The physics collision layer this box belongs to.
@export_flags_2d_physics var collision_layer: int = 1:
	set(value):
		collision_layer = value
		area.collision_layer = value

## The physics collision mask this box scans.
@export_flags_2d_physics var collision_mask: int = 1:
	set(value):
		collision_mask = value
		area.collision_mask = value

## Counter for remaining active ticks.
var _tick_counter: int = -1:
	set(value):
		_tick_counter = value
		if value == 0:
			active = false

## Counter for remaining allowed collisions.
var _collisions_left: int = -1:
	set(value):
		_collisions_left = value
		if value == 0:
			print("DISABLED")
			active = false

## Initializes area and collider children and configures initial tick delay.
func _ready() -> void:
	area.collision_layer = collision_layer
	area.collision_mask = collision_mask
	
	add_child(area)
	area.add_child(collider)
	collider.debug_color = Color(0.0, 0.0, 0.0, 0.42)
	collider.shape = shape

func _enter_tree() -> void:
	TickManager.register_box(self)

func _exit_tree() -> void:
	TickManager.unregister_box(self)

## Virtual callback when this Box is intersecting with another CollisionBox2D.
func _on_collision(box: CollisionBox2D) -> void:
	if _collisions_left > 0:
		_collisions_left -= 1

## Executes physics query and updates lifetime tick counter.
func _tick() -> void:
	_intersect()
	
	if _tick_counter > 0:
		_tick_counter -= 1

## Queries physics space for overlapping CollisionBox2D objects and processes intersections.
func _intersect() -> void:
	if not active or area == null or collider == null or shape == null:
		return
	
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = collider.global_transform
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = area.collision_mask
	query.exclude = [area.get_rid()]
	
	var intersections := area.get_world_2d().direct_space_state.intersect_shape(query)
	
	for i in intersections:
		var other_area := i["collider"] as Area2D
		
		if other_area == null:
			continue
		
		var other_box := other_area.get_parent() as CollisionBox2D
		if other_box == null:
			continue
		
		if not other_box.active: continue
		_on_collision(other_box)
