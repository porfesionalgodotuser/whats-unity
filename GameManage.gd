extends Node

signal score_changed(new_score)
signal all_coins_collected
signal game_started

var score = 0
var total_coins = 0
var won = false
var started = false

func start_game():
	if not started:
		started = true
		game_started.emit()

func register_coin():
	total_coins += 1

func add_score(amount):
	if won:
		return
	score += amount
	score_changed.emit(score)
	if score >= total_coins and total_coins > 0:
		won = true
		all_coins_collected.emit()
