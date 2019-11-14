extends Resource
class_name Unlock

signal unlocked(this)

export var money_threshold := 100
export var balloons_threshold := 0
export var total_money_threshold := 0
export var total_balloons_threshold := 0
export var unlock_function := ""
export var event_description_function := ""
export(Array, String) var dependent_unlocks := []
export(Array, String) var dependent_jobs := []

func check():
	if is_unlocked():
		emit_signal("unlocked", self)

func is_unlocked() -> bool:
	return (Global.Game.money >= money_threshold
		and Global.Game.balloons >= balloons_threshold
		and Global.Game.total_money >= total_money_threshold
		and Global.Game.total_balloons >= total_balloons_threshold)
