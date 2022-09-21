extends KinematicBody2D

var velocity = Vector2(0, 0)
var SPEED = 250
const GRAVITY = 50
const JUMPFORCE = -1100
var coins = 0
var hurt := 0
const FIREBALL = preload("res://Fireball.tscn")

func _physics_process(delta):
	if Input.is_action_pressed("boost"):
		SPEED = 400
	if Input.is_action_just_released("boost"):
		SPEED = 250
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		$Sprite.play("walk")
		$Sprite.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED
		$Sprite.play("walk")
		$Sprite.flip_h = true
	else:
		$Sprite.play("idle")
	if not is_on_floor():
		$Sprite.play("air")
	
	velocity.y = velocity.y + GRAVITY
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMPFORCE
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.x = lerp(velocity.x, 0, 0.2)
	
	fire()
	
func fire():
	if Input.is_action_just_pressed("fire"):
		var direction = 1 if not $Sprite.flip_h else -1
		var f = FIREBALL.instance()
		f.direction = direction
		get_parent().add_child(f)
		f.position.y = position.y
		f.position.x = position.x + 25*direction

func _on_Area2D_body_entered(body):
	Global.lose_life()
	if Global.lives >= 1:
		get_tree().reload_current_scene()
	#get_tree().change_scene("res://GameOver.tscn")
	
func add_coins():
	coins = coins + 1
	print("You get ", coins, " coins")
	if coins == 3:
		print("You win!!")
		#get_tree().change_scene("res://Level_1.tscn")

func ouch(var enemyposx):
	Global.lose_life()
	set_modulate(Color(1, 0.3, 0.3, 0.3))
	velocity.y = JUMPFORCE * 0.5
	if position.x < enemyposx:
		velocity.x = -800
	if position.x > enemyposx:
		velocity.x = 800
	Input.action_release("left")
	Input.action_release("right")
	set_modulate(Color(10, 10, 10, 0.8))
	hurt = 20
	$Timer.start()

func _on_Timer_timeout():
	hurt -= 1
	if hurt == 0:
		$Timer.stop()
		set_modulate(Color(1, 1, 1, 1))
	else:
		set_modulate(Color(1, 0.3, 0.3, 0.5) if hurt % 2 == 0 else Color(1, 0.3, 0.3, 0.7))
	#get_tree().change_scene("res://GameOver.tscn")

func _on_NextLevel_body_entered(body):
	if coins == 3:
		Global.lives = Global.max_lives
		body.get_tree().change_scene("res://Level_2.tscn")
