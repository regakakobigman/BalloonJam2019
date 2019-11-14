extends Resource
class_name Job

signal finished(this)

export var name := "GenericJob"
export var cost_money := 100
export var cost_balloons := 1
export var reward_money := 100
export var reward_balloons := 1
export var repeat := false
export var time := 7.0
export var completion_function := ""
export var description_function := "get_no_description"
export(Array, String) var dependent_unlocks := []
export(Array, String) var dependent_jobs := []

var active := true
var description := ""
var has_repeated := false
var _time := 0.0


func initialize():
	description = JobDescriptions.call(description_function)


func process(delta: float):
	if active:
		_time += delta
		while _time >= time:
			_time -= time
			if JobFunctions.has_method(completion_function):
				JobFunctions.call(completion_function)
			emit_signal("finished", self)
			if not repeat:
				active = false
				_time = 0
			has_repeated = true


