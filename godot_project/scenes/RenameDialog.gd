extends Control


var whose_name = "p1" # Whose name will this dialog overwrite? As a party member string id

signal name_changed(who, new_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	#activate("p1")
	pass # Replace with function body.

func activate(who, current_name):
	whose_name = who
	$WindowDialog/LineEdit.text = current_name
	$WindowDialog.popup()


func _on_Button_pressed():
	# Emit result of data entry as a signal, and close the window
	var new_name = $WindowDialog/LineEdit.text
	if len(new_name) > 0:
		emit_signal("name_changed", whose_name, new_name)
