extends Panel

@export var button_text : String

signal button_pressed()

func _ready() -> void:
	%buttonLabel.text = button_text
	%buttonLabel.add_theme_color_override("font_color", Color("6e343b") )

func _on_button_pressed() -> void:
	button_pressed.emit()

func _on_button_button_up() -> void:
	$textContainer.position.y = 7

func _on_button_button_down() -> void:
	$textContainer.position.y = 12

func set_disabled() -> void:
	$Button.disabled = true
	_on_button_button_down()
	%buttonLabel.add_theme_color_override("font_color", Color("b47d67") )


func reenable_button() -> void:
	$Button.disabled = false
	_on_button_button_up()
	%buttonLabel.add_theme_color_override("font_color", Color("6e343b") )
