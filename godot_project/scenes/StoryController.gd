# warning-ignore-all:return_value_discarded

extends Node

var InkPlayer = load("res://addons/inkgd/ink_player.gd")

# Alternatively, it could also be retrieved from the tree.
# onready var _ink_player = $InkPlayer
onready var _ink_player = InkPlayer.new()

# Label in which to insert the text/choices
#onready var text_target:RichTextLabel = get_node("UILayer/VBoxContainer/TabContainer/Adventure")
onready var text_target:RichTextLabel = $UILayer/VBoxContainer/TabContainer/Journey
onready var event_log:RichTextLabel = get_node("UILayer/VBoxContainer/TabContainer/Event Log")
onready var info_tab:RichTextLabel = get_node("UILayer/VBoxContainer/TabContainer/Status")
onready var graphic_scene = $UILayer/VBoxContainer/ViewportContainer/Viewport/GraphicScene

var text_before_choices = ""
# ############################################################################ #
# Lifecycle
# ############################################################################ #

func _ready():
	# Set up text box.
	text_target.bbcode_text = ""
	text_target.clear()
	text_target.connect("meta_clicked", self, "_select_choice")
	
	# Adds the player to the tree.
	add_child(_ink_player)

	# Replace the example path with the path to your story.
	# Remove this line if you set 'ink_file' in the inspector.
	_ink_player.ink_file = load("res://story/main.ink.json")

	# It's recommended to load the story in the background. On platforms that
	# don't support threads, the value of this variable is ignored.
	_ink_player.loads_in_background = true

	_ink_player.connect("loaded", self, "_story_loaded")
	_ink_player.connect("continued", self, "_continued")
	_ink_player.connect("prompt_choices", self, "_prompt_choices")
	_ink_player.connect("ended", self, "_ended")

	# Creates the story. 'loaded' will be emitted once Ink is ready
	# continue the story.
	_ink_player.create_story()

# ############################################################################ #
# Signal Receivers
# ############################################################################ #

func _story_loaded(successfully: bool):
	if !successfully:
		return

	_observe_variables()
	_bind_externals()

	# Here, the story is started immediately, but it could be started
	# at a later time.
	_ink_player.continue_story()


func _continued(text, tags):
	var formatting = "%s"
	var do_log = false # We append "good" and "bad" notifications to event log.
	
	if "CLEAR" in tags:
		# Clear before next line.
		text_target.bbcode_text = ""
		text_target.clear()
	
	if "good" in tags:
		do_log = true
		formatting = "[color=green]%s[/color]"
	elif "bad" in tags:
		do_log = true
		formatting = "[color=red]%s[/color]"
	text_target.append_bbcode(formatting % text)
	
	# Note: not working at all, not sure why
	text_before_choices = text_target.bbcode_text # Save state prior to adding buttons
	
	if do_log:
		event_log.append_bbcode(formatting % text)
	
	# Here you could yield for an hypothetical signal, before continuing.
	# yield(self, "event")
	_ink_player.continue_story()


# ############################################################################ #
# Private Methods
# ############################################################################ #

func _prompt_choices(choices):
	text_target.append_bbcode("\n")
	if !choices.empty():
		var index = 0
		for choice in choices:
			if not (choice.begins_with("((") and choice.ends_with("))")):
				# (note: I adopt the convention that (( )) means a text-mode-only option
				text_target.append_bbcode("[center][url=%d]%s[/url][/center]\n\n" % [index, choice])
			index += 1

		# In a real world scenario, _select_choice' could be
		# connected to a signal, like 'Button.pressed'.
		# _select_choice(0)


func _ended():
	print("The End")


func _select_choice(index):
	# Erase choices but leave text from before the choices?
	# text_target.bbcode_text = text_before_choices
	# Note: above line not working, instead just clearing window after each choice.
	# That behaviours is *good enough*, so I'll just use it explicitly.
	text_target.clear()
	
	_ink_player.choose_choice_index(int(index))
	_ink_player.continue_story()


# Uncomment to bind an external function.
#
func _bind_externals():
	_ink_player.bind_external_function("name", self, "_party_member_name")

func _party_member_name(party_member):
	var id = str(party_member)
	# TODO Properly set/get names
	var names = {
		"p1": "Alice",
		"p2": "Bob",
		"p3": "Charlie",
		"p4": "Devon"
	}
	if id in names:
		return names[id]
	return "Missingno"


# Uncomment to observe the variables from your ink story.
# You can observe multiple variables by putting adding them in the array.
func _observe_variables():
	_ink_player.observe_variables(["weather"], self, "_weather_changed")
	_ink_player.observe_variables(["currently_moving"], self, "_moving_changed")
#

func _weather_changed(variable_name,new_value):
	# TODO Use signal instead
	graphic_scene.change_weather(str(new_value))

func _moving_changed(variable_name,new_value):
	print(new_value == true)
	graphic_scene.set_moving(new_value)
	



func _on_TabContainer_tab_changed(tab):
	# Populate the info t
	if (tab == 1):
		# We have switched to the info tab, so let's populate it.
		info_tab.clear()
		info_tab.append_bbcode("[center][u]Inventory[/u][/center]\n\n")
		info_tab.append_bbcode("[center]%s[/center]\n\n" % str(_ink_player.get_variable("inventory")))
		
		info_tab.append_bbcode("[center][u]Party Member Status[/u][/center]\n\n")
		var party_members = _ink_player.get_variable("party")
		
		var conditions = [
			"cold","tired","hungry",
			"dysentery","broken_leg","hypothermic",
			"exhausted","starving","broken_nose",
			"in_pain","traumatized","terrified",
			"stressed","agitated","bruised",
			"guilty"
		]
		for pm in ["p1","p2","p3","p4"]:
			var status_effects = [] # Check which effects this party member has
			for condition in conditions:
				var inklist = _ink_player.get_variable(condition)
				# Bad hack, but the API for ink lists isn't documented : (
				#  and I don't have time to look up the source code
				if pm in str(inklist):
					status_effects.append(condition.replace("_"," "))
			var infostring = PoolStringArray(status_effects).join(", ")
			
			# Results in bizarre bug, for some reason.
			#var risk_of_death = _ink_player.evaluate_function("risk_of_death",[pm]).return_value
			#if risk_of_death:
			#	info_tab.append_bbcode("[color=red][u]%s:[/u][/color]\t" % _party_member_name(pm))
			info_tab.append_bbcode("[u]%s:[/u]\t" % _party_member_name(pm))
			info_tab.append_bbcode("%s\n\n" % infostring)
