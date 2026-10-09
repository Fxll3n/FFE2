extends Node2D

@onready var hurt_box: HurtBox2D = $HurtBox2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("idle")
	hurt_box.hurt.connect(
		func(_box):
			animation_player.play("hit")
			_spawn_hit_text(["Ouch!", "Oof!", "Owie!", "Ah!"].pick_random())
			await animation_player.animation_finished
			animation_player.play("idle")
	)

func _spawn_hit_text(msg: String) -> void:
	var lbl := Label.new()
	add_child(lbl)
	lbl.global_position = global_position + Vector2(-10, -20)
	
	lbl.text = msg
	
	var t := create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_SINE)
	t.tween_property(lbl, "position:y", -100, 2).as_relative()
	t.parallel().tween_property(lbl, "position:x", randf_range(40, 50) * [1, -1].pick_random(), 2).as_relative()
	t.parallel().tween_property(lbl, "self_modulate:a", 0, 1).set_delay(1)
	t.finished.connect(lbl.queue_free)
