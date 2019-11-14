extends PanelContainer


func _ready() -> void:
	$RichTextLabel.add_text("                                                   Event Log")


# Conflicts with the built-in 'log' function, but it's fine
func log(text: String, new_line:=true):
	if text != "":
		$RichTextLabel.add_text(("\n" if new_line else "") + text)
		$AnimationPlayer.play("Flash")
