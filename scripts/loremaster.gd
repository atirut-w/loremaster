extends CharacterBody2D

var tween
var vertical_distance_per_move = 14
var horizontal_distance_per_move = 24
var time_per_move = 0.3

func _process(delta):
	if !tween || !tween.is_running():
		
		if Input.is_action_pressed("move_down"):
			$AnimatedSprite2D.play("walk_down")
			
			_move_vertical(1)
		elif Input.is_action_pressed("move_left"):
			$AnimatedSprite2D.play("walk_side")
			$AnimatedSprite2D.flip_h = false
			
			_move_horizontal(-1)
		elif Input.is_action_pressed("move_right"):
			$AnimatedSprite2D.play("walk_side")
			$AnimatedSprite2D.flip_h = true
			
			_move_horizontal(1)
		elif Input.is_action_pressed("move_up"):
			$AnimatedSprite2D.play("walk_up")
			
			_move_vertical(-1)
		else:
			$AnimatedSprite2D.play("idle")

func _move_vertical(direction):
	tween = create_tween()
	
	tween.tween_property(self, "position", position + Vector2(0,1) * direction * vertical_distance_per_move,time_per_move * vertical_distance_per_move / horizontal_distance_per_move)
	
	
func _move_horizontal(direction):
	tween = create_tween()
	
	tween.tween_property(self, "position", position + Vector2(1,0) * direction * horizontal_distance_per_move,time_per_move)
