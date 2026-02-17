extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -200.0

@onready var sprite = $Sebby_Sprite  # Reference to your sprite
#@onready var walking_sound = $WalkingSound  # Reference to the sound

var bob_time = 0.0
var original_y_position = 0.0

func _ready():
	add_to_group("player")
	# Store the sprite's original Y position
	original_y_position = sprite.position.y

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump with W
	#if Input.is_key_pressed(KEY_W) and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	
	# Get the input direction with A and D
	var direction = 0
	if Input.is_key_pressed(KEY_D):
		direction += 1
	if Input.is_key_pressed(KEY_A):
		direction -= 1
	
	# Flip the sprite based on direction
	if direction > 0:
		sprite.flip_h = true  # Facing right
	elif direction < 0:
		sprite.flip_h = false   # Facing left
	
	# Walking bob animation and sound
	if direction != 0 and is_on_floor():
		bob_time += delta * 10  # Speed of the bob (higher = faster)
		sprite.position.y = original_y_position + sin(bob_time) * 3  # Bob up and down 3 pixels
		
		# Play walking sound if not already playing
		#if not walking_sound.playing:
			#walking_sound.play()
	else:
		# Reset to original position when not moving
		bob_time = 0.0
		sprite.position.y = original_y_position
		
		# Stop walking sound
		#if walking_sound.playing:aaaaaaaa
			#walking_sound.stop()
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
