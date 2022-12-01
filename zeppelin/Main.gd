extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var score_interval = 2
var score = 0
var player_alive

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$ScoreLabel.text = "Score: 0"
	$ScoreTimer.start(score_interval)
	player_alive = true
	$Player.connect("player_died", self, "player_died")
	#get_tree().paused = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if get_tree().paused and (Input.is_action_just_pressed("wind_left") or Input.is_action_just_pressed("wind_right") or Input.is_action_just_pressed("wind_up")):
		#get_tree().paused = false
	if !player_alive and (Input.is_action_just_pressed("wind_left") or Input.is_action_just_pressed("wind_right") or Input.is_action_just_pressed("wind_up")):
		get_tree().reload_current_scene()
	pass

func player_died():
	player_alive = false
	$PlayAgainLabel.visible = true

func _on_ScoreTimer_timeout():
	if player_alive:
		score+=1
		$ScoreTimer.start(score_interval)
		$ScoreLabel.text = "Score: " + str(score)
	pass # Replace with function body.
