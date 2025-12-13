extends Control


var agreed : bool = false

func _ready() -> void:
	$TextureRect.self_modulate = Color (1, 1, 1, 1)
	$TextureRect.visible = true
	$Timer.start(1)
	%confirmButton.set_disabled()
	
	GlobalScripts.replace_version_placeholder(%spacer)
	#print("starting timer")

func _on_back_button_pressed() -> void:
	get_tree().quit()

func _on_check_box_pressed() -> void:
	if agreed:
		agreed = false
		%confirmButton.set_disabled()
	else:
		agreed = true
		%confirmButton.reenable_button()

func _on_timer_timeout() -> void:
	#print("starting animation")
	$AnimationPlayer.play("fade")


func _on_confirm_button_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/startingGUI.tscn")
