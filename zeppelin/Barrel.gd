extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Explosion = preload("res://Explosion.tscn")

var grav = Vector2(0, 150)
var launch_angle
var vel = Vector2.UP
var speed = 300


# Called when the node enters the scene tree for the first time.
func _ready():
	$DeathTimer.start(10)
	#launch_angle = (PI/4) - randf()/2
	#vel = Vector2.UP
	#speed = 300
	#vel = (Vector2.UP.rotated(launch_angle)) * speed
	pass # Replace with function body.

func _physics_process(delta):
	vel+= (grav * delta)
	move_and_collide(vel * delta)

func set_launch_angle():
	if global_position.x > 0:
		launch_angle = -(PI/4) + randf()/2
		vel = (Vector2.UP.rotated(launch_angle)) * speed
	else:
		launch_angle = (PI/4) - randf()/2
		vel = (Vector2.UP.rotated(launch_angle)) * speed
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	if area.is_in_group("dangerous"):
		#$AudioStreamPlayer.play()
		var explosion = Explosion.instance()
		explosion.position = position
		get_tree().get_current_scene().add_child(explosion)
		queue_free()
	pass # Replace with function body.


func _on_DeathTimer_timeout():
	queue_free()
	pass # Replace with function body.
