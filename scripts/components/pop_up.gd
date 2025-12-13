extends NinePatchRect

signal confirm
signal deny
signal go_on
signal opened

func _ready() -> void:
	$".".visible = false
	ErrorManager.error_alert.connect(on_error)

func on_error() -> void:
	stop_loading()
	$".".visible = false

func _on_continue_button_pressed() -> void:
	go_on.emit()
	$".".visible = false

func pop_continue(title : String, message : String, continue_message : String = "Lets try that again...") -> void:
	$".".visible = true
	%loadingBoxContainer.visible = false
	$buttons.visible = false
	$continue.visible = true
	%titleLabel.text = title
	%popUpText.text = message
	%continueLabel.text = continue_message
	opened.emit()

func pop_yesNo(title : String, message : String, no_label : String = "Back", yes_label : String = "Continue") -> void:
	$".".visible = true
	$continue.visible = false
	%loadingBoxContainer.visible = false
	$buttons.visible = true
	%titleLabel.text = title
	%popUpText.text = message
	%cancelButton.button_label.text = no_label
	%primaryButton.button_label.text = yes_label
	opened.emit()

func loading(process : String) -> void:
	$".".visible = true
	$continue.visible = false
	$buttons.visible = false
	%loadingBoxContainer.visible = true
	%titleLabel.text = "Thank you for waiting!"
	%popUpText.text = process
	$AnimationPlayer.play("loading")
	opened.emit()

func stop_loading() -> void:
	$AnimationPlayer.stop()
	$".".visible = false

func _on_cancel_button_button_pressed() -> void:
	deny.emit()
	$".".visible = false

func _on_primary_button_button_pressed() -> void:
	confirm.emit()
	$".".visible = false
