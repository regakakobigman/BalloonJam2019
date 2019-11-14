extends PanelContainer

signal job_bought(job, this)

const FREE_DESCRIPTIONS = [
	"Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free",
	"Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free",
	"Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free",
	"Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free",
	"Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free",
	"Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free",
	"Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free",
	"Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free", "Free",
	"Dude it's free",
	"It's free real estate",
	"Wow I can't believe it's free",
	"Wow much free",
	"Very free",
	"Costs literally nothing",
	"Actually free",
	"Totally free",
	"Mega free",
	"Super free",
	"Ultra free",
	"For the low price of nothing",
	"Just take it it's free",
	"It's free just do it",
	"Just start it it's free",
	"My dude it's free",
	"It's free my dude",
	"Hey it's totally free",
	"I Can't Believe It's Free™",
	"Freer than free",
	"HelpI'mStuckInAListOfPhrases",
	"FREEEEEEEEEEEEEEEEEEEEEEEEE",
	"IT'S FREE",
	"This job is so free my man",
	"Hey it's free",
	"What day is it? FREE-day",
	"I'm serious it's free",
	"I'm so free right now",
	"Psst it's free",
	"FREEfreeFREEfreeFREEfree",
	"ITS FREE AAAAAAAAAAAAAAAAAA",
]

onready var NameLabel = find_node("NameLabel")
onready var CostLabel = find_node("CostLabel")
onready var RewardLabel = find_node("RewardLabel")
onready var DescriptionLabel = find_node("DescriptionLabel")

var job: Job setget set_job

func _ready() -> void:
	$VBC/HS.visible = false
	$VBC/DescriptionLabel.visible = false
	margin_bottom = 0


func set_job(new_job: Job):
	job = new_job
	job.initialize()
	initialize_job()


func initialize_job():
	NameLabel.text = job.name
	
	DescriptionLabel.text = job.description
	
	CostLabel.visible = true
	var costs_money = job.cost_money > 0
	var costs_balloons = job.cost_balloons > 0
	if job.cost_money > 0 or job.cost_balloons > 0:
		CostLabel.text = "Costs " + Utils.get_money_and_balloons_description(job.cost_money, job.cost_balloons)
	else:
		CostLabel.text = get_random_free_description()
	
	RewardLabel.visible = true
	var gives_money = job.reward_money > 0
	var gives_balloons = job.reward_balloons > 0
	if gives_money or gives_balloons:
		RewardLabel.text = Utils.get_money_and_balloons_description(job.reward_money, job.reward_balloons, true)
		RewardLabel.text += " %s %.1fs" % ["every" if job.repeat and not (costs_money or costs_balloons) else "after", job.time]
	else:
		RewardLabel.text = ""
		RewardLabel.visible = false

func get_random_free_description() -> String:
	return FREE_DESCRIPTIONS[randi() % FREE_DESCRIPTIONS.size()]


func _on_AvailableJobPanel_mouse_entered() -> void:
	var has_description = DescriptionLabel.text != ""
	$VBC/HS.visible = has_description
	DescriptionLabel.visible = has_description
	if not has_description:
		margin_bottom = 0


func _on_AvailableJobPanel_mouse_exited() -> void:
	$VBC/HS.visible = false
	DescriptionLabel.visible = false
	margin_bottom = 0


func _on_BuyButton_pressed() -> void:
	emit_signal("job_bought", job, self)
