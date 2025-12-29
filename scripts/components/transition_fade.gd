extends CanvasLayer

@onready var background: Control = $background
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label

signal transition_finished

func _ready() -> void:
	background.visible = false
	label.visible = false
	animation_player.animation_finished.connect(on_animation_finished)


func on_animation_finished(anim_name) -> void:
	if anim_name == "fade_dark":
		transition_finished.emit()
		animation_player.play("fade_normal")
	elif anim_name == "fade_normal":
		background.visible = false
		label.visible = false

func transition() -> void:
	background.visible = true
	animation_player.play("fade_dark")

func text_transition(scene_label : String) -> void:
	label.text = scene_label
	label.visible = true
	background.visible = true
	animation_player.play("fade_dark")
	
