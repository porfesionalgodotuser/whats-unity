extends Node

# This variable holds the score for the entire game
var score: int = 0

func add_score(amount: int):
	score += amount
	print("Current Score: ", score)
	# You can also trigger UI updates here later
