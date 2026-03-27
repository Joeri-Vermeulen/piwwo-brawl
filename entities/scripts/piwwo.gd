extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DEFAULT_DIRECTION = "right"

@onready var _animated_sprite = $AnimatedSprite2D
var action = "idle" # animation: idle by default
var facing = DEFAULT_DIRECTION
var is_in_cutscene = false

# once instantiated
func _ready() -> void:
	anim(action)

# every frame
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if not is_in_cutscene:
		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			if direction < 0: facing = "left"
			elif direction > 0: facing = "right"
			action = "move"
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			action = "idle"
		
		# Handle jump.
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			action = "jump"
		
		if anim(action):
			pass
		move_and_slide()

# animation function
func anim(forced_action:String=action, forced_direction:String=facing) -> bool:
	face(forced_direction) if forced_direction != facing else null
	var anim_name = forced_action.to_lower()
	if _animated_sprite.animation != anim_name:
		_animated_sprite.play(anim_name)
	_animated_sprite.flip_h = facing != DEFAULT_DIRECTION # uncomment if there are no seperate left/right sprites
	return true

# maybe useful for cutscenes
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
