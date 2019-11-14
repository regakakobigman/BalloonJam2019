extends PanelContainer

signal job_finished(job, this)

const TIME_BAR_LERP_SPEED = 5.0

onready var NameLabel = find_node("NameLabel")
onready var TimeLabel = find_node("TimeLabel")
onready var TimeBar = find_node("TimeBar")
onready var RewardLabel = find_node("RewardLabel")
onready var DescriptionLabel = find_node("DescriptionLabel")

var job setget set_job


func _ready() -> void:
	DescriptionLabel.text = ""
	$VBC/HS.visible = false
	$VBC/DescriptionLabel.visible = false
	margin_bottom = 0


func set_job(new_job):
	job = new_job
	job.initialize()
	initialize_job()
	job.connect("finished", self, "_on_job_finished")


func _process(delta: float) -> void:
	if not job: return
	if Input.is_action_pressed("ui_home"):
		job.process(delta * 10)
	else:
		job.process(delta)
	TimeLabel.text = "%.1f/%.1f" % [job._time, job.time]
	TimeBar.value = lerp(TimeBar.value, job._time / job.time * 100, delta * TIME_BAR_LERP_SPEED)


func initialize_job():
	NameLabel.text = job.name
	TimeLabel.text = "0.0/%.1f" % job.time
	
	DescriptionLabel.text = job.description
	
	
	if job.reward_money <= 0 and job.reward_balloons <= 0:
		RewardLabel.text = ""
		RewardLabel.visible = false
	else:
		RewardLabel.text = Utils.get_money_and_balloons_description(job.reward_money, job.reward_balloons, true)
		RewardLabel.visible = true


func _on_JobPanel_mouse_entered():
	var has_description = DescriptionLabel.text != ""
	$VBC/HS.visible = has_description
	DescriptionLabel.visible = has_description
	if not has_description:
		margin_bottom = 0


func _on_JobPanel_mouse_exited():
	$VBC/HS.visible = false
	$VBC/DescriptionLabel.visible = false
	margin_bottom = 0


func _on_job_finished(finished_job):
	emit_signal("job_finished", finished_job, self)
