extends Control

onready var JobController = find_node("JobController")
onready var MarketController = find_node("MarketController")
onready var ResourcesLabel = find_node("ResourcesLabel")
onready var BalloonPreview = find_node("BalloonPreview")
onready var ColorSchemeOptionButton = find_node("ColorSchemeOptionButton")

var money := 451 setget set_money # Counted in cents
var balloons := 0 setget set_balloons

var total_money := 0
var total_balloons := 0


var items := {} # Initialized to 0 of every resource name on _ready

func _ready() -> void:
	randomize()
	
	for item in Items.items:
		items[item.name] = 0
	
	# Would have been cleaner to give the InfoPanel its own script here, and use signals
	ColorSchemeOptionButton.connect("item_selected", self, "_on_color_scheme_option_button_item_selected")
	ColorSchemeOptionButton.select(EMERALD_EYESORE)
	ColorSchemeOptionButton.emit_signal("item_selected", EMERALD_EYESORE)
	UnlockController.add_unlock(Unlocks.InitialUnlock)
	update_resources()
	update_unlocks()


func set_money(new_money: int):
	if new_money > money:
		total_money += (new_money - money)
	money = new_money
	update_unlocks()
	update_resources()


func set_balloons(new_balloons: int):
	if new_balloons > balloons:
		total_balloons += (new_balloons - balloons)
	balloons = new_balloons
	update_unlocks()
	update_resources()


func update_resources():
	ResourcesLabel.text = "You have " + Utils.get_money_and_balloons_description(money, balloons) if money > 0 or balloons > 0 else "absolutely nothing. Congratulations."
	BalloonPreview.balloon_amount = total_balloons
	MarketController.update_items()


func update_unlocks():
	UnlockController.check_all()






# Moved to the bottom of the script because it's useless ;)
enum containment_levels {
	SAFE,
	EUCLID,
	KETER,
	THAUMIEL,
	APOLLYON,
	SIR_SLASH_MADAM_IM_GOING_TO_HAVE_TO_ASK_YOU_TO_LEAVE_THE_STORE_I_ALREADY_TOLD_YOU_IM_JUST_A_DOLLAR_GENERAL_CASHIER_I_REALLY_DONT_KNOW_IF_THE_BALLOONS_ARE_MADE_OF_NEOPRENE_OR_NYLON_REALLY_IM_SORRY_I_JUST_DONT_KNOW_SO_PLEASE_STOP_YELLING_AT_ME}
var containment_level: int = containment_levels.SAFE setget set_containment_level
onready var ContainmentLevelLabel = find_node("ContainmentLevelLabel")
func set_containment_level(new_containment_level: int):
	containment_level = new_containment_level
	match new_containment_level:
		containment_levels.SAFE:
			ContainmentLevelLabel.text = "Safe"
		containment_levels.EUCLID:
			ContainmentLevelLabel.text = "Euclid"
		containment_levels.KETER:
			ContainmentLevelLabel.text = "Keter"
		containment_levels.THAUMIEL:
			ContainmentLevelLabel.text = "Thaumiel"
		containment_levels.APOLLYON:
			ContainmentLevelLabel.text = "Apollyon"
		containment_levels.SIR_SLASH_MADAM_IM_GOING_TO_HAVE_TO_ASK_YOU_TO_LEAVE_THE_STORE_I_ALREADY_TOLD_YOU_IM_JUST_A_DOLLAR_GENERAL_CASHIER_I_REALLY_DONT_KNOW_IF_THE_BALLOONS_ARE_MADE_OF_NEOPRENE_OR_NYLON_REALLY_IM_SORRY_I_JUST_DONT_KNOW_SO_PLEASE_STOP_YELLING_AT_ME:
			ContainmentLevelLabel.text = "Sir/Madam I'm Going To Have To Ask You To Leave The Store I Already Told You I'm Just A Dollar General Cashier I Really Don't Know If The Balloons Are Made Of Neoprene Or Nylon Really I'm Sorry I Just Don't Know So Please Stop Yelling At Me"


enum {
	EMERALD_EYESORE,
	GARNET_GARBAGE,
	TURQUOISE_TRASH,
	MOONSTONE_MISTAKE,
	CORDIERITE_CATARACTS,
	JADE_JUST_KILL_ME,
	ROSE_QUARTZ_RUBBISH,
	CITRINE_CMV_RETINITIS,
	AAAAAAAAAAAAAAA,
	ORANGE
}
func _on_color_scheme_option_button_item_selected(id: int):
	# Would have made UI themes if I had more time
	# These color look as terrible as they sound delicious
	match id:
		EMERALD_EYESORE:
			VisualServer.set_default_clear_color(Color.darkseagreen)
		GARNET_GARBAGE:
			VisualServer.set_default_clear_color(Color.indianred)
		TURQUOISE_TRASH:
			VisualServer.set_default_clear_color(Color.steelblue)
		MOONSTONE_MISTAKE:
			VisualServer.set_default_clear_color(Color.powderblue)
		CORDIERITE_CATARACTS:
			VisualServer.set_default_clear_color(Color8(33, 25, 88))
		JADE_JUST_KILL_ME:
			VisualServer.set_default_clear_color(Color.palegreen)
		ROSE_QUARTZ_RUBBISH:
			VisualServer.set_default_clear_color(Color.mistyrose)
		CITRINE_CMV_RETINITIS:
			VisualServer.set_default_clear_color(Color.goldenrod / 2 + Color.palegoldenrod / 2)
		AAAAAAAAAAAAAAA:
			VisualServer.set_default_clear_color(Color(INF, INF, INF))
		ORANGE:
			VisualServer.set_default_clear_color(Color.darkorange)
