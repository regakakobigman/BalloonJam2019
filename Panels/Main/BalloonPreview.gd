extends Node2D

var balloon_amount := 2
var balloon_lifetime := 9.0


func _ready():
	set_balloon_amount(balloon_amount * 30)
	set_balloon_lifetime(balloon_lifetime)


func set_balloon_amount(new_balloon_amount: int):
	balloon_amount = new_balloon_amount
	$Particles2D.visible = new_balloon_amount > 0
	$Particles2D.amount = max(new_balloon_amount, 1)


func set_balloon_lifetime(new_balloon_lifetime: float):
	balloon_lifetime = new_balloon_lifetime
	$Particles2D.lifetime = new_balloon_lifetime


func _on_UpdateTimer_timeout() -> void:
	# Bandaid fix because Godot particles will restart when changing the amount of particles emitted
	# Would look much better to queue_free() us, re-instance the scene, and tween the modulate,
	# but I don't have time to add that
	set_balloon_amount(balloon_amount * 30)
	set_balloon_lifetime(balloon_lifetime)
