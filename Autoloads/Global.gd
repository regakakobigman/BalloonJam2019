extends Node

onready var Game = get_tree().get_root().get_node_or_null("Game")
onready var EventLog = Game.find_node("EventLog") if Game else null
