extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Barrel = preload("res://Barrel.tscn")

var time_between_barrels
var time_decrease = 1
var barrel_count = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	time_between_barrels = 5
	$BarrelTimer.start(time_between_barrels)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BarrelTimer_timeout():
	barrel_count+=1
	if barrel_count%5 == 0 and time_between_barrels > 1:
		time_between_barrels-=time_decrease
	var barrel = Barrel.instance()
	var barrel_spawns = get_tree().get_nodes_in_group("barrel_positions")
	barrel.global_position = barrel_spawns[randi()%barrel_spawns.size()].position
	barrel.set_launch_angle()
	get_tree().get_current_scene().add_child(barrel)
	$BarrelTimer.start(time_between_barrels)
	pass # Replace with function body.
