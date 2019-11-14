extends Node

# These functions are called by unlocks when their requirements are met

func advance_containment_level():
	Global.Game.containment_level += 1
	assert Global.Game.containment_level <= 5

func win():
	Global.Game.get_node("WinLabel").visible = true
