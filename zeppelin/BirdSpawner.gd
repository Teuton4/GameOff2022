extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Bird = preload("res://Bird.tscn")

var time_between_birds


# Called when the node enters the scene tree for the first time.
func _ready():
	time_between_birds = 5
	$BirdTimer.start(time_between_birds + 2.5)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_BirdTimer_timeout():
	var bird = Bird.instance()
	var bird_spawns = get_tree().get_nodes_in_group("bird_positions")
	bird.global_position = bird_spawns[randi()%bird_spawns.size()].position
	bird.set_launch_angle()
	get_tree().get_current_scene().add_child(bird)
	$BirdTimer.start(time_between_birds)
	pass # Replace with function body.
