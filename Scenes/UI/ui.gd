extends Control

var left_score:= 0
var right_score:= 0

@onready var left_score_label: Label = $HBoxContainer/LeftScore
@onready var right_score_label: Label = $HBoxContainer/RightScore
@onready var button: Button = $CenterContainer/Button
@onready var game_mode_selectors: VBoxContainer = $CenterContainer/GameModeSelectors
@onready var com_button: Button = $CenterContainer/GameModeSelectors/ComButton
@onready var pv_p_button: Button = $CenterContainer/GameModeSelectors/PvPButton

func _ready() -> void:
	SignalBus.scored.connect(score)

func score(side: Area2D) -> void:
	if side.name.contains("Left"):
		right_score += 1
		right_score_label.text = str(right_score)
	else:
		left_score += 1
		left_score_label.text = str(left_score)

func _on_button_button_down() -> void:
	button.hide()
	game_mode_selectors.show()

func _on_com_button_button_down() -> void:
	game_mode_selectors.hide()
	SignalBus.game_started.emit("1p")

func _on_pv_p_button_button_down() -> void:
	game_mode_selectors.hide()
	SignalBus.game_started.emit("2p")
