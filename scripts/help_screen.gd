extends Control

func _ready() -> void:
	$".".visible = true
	$FAQ.visible = false
	$CREDITS.visible = false
	ErrorManager.error_alert.connect(on_error)
	ErrorManager.error_passed.connect(on_error_passed)
	$versionLabel.visible = true
	$TextureButton.visible = true
	GlobalScripts.replace_version_placeholder(%versionLabel)

func _on_texture_button_pressed() -> void:
	$AnimationPlayer.play("open_faq")


func _on_back_button_pressed() -> void:
	$AnimationPlayer.play("exit_faq")

func on_error() -> void:
	$TextureButton.disabled = true
	%backButton.disabled = true
	%creditsbackButton.disabled = true
	%creditsbutton.set_disabled()

func on_error_passed() -> void:
	$TextureButton.disabled = false
	%backButton.disabled = false
	%creditsbackButton.disabled = false
	%creditsbutton.reenable_button()

func _on_creditsbutton_button_pressed() -> void:
	$AnimationPlayer.play("open_credits")

func _on_creditsback_button_pressed() -> void:
	$AnimationPlayer.play("exit_credits")
