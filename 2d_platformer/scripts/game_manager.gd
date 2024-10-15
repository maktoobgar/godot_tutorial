extends Node

var score = 0
@onready var coins_collected: Label = $CoinsCollected

func add_point():
	score += 1
	coins_collected.text = "You Collected {0} coins".format([score])
