extends CharacterBody2D

@export_range(0.0, 65.0, 0.5) var maximum_angle = 65.0
@export var hits_til_max_speed:= 1
@export var initial_speed:= 100.0
@export var max_speed:=300.0:
	set(val):
		val = clamp(val, initial_speed, 1000)
		max_speed = val

var _start_direction:= randi_range(0, 1)
var _speed= initial_speed
var _bounces = 0

@onready var _speed_incrament: float = (max_speed - initial_speed)/hits_til_max_speed
@onready var starting_pos: Vector2 = $StartingPos.position

func _ready() -> void:
	hide()
	position = starting_pos
	set_physics_process(false)
	SignalBus.game_started.connect(_start)

func _physics_process(_delta: float) -> void:
	move_and_slide()

var angle_to_paddle: float
var angle_of_velocity: float
var final_angle: float
func _calculate_velocity(paddle: Node):
	angle_to_paddle= clampf((position.y - paddle.position.y)/24.0, -1., 1.) #Based on where on the paddle it hits. The ends produce extreme angels
	angle_to_paddle*=deg_to_rad(maximum_angle) ##Produces an angle that is some fraction of the maximum
	angle_of_velocity= asin(velocity.y/_speed) #The angle of the balls velocity 90 is straight down -90 is straight up
	final_angle= angle_to_paddle + angle_of_velocity
	final_angle = clamp(final_angle, deg_to_rad(-maximum_angle), deg_to_rad(maximum_angle))
	
	velocity.x = cos(final_angle) * _speed
	velocity.y = sin(final_angle) * _speed
	
	if position.x >= get_viewport_rect().size.x/2.0:
		velocity.x *= -1

func _start(_gamemode: String):
	show()
	set_physics_process(true)
	if _start_direction == 0:
		_start_direction -=1
	velocity.x = _speed * _start_direction

func _on_player_collided(body: Node) -> void:
	if body.is_in_group("Paddle"):
		_calculate_velocity(body)
		_bounces +=1
		_speed = _bounces * _speed_incrament
		_speed = clamp(_speed, initial_speed, max_speed)
		SignalBus.shaked.emit(.3, 2)
	else:
		velocity.y*=-1

func _on_score_area_entered(side: Area2D) -> void:
	_bounces = 0
	if side.name.begins_with("Left"):
		_start_direction = 1
	elif side.name.begins_with("Right"):
		_start_direction = -1
	else:
		return
	
	position = starting_pos
	_speed = initial_speed * _start_direction
	velocity.x = _speed
	velocity.y = 0
	SignalBus.scored.emit(side)
