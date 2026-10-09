## A collision box designed to receive hits from HitBox2D instances.
@tool
class_name HurtBox3D extends CollisionBox3D

## Emitted when this hurt box receives damage from a HitBox2D.
signal hurt(hit_box: HitBox3D)
## Emitted on every tick during active grace period.
signal grace_tick

## Number of grace ticks during which the hurt box remains invulnerable after taking a hit.
@export_range(-1, 100, 1, "hide_control", "suffix:ticks") var grace_ticks: int = -1:
	set(value):
		grace_ticks = value
		_grace_ticks_left = value

## Remaining duration of the invulnerability grace period in ticks.
var _grace_ticks_left: int = 0:
	set(value):
		_grace_ticks_left = value
		if value == 0:
			active = true

func _ready() -> void:
	super._ready()
	_grace_ticks_left = grace_ticks
	collider.debug_color = Color(0.0, 1.0, 0.0, 0.42)

func _tick() -> void:
	if _grace_ticks_left > 0:
		grace_tick.emit()
		_grace_ticks_left -= 1
	
	super._tick()

func _on_collision(box: CollisionBox3D):
	if box is not HitBox3D: return
	_collisions_left -= 1
	
	hurt.emit(box)
	if grace_ticks > 0:
		_grace_ticks_left = grace_ticks
		active = false
