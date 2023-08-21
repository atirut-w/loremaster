extends OptionButton

var CHOICE1 = 0
var CHOICE2 = 1
var CHOICE3 = 2

func _ready():
	add_item("", -1)
	add_item("Choice 1", CHOICE1)
	add_item("Choice 2", CHOICE2)
	add_item("Choice 3", CHOICE3)
