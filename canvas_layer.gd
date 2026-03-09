extends Label

func _ready():
	# This looks for the GLOBAL GameManage, not 'self'
	GameManage.score_changed.connect(_on_score_changed)
	text = "Coins: " + str(GameManage.score)

func _on_score_changed(new_score):
	text = "Coins: " + str(new_score)
