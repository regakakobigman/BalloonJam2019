extends Node

# Game.gd will initialize this in _ready() with Unlocks.InitialUnlock
var pending_unlocks := []

func add_unlock(unlock):
	pending_unlocks.append(unlock)
	unlock.connect("unlocked", self, "_on_unlock_unlocked")

func check_all():
	for unlock in pending_unlocks:
		unlock.check()

func _on_unlock_unlocked(unlock):
	add_dependent_unlocks(unlock)
	Global.Game.JobController.add_dependent_jobs(unlock)
	call_unlock_function(unlock)
	Global.EventLog.log(call_event_description_function(unlock))
	pending_unlocks.erase(unlock)
	

func add_dependent_unlocks(unlock):
	# Unlock all the dependent unlocks listed in the unlock
	for dependent_unlock in unlock.dependent_unlocks:
		if dependent_unlock in Unlocks:
			add_unlock(Unlocks.get(dependent_unlock))
		elif OS.is_debug_build():
			printerr("(UnlockController.gd:Unlocks.gd) Unlock doesn't exist: ", dependent_unlock)

func call_unlock_function(unlock):
	# Call the unlock function if possible
	if unlock.unlock_function != "":
		if UnlockFunctions.has_method(unlock.unlock_function):
			UnlockFunctions.call(unlock.unlock_function)
		elif OS.is_debug_build():
			printerr("(UnlockController.gd:UnlockFunctions.gd) Unlock function doesn't exist: ", unlock.unlock_function)

func call_event_description_function(unlock) -> String:
	# Display the unlock's event description in the in-game console if possible
	if unlock.event_description_function != "":
		if UnlockEventDescriptionFunctions.has_method(unlock.event_description_function):
			return UnlockEventDescriptionFunctions.call(unlock.event_description_function)
		elif OS.is_debug_build():
			printerr("(UnlockController.gd:UnlockEventDescriptionFunctions.gd) Unlock event description function doesn't exist: ", unlock.event_description_function)
	return ""
