extends CanvasLayer

var coins = 0

func _ready():
	$Coins.text = String(coins)
	load_hearts()
	Global.hud = self

func _on_coin_collected():
	coins = coins + 1
	_ready()
	#if coins == 3:
		#get_tree().change_scene("res://Victory.tscn")
		#get_tree().change_scene("res://Level_2.tscn")

func load_hearts():
	$HeartsFull.rect_size.x = Global.lives * 53
	$HeartsEmpty.rect_size.x = (Global.max_lives - Global.lives) * 53
	$HeartsEmpty.rect_position.x = $HeartsFull.rect_position.x + $HeartsFull.rect_size.x * $HeartsFull.rect_scale.x
