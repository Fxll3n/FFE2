extends Node

@onready var tickrate: int = ProjectSettings.get_setting("fight_engine/config/tick_rate")

var active_boxes: Array[CollisionBox2D] = []

var _tick_time: float = 0.0
var _tick_timer: float = 0.0

var _debug_draw_node: Node2D = null
var _debug_show_boxes: bool = false:
	set(value):
		_debug_show_boxes = value
		_update_debug_node_state()

func _ready() -> void:
	_tick_time = _convert_rate_to_seconds(tickrate)
	
	get_tree().node_added.connect(_on_node_added)
	get_tree().node_removed.connect(_on_node_removed)

func _process(delta: float) -> void:
	_tick_timer += delta
	# switched to a `while` so that ticks can catchup after a large lag or etc.
	while _tick_timer >= _tick_time: 
		_tick()
		_tick_timer -= _tick_time
	
	# Force redraw every frame so moving boxes update their visual position
	if _debug_show_boxes and is_instance_valid(_debug_draw_node):
		_debug_draw_node.queue_redraw()

func _tick() -> void:
	for box: CollisionBox2D in active_boxes:
		box._tick()
		box._intersect()

func register_box(box: CollisionBox2D) -> void:
	if box == null or active_boxes.has(box): return
	active_boxes.insert(0, box)

func unregister_box(box: CollisionBox2D) -> void:
	if box == null or not active_boxes.has(box): return
	active_boxes.erase(box)

func _update_debug_node_state() -> void:
	if _debug_show_boxes:
		if _debug_draw_node == null:
			_debug_draw_node = Node2D.new()
			_debug_draw_node.draw.connect(_on_debug_draw)
			add_child(_debug_draw_node)
			_debug_draw_node.z_index = 100
	elif is_instance_valid(_debug_draw_node):
		_debug_draw_node.queue_free()
		_debug_draw_node = null

func _on_debug_draw() -> void:
	if not _debug_draw_node:
		return
	
	for box in active_boxes:
		if not is_instance_valid(box) or not box.is_inside_tree() or box.shape == null:
			continue
	
		var points := _get_shape_points(box.shape)
		if points.is_empty():
			continue
	
		var color: Color = Color.GREEN
		if box.collider:
			color = box.collider.debug_color
	
		_debug_draw_node.draw_set_transform(box.global_position, box.global_rotation, box.global_scale)
	
		if box.shape is ConcavePolygonShape2D:
			_debug_draw_node.draw_multiline(points, color, 4.0)
		else:
			_debug_draw_node.draw_polygon(points, [color])
	
	_debug_draw_node.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _convert_rate_to_seconds(rate: int) -> float: return 1.0 / float(rate) if rate > 0 else 0.016
func _convert_seconds_to_rate(seconds: float) -> int: return int(1.0 / seconds) if seconds > 0 else 60

func _on_node_added(node: Node) -> void:
	if node is CollisionBox2D:
		register_box(node)

func _on_node_removed(node: Node) -> void:
	if node is CollisionBox2D:
		unregister_box(node)

### Shape2D to PackedVector2Arrat conversion function.
func _get_shape_points(shape: Shape2D, steps: int = 32) -> PackedVector2Array:
	var points := PackedVector2Array()
	
	if shape is RectangleShape2D:
		var half := (shape as RectangleShape2D).size / 2.0
		points = PackedVector2Array([
			Vector2(-half.x, -half.y), Vector2(half.x, -half.y),
			Vector2(half.x, half.y),   Vector2(-half.x, half.y),
			Vector2(-half.x, -half.y)
		])
	
	elif shape is CircleShape2D:
		var radius := (shape as CircleShape2D).radius
		for i in range(steps + 1):
			var angle := (float(i) / steps) * TAU
			points.append(Vector2(cos(angle), sin(angle)) * radius)
	
	elif shape is CapsuleShape2D:
		var capsule := shape as CapsuleShape2D
		var r := capsule.radius
		var half_h := maxf(0.0, (capsule.height / 2.0) - r)
	
		for i in range(steps / 2 + 1):
			var a := PI + (float(i) / (steps / 2)) * PI
			points.append(Vector2(0, -half_h) + Vector2(cos(a), sin(a)) * r)
		for i in range(steps / 2 + 1):
			var a := (float(i) / (steps / 2)) * PI
			points.append(Vector2(0, half_h) + Vector2(cos(a), sin(a)) * r)
		points.append(points[0])
	
	elif shape is ConvexPolygonShape2D:
		points = (shape as ConvexPolygonShape2D).points.duplicate()
	
	elif shape is ConcavePolygonShape2D:
		points = (shape as ConcavePolygonShape2D).segments
	
	elif shape is SegmentShape2D:
		var seg := shape as SegmentShape2D
		points = PackedVector2Array([seg.a, seg.b])
	
	return points
