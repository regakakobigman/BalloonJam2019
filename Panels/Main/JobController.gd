extends VSplitContainer

# Tightly coupled 'manager' class -- but this is hard to avoid in a small UI-based game
# There are only 7 days left (hey, still more lenient than Majora's Mask),
# so this is fine for the time restraints.

onready var ActiveJobsVBC = find_node("ActiveJobsVBC")
onready var AvailableJobsVBC = find_node("AvailableJobsVBC")

const AvailableJobPanel = preload("res://Panels/Instantiables/AvailableJobPanel.tscn")
const ActiveJobPanel = preload("res://Panels/Instantiables/ActiveJobPanel.tscn")

var available_jobs := []
var active_jobs := []


func add_job(job: Job):
	var panel = AvailableJobPanel.instance()
	AvailableJobsVBC.add_child(panel)
	panel.job = job
	panel.connect("job_bought", self, "_on_job_bought")


func _on_job_bought(job, panel):
	if job.cost_money > Global.Game.money and job.cost_balloons > Global.Game.balloons:
		# TODO: Make this text fly up on the buy button
		Global.EventLog.log("Not enough money and balloons")
	elif job.cost_money > Global.Game.money:
		# TODO: Make this text fly up on the buy button
		Global.EventLog.log("Not enough money")
	elif job.cost_balloons > Global.Game.balloons:
		# TODO: Make this text fly up on the buy button
		Global.EventLog.log("Not enough balloons")
	else: # We can afford it
		panel.queue_free()
		Global.Game.money -= job.cost_money
		Global.Game.balloons -= job.cost_balloons
		add_active_job(job)


func add_active_job(job: Job):
	var panel = ActiveJobPanel.instance()
	ActiveJobsVBC.add_child(panel)
	panel.job = job
	panel.connect("job_finished", self, "_on_job_finished")


func _on_job_finished(job: Job, panel):
	if job.repeat:
		if job.cost_money == 0 and job.cost_balloons == 0:
			pass # Let it keep going
		else:
			add_job(job)
			panel.queue_free()
	else:
		panel.queue_free()
	if not job.repeat or job.repeat and not job.has_repeated:
		UnlockController.add_dependent_unlocks(job)
		add_dependent_jobs(job)
	Global.Game.money += job.reward_money
	Global.Game.balloons += job.reward_balloons


func add_dependent_jobs(job):
	# Add all the dependent jobs listed in the job
	for dependent_job in job.dependent_jobs:
		if dependent_job in Jobs:
			add_job(Jobs.get(dependent_job))
		elif OS.is_debug_build():
			printerr("(JobController.gd:Jobs.gd) Job doesn't exist: ", dependent_job)
