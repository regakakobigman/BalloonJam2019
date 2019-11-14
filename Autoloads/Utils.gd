extends Node


func get_money_and_balloons_description(money: int, balloons: int, has_plus:=false) -> String:
	var text = ""
	var uses_money = money > 0
	var uses_balloons = balloons > 0
	
	var plus = "+" if has_plus else ""
	
	if uses_money and uses_balloons:
		text = "%s$%s.%02d and %s%s balloon%s" % [plus, money / 100, money % 100, plus, balloons, "s" if balloons != 1 else ""]
	elif uses_money:
		text = "%s$%s.%02d" % [plus, money / 100, money % 100]
	elif uses_balloons:
		text = "%s%s balloon%s" % [plus, balloons, "s" if balloons != 1 else ""]
	
	return text
	
