extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Rock = preload("res://Rock.tscn")
onready var BirdExplosion = preload("res://BirdExplosion.tscn")

var vel = Vector2.UP
var speed = 300
var has_rocked = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$DeathTimer.start(10)
	#launch_angle = (PI/4) - randf()/2
	#vel = Vector2.UP
	#speed = 300
	#vel = (Vector2.UP.rotated(launch_angle)) * speed
	pass # Replace with function body.

func _physics_process(delta):
	position+= (vel * delta)

func set_launch_angle():
	if global_position.x > 0:
		vel = Vector2.LEFT * speed
		$Sprite.flip_h = true
	else:
		vel = Vector2.RIGHT * speed
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Bird_area_entered(area):
	var bird_explosion = BirdExplosion.instance()
	bird_explosion.position = position
	get_tree().get_current_scene().add_child(bird_explosion)
	queue_free()
	pass # Replace with function body.


func _on_DropArea_area_entered(area):
	if !has_rocked:
		$AudioStreamPlayer.play()
		var rock = Rock.instance()
		rock.position = position + Vector2(0, 50)
		get_tree().get_current_scene().add_child(rock)
		has_rocked = true
	pass # Replace with function body.


func _on_DeathTimer_timeout():
	queue_free()
	pass # Replace with function body.
