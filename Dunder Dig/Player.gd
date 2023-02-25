extends KinematicBody2D


const UP_DIRECTION = Vector2.UP




export (int) var speed = 400
export (float) var jump_strength = 1500.0
export (int) var maximum_jumps = 2
export (float) var double_jump_strength = 1400.0
export (int) var gravity = 4500.0


var _jumps_made = 0
var _velocity = Vector2.ZERO



func _physics_process(delta):
	var _horitzontal_direction = (
		Input.get_action_strength('ui_right') 
		- Input.get_action_strength('ui_left')
	)
	
	_velocity.x = _horitzontal_direction * speed
	_velocity.y += gravity * delta
	
	
	var is_falling := bool(_velocity.y > 0.0 and not is_on_floor())
	var is_jumping := Input.is_action_just_pressed('ui_up') and is_on_floor()
	var is_double_jumping := Input.is_action_just_pressed('ui_up') and is_falling
	var is_jump_canceled := bool(Input.is_action_just_pressed('ui_up') and _velocity.y < 0.0)
	var is_idling := is_on_floor() and is_zero_approx(_velocity.x)
	var is_running := is_on_floor() and not is_zero_approx(_velocity.x)
	
	if is_jumping:
		_jumps_made += 1
		_velocity.y += jump_strength * -1
		
	elif is_double_jumping:
		_jumps_made += 1
		if _jumps_made <= maximum_jumps:
			_velocity.y += double_jump_strength * -1
			
	elif is_jump_canceled:
		_velocity.y = 0.0
	
	elif is_idling or is_running:
		_jumps_made = 0
	
	_velocity = move_and_slide(_velocity, UP_DIRECTION)
	
