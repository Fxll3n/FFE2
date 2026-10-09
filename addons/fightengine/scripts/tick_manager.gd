extends Node

@onready var tickrate: int = ProjectSettings.get_setting("fight_engine/config/tick_rate")

var active_boxes: Array[Node] = []

var _tick_time: float = 0.0
var _tick_timer: float = 0.0


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


func _tick() -> void:
	for box in active_boxes:
		box._tick()
		box._intersect()

func register_box(box: Node) -> void:
	if box is not CollisionBox2D or box is not CollisionBox3D: return
	if box == null or active_boxes.has(box): return
	active_boxes.insert(0, box)

func unregister_box(box: Node) -> void:
	if box is not CollisionBox2D or box is not CollisionBox3D: return
	if box == null or not active_boxes.has(box): return
	active_boxes.erase(box)

func _convert_rate_to_seconds(rate: int) -> float: return 1.0 / float(rate) if rate > 0 else 0.016
func _convert_seconds_to_rate(seconds: float) -> int: return int(1.0 / seconds) if seconds > 0 else 60

func _on_node_added(node: Node) -> void:
	if node is CollisionBox2D:
		register_box(node)

func _on_node_removed(node: Node) -> void:
	if node is CollisionBox2D:
		unregister_box(node)
