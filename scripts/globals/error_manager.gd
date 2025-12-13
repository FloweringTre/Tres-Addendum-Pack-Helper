extends Node

var current_error : String
var is_error : bool

signal error_alert
signal error_passed

func error_print(error_text : String):
	current_error = error_text
	print("ALERT!")
	error_alert.emit()

func error_continue() -> void:
	error_passed.emit()
