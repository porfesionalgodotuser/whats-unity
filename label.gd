extends Label

func _ready():
	GameManager.score_changed.connect(_on_score_changed)
	
	text = "Coins: " + str(GameManager.score)

func _on_score_changed(new_score):
	text = "Coins: " + str(new_score)
