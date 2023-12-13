extends Camera2D

var shake_amount := 0.0
var defualt_offset := offset
var pos_x: int
var pos_y: int 

func _ready() -> void:
	SignalBus.shaked.connect(shake)
	set_process(true)
	randomize()

func _process(_delta: float) -> void:
	offset = Vector2(randf_range(-1, 1) * shake_amount, 
					randf_range(-1, 1) * shake_amount)

func shake(time: float, amount: float):
	shake_amount = amount
	set_process(true)
	var timer = get_tree().create_timer(time)
	await timer.timeout
	set_process(false)
	offset = defualt_offset
