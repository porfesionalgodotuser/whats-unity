extends Label

func _ready():
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.all_coins_collected.connect(_on_all_coins_collected)
	
	text = "Coins: " + str(GameManager.score)

func _on_score_changed(new_score):
	text = "Coins: " + str(new_score)

func _on_all_coins_collected():
	text = "You Win!"
