extends Control

func awaiting_check() -> void:
	$unsureValue.visible = true
	$falseValue.visible = false
	$trueValue.visible = false

func set_check(check_value : bool) -> void:
	if check_value:
		$unsureValue.visible = false
		$falseValue.visible = false
		$trueValue.visible = true
	else:
		$unsureValue.visible = false
		$falseValue.visible = true
		$trueValue.visible = false
