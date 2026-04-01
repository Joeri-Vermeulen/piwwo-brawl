extends CharacterBody2D

# ==== Constants ====
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DEFAULT_DIRECTION = "left"

# ==== Variables ====
@onready var _animated_sprite = $AnimatedSprite2D
var action = "idle" # animation: idle by default
var facing = DEFAULT_DIRECTION
var peeking = null
var is_in_cutscene = false
var is_moving = false
var is_attacking = false
var is_jumping = false
func is_falling() -> bool: return (not is_jumping) and (not is_on_floor())
func curr_anim() -> String: return _animated_sprite.animation


# ==== On Instantiate ====
func _ready() -> void:
	anim(action)


# ==== Every Frame ====
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if is_falling(): action = "fall"
	elif is_on_floor():
		is_jumping = false
	
	if not is_in_cutscene:
		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			if direction < 0: facing = "left"
			elif direction > 0: facing = "right"
			action = action if is_attacking or is_jumping or is_falling() else "move"
			is_moving = true
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			action = action if is_attacking or is_jumping or is_falling() else "idle"
			is_moving = false
		
		# Get the input peeking direction and handle peeking/swinging.
		var peek_direction := Input.get_axis("down", "up")
		if peek_direction:
			if peek_direction < 0: peeking = "down"
			elif peek_direction > 0: peeking = "up"
		else: peeking = null
		
		# Handle jump.
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			is_jumping = true
			action = "jump"
		
		# Handle attack.
		if Input.is_action_pressed("attack"):
			if not is_attacking: attack()
		
		if not is_attacking:
			anim(action)
		move_and_slide()


# ==== Assisting Functions ====
func attack() -> bool:
	is_attacking = true
	anim("attack")
	return true


# ====== Animation Functions ======
func anim(forced_action:String=action, forced_direction:String=facing) -> bool:
	if forced_direction != facing: face(forced_direction)
	var anim_name = forced_action.to_lower()
	
	if peeking and anim_name in ["idle", "attack"]: # Input = up or down
		if peeking.to_lower() == "down" and is_attacking and is_on_floor():
			anim_name += "_sweep"
		else:
			anim_name += '_' + peeking.to_lower() + ("_side" if is_moving else '')
		
	
	if curr_anim() != anim_name:
		_animated_sprite.play(anim_name)
		#print("Now animating: " + anim_name)
	
	_animated_sprite.flip_h = facing != DEFAULT_DIRECTION
	return true

func handle_anim_end() -> void: # actions like attack and jump that don't loop
	if is_jumping: is_jumping = false
	if is_attacking: is_attacking = false

# ==== Cutscene Functions ====
func flip() -> bool:
	facing = 'right' if facing == 'left' else 'left'
	return anim(_animated_sprite.animation)

func face(direction: String) -> bool:
	if direction.to_lower() == 'left' or direction.to_lower() == 'right':
		facing = direction
		return anim(_animated_sprite.animation)
	return false
func face_left() -> bool: return face('left')
func face_right() -> bool: return face('right')

func move_by_distance(distance:float, speed:float=SPEED, forced_direction:String=facing, forced_anction:String=action) -> void:
	pass
func move_by_time(time:float, speed:float=SPEED, forced_direction:String=facing, forced_anction:String=action) -> void:
	pass
func move_by_distance_and_time(distance:float, time:float, forced_direction:String=facing, forced_anction:String=action) -> void:
	pass
