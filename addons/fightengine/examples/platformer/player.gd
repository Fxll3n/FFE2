extends CharacterBody2D

@export var walk_speed: float = 300.0
@export var friction: float = 590.0
@export var jump_power: float = 400.0
@export var gravity: float = 980

@onready var hurt_box: HurtBox2D = $HurtBox2D
@onready var sprite: Sprite2D = $Sprite2D

var _hit_tween: Tween = null

func _ready() -> void:
	hurt_box.hurt.connect(_on_hurt)

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y -= jump_power
	
	if input_vector.x != 0:
		velocity.x = input_vector.x * walk_speed
	else:
		velocity.x = 0
	
	move_and_slide()

func _on_hurt(box: HitBox2D) -> void:
	if _hit_tween:
		_hit_tween.kill()
	
	_hit_tween = create_tween()
	_hit_tween.set_ease(Tween.EASE_IN_OUT)
	_hit_tween.set_trans(Tween.TRANS_QUAD)
	
	_hit_tween.tween_property(sprite, "self_modulate", Color.RED, 0.25)
	_hit_tween.parallel().tween_property(sprite, "scale", Vector2.ONE * 0.85, 0.25)
	_hit_tween.parallel().tween_property(sprite, "rotation_degrees", 10.0 * [-1, 1].pick_random(), 0.25)
	
	_hit_tween.chain().tween_property(sprite, "self_modulate", Color.WHITE, 0.25)
	_hit_tween.parallel().tween_property(sprite, "scale", Vector2.ONE, 0.25)
	_hit_tween.parallel().tween_property(sprite, "rotation_degrees", 0.0, 0.25)
