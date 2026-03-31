extends CharacterBody2D

# ==== Constants ====
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DEFAULT_DIRECTION = "left"

# ==== Variables ====
@onready var _animated_sprite = $AnimatedSprite2D
var action = "idle" # animation: idle by default
var facing = DEFAULT_DIRECTION
var is_in_cutscene = false
var is_jumping = false
var is_falling = false


# ==== On Instantiate ====
func _ready() -> void:
	anim(action)


# ==== Every Frame ====
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		is_falling = not is_jumping
	elif is_on_floor() and (is_jumping or is_falling):
		is_jumping = false
		is_falling = false
	
	if not is_in_cutscene:
		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			if direction < 0: facing = "left"
			elif direction > 0: facing = "right"
			action = "jump" if is_jumping else "fall" if is_falling else "move"
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			action = "jump" if is_jumping else "fall" if is_falling else "idle"
		
		# Handle jump.
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			is_jumping = true
			action = "jump"
		
		if anim(action):
			pass
		move_and_slide()


# ==== Assisting Functions ====
#


# ====== Animation Functions ======
func anim(forced_action:String=action, forced_direction:String=facing) -> bool:
	face(forced_direction) if forced_direction != facing else null
	var anim_name = forced_action.to_lower()
	if _animated_sprite.animation != anim_name:
		_animated_sprite.play(anim_name)
	_animated_sprite.flip_h = facing != DEFAULT_DIRECTION
	return true

func jump_to_fall() -> void:
	if is_jumping:
		is_jumping = false
		#is_falling = true # happens automatically in _physics_process

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
