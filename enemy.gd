extends KinematicBody2D

var velocity = Vector2()
var speed = 80
export var direction = -1

func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = true
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction

func _physics_process(delta):
	if is_on_wall() or not $floor_checker.is_colliding() and is_on_floor():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	velocity.y += 20
	
	velocity.x = speed * direction
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_top_checker_body_entered(body):
	$AnimatedSprite.play("squashed")
	speed = 0
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(0, false)
	$top_checker.set_collision_layer_bit(4, false)
	$top_checker.set_collision_mask_bit(0, false)
	$side_checker.set_collision_layer_bit(4, false)
	$side_checker.set_collision_mask_bit(0, false)
	$Timer.start()

func _on_side_checker_body_entered(body):
	if body.get_collision_layer() == 1:
		body.ouch(position.x)
	if body.get_collision_layer() == 32:
		$AnimatedSprite.play("squashed")
		body.queue_free()
		queue_free()
	


func _on_Timer_timeout():
	queue_free()
