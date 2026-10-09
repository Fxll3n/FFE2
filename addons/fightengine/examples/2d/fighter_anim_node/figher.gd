extends CharacterBody2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer

@export var walk_speed: float = 300.0
@export var friction: float = 100.0

func _physics_process(delta: float) -> void:
	var walk_dir := Input.get_axis("ui_left", "ui_right")
	if walk_dir != 0:
		if anim_player.current_animation != "walk" and anim_player.current_animation != "punch":
			anim_player.play("walk")
		velocity.x =walk_dir * walk_speed * 10 * delta
	else:
		
		if anim_player.current_animation != "idle" and anim_player.current_animation != "punch":
			anim_player.play("idle")
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
	
	if Input.is_key_pressed(KEY_F):
		anim_player.play("punch")
	
	move_and_slide()
