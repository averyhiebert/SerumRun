extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var num_party_members = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_weather(weather):
	$ParallaxBackground/GoodAuroraLayer.visible = (weather == "aurora_good")
	$ParallaxBackground/EvilAuroraLayer.visible = (weather == "aurora_bad")
	$ParallaxBackground/CloudLayer.visible = (weather == "blizzard" or weather == "hail")
	$blizzard_particles.emitting = (weather == "blizzard")
	$hail_particles.emitting = (weather == "hail")

func set_moving(moving):
	if moving:
		$Sled.play("running")
		$Sled/trailer.play("running")
		$Sled/person2.play("running")
		$Sled/person3.play("running")
		$Sled/person4.play("running")
	else:
		$Sled.play("stopped")
		$Sled/trailer.play("stopped")
		$Sled/person2.play("stopped")
		$Sled/person3.play("stopped")
		$Sled/person4.play("stopped")
	$ParallaxBackground.stopped = not moving

func update_pm_count(count):
	num_party_members = count
	if count < 4:
		$Sled/person2.hide()
	if count < 3:
		$Sled/person3.hide()
	if count < 2:
		$Sled/person4.hide()
	if count < 2:
		$Sled/trailer.hide()
