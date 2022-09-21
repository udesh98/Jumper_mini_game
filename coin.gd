extends Area2D

signal coin_collected

func _on_coin_body_entered(body):
	#queue_free()
	$AnimationPlayer.play("bounce")
	print("test")
	body.add_coins()
	print("RUUUNN")
	emit_signal("coin_collected")

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
