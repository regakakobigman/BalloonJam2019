extends VBoxContainer

const MIN_ITEM_DELAY := 7.0
const MAX_ITEM_DELAY := 11.0

const ItemPanel = preload("res://Panels/Instantiables/ItemPanel.tscn")


func _ready() -> void:
	yield(Global.Game, "ready")
	loop_item_creation()


# Debug
func _input(e): if Input.is_action_pressed("ui_page_down"): add_market_item()


func loop_item_creation():
	add_market_item()
	get_tree().create_timer(rand_range(MIN_ITEM_DELAY, MAX_ITEM_DELAY)) \
		.connect("timeout", self, "loop_item_creation")


func add_market_item() -> PanelContainer:
	var panel = ItemPanel.instance()
	add_child(panel)
	var person = People.people[randi() % People.people.size()].duplicate()
	panel.person = person
	panel.item = person.preferred_item.duplicate()
	panel.connect("bought", self, "_on_item_bought")
	panel.connect("sold", self, "_on_item_sold")
	panel.connect("dismissed", self, "_on_item_dismissed")
	return panel


func update_items():
	for child in get_children():
		child.update_labels()


func _on_item_bought(item, person):
	Global.Game.money -= item.amount_money * item.amount
	Global.Game.balloons -= item.amount_balloons * item.amount
	Global.Game.items[item.name] += item.amount
	Global.EventLog.log("You bought %d %s!" % [item.amount, item.name if item.amount == 1 else item.plural_name])
	
	# ;)
	if item.name == "Horse":
		yield(get_tree().create_timer(2.7), "timeout")
		Global.EventLog.log("(but... why?)")


func _on_item_sold(item, person):
	Global.Game.money += item.amount_money * item.amount
	Global.Game.balloons += item.amount_balloons * item.amount
	Global.Game.items[item.name] -= item.amount
	Global.EventLog.log("You sold %d %s for %s" % [item.amount, item.name if item.amount == 1 else item.plural_name, Utils.get_money_and_balloons_description(item.amount_money * item.amount, item.amount_balloons * item.amount)])


func _on_item_dismissed():
	get_tree().create_timer(2).connect("timeout", self, "add_market_item")
