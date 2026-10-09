extends CharacterBody3D

@export var walk_speed: float = 300.0

@onready var gobot_skin: GobotSkin = $GobotSkin

func _ready() -> void:
	gobot_skin.victory_sign()

func _physics_process(delta: float) -> void:
	var walk_dir := Input.get_axis("ui_left", "ui_right")
	if not is_on_floor():
		velocity.y -= 980 * delta
	
	velocity.x = walk_dir * walk_speed * delta
	
	if walk_dir != 0:
		gobot_skin.move()
	else:
		gobot_skin.idle()
	
	move_and_slide()
