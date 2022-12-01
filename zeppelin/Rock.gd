extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var vel_vector = Vector2(0, 150)

# Called when the node enters the scene tree for the first time.
func _ready():
	$DeathTimer.start(10)
	pass # Replace with function body.

func _physics_process(delta):
	position+= (vel_vector * delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DeathTimer_timeout():
	queue_free()
	pass # Replace with function body.


func _on_Rock_area_entered(area):
	if area.is_in_group("dangerous"):
		$AudioStreamPlayer.play()
	pass # Replace with function body.
