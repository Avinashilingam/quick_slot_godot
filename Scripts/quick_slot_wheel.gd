extends Node2D

@export var num_slots := 5
@export var slot_scene: PackedScene
@onready var slots = [] # List to hold slot instances
var current_selected := 0 # Currently highlighted slot index

func _ready():
	hide() # start hidden
	create_slots()

func _input(_event):
	# Only handle input when the wheel is visible
	if not visible:
		return
		
	if Input.is_action_just_pressed("rotate_left"):
		rotate_selection(-1) # Move left
	elif Input.is_action_just_pressed("rotate_right"):
		rotate_selection(1) # Move right

func create_slots():
	# Center the wheel around the player's sprite
	var player = get_parent() # assuming this wheel is a child of the player
	var sprite = player.get_node("AnimatedSprite2D")
	var center = sprite.position # Use sprite's position as center
	var radius = 35 # distance from center to slots
	var slot_scale = 0.5 # smaller size
	
	for i in range(num_slots):
		var slot = slot_scene.instantiate()
		add_child(slot)
		
		# Position slots in a semi-circle above player (-PI to 0)
		var angle = lerp(-PI, 0.0, i / float(num_slots - 1))
		var pos = center + Vector2(cos(angle), sin(angle)) * radius
		slot.position = pos
		
		# Scale down slot so it doesn't look huge
		slot.scale = Vector2(slot_scale, slot_scale)
		
		# Store the slot in our array
		slots.append(slot)
		
		# Optional: store index for highlighting later
		slot.set_meta("slot_index", i)
	
	# Highlight the first slot by default
	update_slot_highlights()

func open_wheel():
	show()
	update_slot_highlights() # Refresh highlights when opening

func close_wheel():
	hide()

func rotate_selection(direction: int):
	# Move selection left (-1) or right (+1)
	current_selected = (current_selected + direction) % num_slots
	if current_selected < 0:
		current_selected = num_slots - 1
	update_slot_highlights()

func update_slot_highlights():
	for i in range(slots.size()):
		if i == current_selected:
			# Highlighted slot: bigger scale, full alpha
			slots[i].scale = Vector2(0.7, 0.7) # Bigger than default 0.5
			slots[i].modulate = Color(1, 1, 1, 1.0) # Full alpha
		else:
			# Non-highlighted slots: normal scale, faded
			slots[i].scale = Vector2(0.5, 0.5) # Normal scale
			slots[i].modulate = Color(1, 1, 1, 0.6) # Faded alpha

func get_selected_slot_index() -> int:
	return current_selected