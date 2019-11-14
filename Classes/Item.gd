extends Resource
class_name Item

signal expired(this)
signal bought_or_sold(this)

export var name := "GenericItem"
export var plural_name := "GenericItems"
export var min_amount := 1
export var max_amount := 3
export var min_amount_money := 100
export var max_amount_money := 300
export var min_amount_balloons := 1
export var max_amount_balloons := 3
export var min_time := 15.0
export var max_time := 60.0
export var description_function := "get_no_description"

var amount := 0
var amount_money := 0
var amount_balloons := 0
var buying := true
var time := 0.0
var description := ""
var _time := 0.0


func initialize():
	description = ItemDescriptions.call(description_function)
	
	assert min_amount <= max_amount
	assert min_amount_money <= max_amount_money
	assert min_amount_balloons <= max_amount_balloons
	
	if max_amount > 0:
		amount = randi() % (max_amount - min_amount + 1) + min_amount
	else:
		amount = 0
	
	if max_amount_money > 0:
		amount_money = randi() % (max_amount_money - min_amount_money + 1) + min_amount_money
	else:
		amount_money = 0
	
	if max_amount_balloons > 0:
		amount_balloons = randi() % (max_amount_balloons - min_amount_balloons + 1) + min_amount_balloons
	else:
		amount_balloons = 0
	
	time = rand_range(min_time, max_time)
	
	# Really messy stuff, would be nice to move this into an item factory
	if Global.Game.items[name] < amount:
		buying = true
	else:
		buying = randf() < 1/3

func process(delta: float):
	_time += delta
	if _time >= time:
		_time = -INF
		emit_signal("expired", self)

func buy():
	_time = -INF
	emit_signal("bought_or_sold", self)
