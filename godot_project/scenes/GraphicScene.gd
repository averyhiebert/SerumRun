extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


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
		$AnimatedSprite.play("running")
	else:
		$AnimatedSprite.play("stopped")
	$ParallaxBackground.stopped = not moving
