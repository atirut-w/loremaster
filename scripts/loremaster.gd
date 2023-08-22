extends CharacterBody2D

var tween
@export var vertical_tile_size = 28
@export var horizontal_tile_size = 24

var vertical_step_distance = vertical_tile_size / 2
var horizontal_step_distance = horizontal_tile_size
var time_per_move = 0.3
var steps_to_move = Vector2(0,0)

func _process(delta):
	if !tween || !tween.is_running():
		
		if Input.is_action_pressed("move_down"):
			steps_to_move = Vector2(0,1)
		elif Input.is_action_pressed("move_left"):
			steps_to_move = Vector2(-1,0)
		elif Input.is_action_pressed("move_right"):
			steps_to_move = Vector2(1,0)
		elif Input.is_action_pressed("move_up"):
			steps_to_move = Vector2(0,-1)
			
		if steps_to_move == Vector2(0,0):
			$AnimatedSprite2D.play("idle")
		elif steps_to_move.x > 0:
			_move_horizontal(1)
		elif steps_to_move.x < 0:
			_move_horizontal(-1)
		elif steps_to_move.y > 0:
			_move_vertical(1)
		elif steps_to_move.y < 0:
			_move_vertical(-1)

func _move_vertical(direction):
	if direction > 0:
		$AnimatedSprite2D.play("walk_down")
	else:
		$AnimatedSprite2D.play("walk_up")
	
	tween = create_tween()
	#The duration of this tween is modified so that moving a tile vertically takes the same amount of time
	#as moving horizontally
	tween.tween_property(self, "position", position + Vector2(0,1) * direction * vertical_step_distance,time_per_move * vertical_step_distance / horizontal_step_distance)
	
	await tween.finished
	steps_to_move -= Vector2(0,direction)	
	
func _move_horizontal(direction):
	$AnimatedSprite2D.play("walk_side")
	$AnimatedSprite2D.flip_h = direction > 0
	
	tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(1,0) * direction * horizontal_step_distance,time_per_move)
	
	await  tween.finished
	steps_to_move -= Vector2(direction,0)
