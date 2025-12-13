extends NinePatchRect

signal error_continue

func _ready() -> void:
	ErrorManager.error_alert.connect(on_error)
	$".".visible = false

func _process(delta: float) -> void:
	if ErrorManager.is_error:
		on_error()
	else:
		pass

func on_error() -> void:
	$".".visible = true
	%errorText.text = ErrorManager.current_error
	%errorText.add_theme_color_override("font_color", Color(0.306, 0.271, 0.133) )

func _on_continue_button_pressed() -> void:
	error_continue.emit()
	ErrorManager.is_error = false
	ErrorManager.current_error = ""
	ErrorManager.error_continue()
	$".".visible = false
