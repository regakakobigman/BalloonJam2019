extends PanelContainer

signal bought(item, person)
signal sold(item, person)
signal dismissed

const TIME_BAR_LERP_SPEED = 5.0

onready var TimeLabel = find_node("TimeLabel")
onready var TimeBar = find_node("TimeBar")
onready var PersonNameLabel = find_node("PersonNameLabel")
onready var BuySellLabel = find_node("BuySellLabel")
onready var AmountLabel = find_node("AmountLabel")
onready var TheirItemNameLabel = find_node("TheirItemNameLabel")
onready var YourItemNameLabel = find_node("YourItemNameLabel")
onready var IndividualCostLabel = find_node("IndividualCostLabel")
onready var TotalCostLabel = find_node("TotalCostLabel")
onready var CurrentAmountLabel = find_node("CurrentAmountLabel")
onready var BuySellButton = find_node("BuySellButton")

var person setget set_person
var item setget set_item


func _ready() -> void:
	$VBC/HS.visible = false
	$VBC/DescriptionLabel.visible = false
	margin_bottom = 0
	set_person(Person.new())
	set_item(Items.ExpiredSoySaucePacket)
	update_labels()


func update_labels():
	# Should only be called when both item and person exist
	
	PersonNameLabel.text = person.name
	BuySellLabel.text = "sell" if item.buying else "buy" # If we're buying, the NPC is selling
	AmountLabel.text = item.amount as String
	TheirItemNameLabel.text = item.name if item.amount == 1 else item.plural_name
	if Global.Game: # Workaround for F6
		YourItemNameLabel.text = item.name if Global.Game.items[item.name] == 1 else item.plural_name
	else:
		YourItemNameLabel.text = item.plural_name
	assert item.amount_money > 0 or item.amount_balloons > 0 # Should cost at least some money or balloons
	IndividualCostLabel.text = Utils.get_money_and_balloons_description(item.amount_money, item.amount_balloons)
	if item.amount > 1:
		IndividualCostLabel.text += " each"
	TotalCostLabel.text = Utils.get_money_and_balloons_description(item.amount_money * item.amount, item.amount_balloons * item.amount)
	if Global.Game:
		CurrentAmountLabel.text = Global.Game.items[item.name] as String
	else:
		CurrentAmountLabel.text = "0"
	BuySellButton.text = "Buy" if item.buying else "Sell"
	$VBC/DescriptionLabel.text = item.description
	
	if Global.Game:
		# Toggle the button based on whether we can afford it
		var can_afford: bool
		if item.buying:
			can_afford = Global.Game.money >= item.amount_money * item.amount and Global.Game.balloons >= item.amount_balloons * item.amount
		else:
			can_afford = Global.Game.items[item.name] >= item.amount
		BuySellButton.disabled = not can_afford


func _process(delta: float) -> void:
	if not item: return
	if Input.is_action_pressed("ui_end"):
		item.process(delta * 25)
	else:
		item.process(delta)
	TimeLabel.text = "%.1f/%.1f" % [item._time, item.time]
	TimeBar.value = lerp(TimeBar.value, item._time / item.time * 100, delta * TIME_BAR_LERP_SPEED)


func set_item(new_item):
	item = new_item
	item.initialize()
	if person:
		update_labels()
	item.connect("bought_or_sold", self, "_on_item_bought_or_sold")
	item.connect("expired", self, "_on_item_expired")

func set_person(new_person):
	person = new_person
	person.initialize()
	if item:
		update_labels()


func _on_ItemPanel_mouse_entered() -> void:
	var has_description = $VBC/DescriptionLabel.text != ""
	$VBC/HS.visible = has_description
	$VBC/DescriptionLabel.visible = has_description
	if not has_description:
		margin_bottom = 0


func _on_ItemPanel_mouse_exited() -> void:
	$VBC/HS.visible = false
	$VBC/DescriptionLabel.visible = false
	margin_bottom = 0


func _on_BuySellButton_pressed() -> void:
	item.buy()


func _on_item_bought_or_sold(_item):
	emit_signal("bought" if item.buying else "sold", item, person)
	queue_free()


func _on_item_expired(_item):
	queue_free()


func _on_DismissButton_pressed() -> void:
	emit_signal("dismissed")
	queue_free()
