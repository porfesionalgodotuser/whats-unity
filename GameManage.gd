extends Node

signal score_changed(new_score)
signal all_coins_collected

var score = 0
var total_coins = 0

func register_coin():
	total_coins += 1

func add_score(amount):
	score += amount
	score_changed.emit(score)
	if score >= total_coins and total_coins > 0:
		all_coins_collected.emit()
