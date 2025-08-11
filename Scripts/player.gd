extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var quickslot_wheel = $QuickSlotWheel
const SPEED = 100.0
const JUMP_VELOCITY = -400.0
@onready var quickslot_open = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = false if direction > 0 else true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.flip_h = true if velocity.x < 0 else false

	move_and_slide()

func _input(_event):
	if Input.is_action_just_pressed("show_quickslot"):
		quickslot_open = !quickslot_open  # Toggle the boolean
		if quickslot_open:
			quickslot_wheel.open_wheel()
			velocity = Vector2.ZERO  # Optional: stop movement
		else:
			quickslot_wheel.close_wheel()
