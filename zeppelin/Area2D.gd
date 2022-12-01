extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal player_died

onready var DeflatedBalloon = preload("res://DeflatedBalloon.tscn")

var grav = Vector2(0, 150)
var wind_force_scalar = 80
var wind_resistance = 5
var wind_force_base = 100
var vel
var max_speed = 100
var input_vector = Vector2.ZERO
var current_force_counter
var max_force_counter = 3
var charging
var charge_dir
var can_charge
var barrier_vel = Vector2.ZERO
var target_barrier_vel = Vector2.ZERO
var barriers_active = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	vel = Vector2.ZERO
	current_force_counter = 0
	charging = false
	charge_dir = Vector2.ZERO
	can_charge = true
	pass # Replace with function body.

func _physics_process(delta):
	$Label.text = "Current Charge: " + str(current_force_counter)
	
	vel+= (grav * delta)
	#vel = vel * (wind_resistance)
	
	input_vector.x = Input.get_action_strength("wind_right") - Input.get_action_strength("wind_left")
	input_vector.y = Input.get_action_strength("wind_down") - Input.get_action_strength("wind_up")
	
	if can_charge:
		if Input.is_action_pressed("wind_up") and !charging:
			charge_dir = Vector2.UP
			start_charging()
		if Input.is_action_pressed("wind_down") and !charging:
			charge_dir = Vector2.DOWN
			start_charging()
		if Input.is_action_pressed("wind_left") and !charging:
			charge_dir = Vector2.LEFT
			start_charging()
		if Input.is_action_pressed("wind_right") and !charging:
			charge_dir = Vector2.RIGHT
			start_charging()
	
	if charging and (Input.is_action_just_released("wind_down") or Input.is_action_just_released("wind_up") or Input.is_action_just_released("wind_left") or Input.is_action_just_released("wind_right")):
		$AudioStreamPlayer.play()
		if charge_dir.y != 0:
			vel.y = 0
		vel+=(charge_dir * current_force_counter * wind_force_scalar + charge_dir * wind_force_base)
		current_force_counter = 0
		charging = false
		$Particles2D.emitting = false
		$Charge1.visible = false
		$Charge2.visible = false
		$Charge3.visible = false
		can_charge = false
		$CDTimer.start(1)
	
	#clamp movement values
	#vel.y = clamp(vel.y, -max_speed, max_speed)
	#vel.x = clamp(vel.x, -max_speed, max_speed)
	if vel.y > max_speed:
		vel.y = max_speed
	
	#apply wind resistance
	vel.x = lerp(vel.x, 0, delta * .5)
	
	if barriers_active > 0:
		barrier_vel = lerp(barrier_vel, target_barrier_vel, delta)
	else:
		barrier_vel = lerp(barrier_vel, target_barrier_vel, delta * .3)
	
	var full_vel = vel + barrier_vel
	
	move_and_slide(full_vel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start_charging():
	charging = true
	current_force_counter = 1
	$Charge1.visible = true
	$ChargeTimer.start()


func _on_ChargeTimer_timeout():
	if charging and current_force_counter < max_force_counter:
		current_force_counter+=1
		if current_force_counter == 2:
			$Charge2.visible = true
		elif current_force_counter == 3:
			$Charge3.visible = true
		$ChargeTimer.start()
	pass # Replace with function body.


func _on_CDTimer_timeout():
	$Particles2D.emitting = true
	can_charge = true
	pass # Replace with function body.


func _on_Area2D_area_entered(area):
	if area.is_in_group("barriers"):
		print("barrier entered")
		barriers_active+=1
		target_barrier_vel += (area.barrier_direction * area.barrier_strength)
	elif area.is_in_group("dangerous"):
		var deflated_balloon = DeflatedBalloon.instance()
		deflated_balloon.position = position
		get_tree().get_current_scene().add_child(deflated_balloon)
		queue_free()
		emit_signal("player_died")
	pass # Replace with function body.


func _on_Area2D_area_exited(area):
	if area.is_in_group("barriers"):
		print("barrier exited")
		barriers_active-=1
		target_barrier_vel -= (area.barrier_direction * area.barrier_strength)
	pass # Replace with function body.
