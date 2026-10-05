## A collision box designed to deliver hits to overlapping HurtBox2D instances.
@tool
class_name HitBox2D extends CollisionBox2D

## Emitted when this hit box successfully registers a hit on a HurtBox2D.
signal hit(hurt_box: HurtBox2D)

func _ready() -> void:
	super._ready()
	collider.debug_color = Color(1.0, 0.0, 0.0, 0.42)

func _on_collision(box: CollisionBox2D):
	if box is not HurtBox2D: return
	_collisions_left -= 1
	hit.emit(box)
