extends Node

signal score_changed(new_score)

var score = 0

func add_score(amount):
	score += amount
	score_changed.emit(score)
