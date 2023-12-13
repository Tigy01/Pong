extends CharacterBody2D

const SPEED = 300.0

enum{PLAYER1, 
	PLAYER2, 
	COM}

var state
var target_position
var ball: CharacterBody2D


func _ready() -> void:
	hide()
	SignalBus.game_started.connect(_start_game)

func _physics_process(delta):
	match state:
		PLAYER1:
			_player_movement(Input.get_axis("p1_up", "p1_down"))
		PLAYER2:
			_player_movement(Input.get_axis("p2_up" , "p2_down"))
		COM:
			_com_movement(delta)


func _start_game(gamemode: String):
	show()
	if position.x < (get_viewport_rect().size.x/2.0):
		state = PLAYER1
		return
	
	if gamemode == "1p":
		state = COM
	else:
		state = PLAYER2

func _player_movement(direction: float):
	if direction:
		velocity.y = direction * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func _com_movement(delta):
	var accuracy = randf_range(0.1, .80)
	if ball:
		target_position = ball.position.y
		position.y = move_toward(position.y, ball.position.y, SPEED * accuracy * delta)
		position.y = clamp(position.y, 24, 240-24)
	else:
		if position.y == target_position:
			target_position = randi_range(100, 140)
			position.y = move_toward(position.y, target_position, SPEED * accuracy * delta)

func _on_detection_area_entered(body: Node2D) -> void:
	ball = body

func _on_detection_area_body_exited(_body: Node2D) -> void:
	ball = null
