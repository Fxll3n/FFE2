extends CharacterBody3D

@export var walk_speed: float = 300.0

@onready var gobot_skin: Node3D = $GobotSkin
@onready var hurt_box_3d: HurtBox3D = $HurtBox3D

func _ready() -> void:
	hurt_box_3d.hurt.connect(
		func(_box):
			gobot_skin.hurt()
	)
	

func _physics_process(delta: float) -> void:
	var walk_dir := Input.get_axis("ui_left", "ui_right")
	if not is_on_floor():
		velocity.y -= 980 * delta
	
	velocity.x = walk_dir * walk_speed * delta
	
	if walk_dir != 0:
		if walk_dir < 0:
			gobot_skin.rotation_degrees.y = -90
		if walk_dir > 0:
			gobot_skin.rotation_degrees.y = 90
		gobot_skin.move()
	else:
		gobot_skin.idle()
	
	move_and_slide()
