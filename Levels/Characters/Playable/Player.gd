class_name Player
extends CharacterBody2D

@export var speed: float = 100
@export var air_speed: float = 120

@export var gravity: float = 900
@export var max_fall_gravity: float = 320
@export var max_jump_gravity: float = 160

@export var jump_force: float = 245

var can_jump: bool
var jump_buffered: bool
var can_coyote_jump: bool
var has_jumped: bool
var jump_ended_fast: bool

var debug_move: bool 

var keys: int = 0

@export var debug_mode: bool

var in_ladder: int
var is_climbing: bool
var climb_speed: int = 64

var crystal: Area2D

var current_state: PlayerStates = PlayerStates.Idle
var last_state: PlayerStates

enum PlayerStates {
	Idle,
	Walk,
	Fall,
	Jump,
	Debug,
	Climb
}

func _ready() -> void:
	if debug_mode == true:
		$StateDisplay.visible = true

func _process(delta: float) -> void:
	var input_axis = Input.get_axis("left","right")
	
	if not is_climbing:
		velocity.y += gravity * delta
	
	
	if velocity.y < 0:
		velocity.y = min(max_jump_gravity,velocity.y)
	else:
		velocity.y = min(max_fall_gravity,velocity.y)
	
	last_state = current_state
	update_state()
	
	if (current_state == PlayerStates.Idle or current_state == PlayerStates.Walk):
		can_jump = true
		has_jumped = false
		jump_ended_fast = false
		velocity.x = input_axis * speed
	else:
		velocity.x = input_axis * air_speed
	
	handle_climb()
	handle_jump()
	handle_debug()
	
	move_and_slide()
	
	if (last_state == PlayerStates.Idle or last_state == PlayerStates.Walk) and current_state == PlayerStates.Fall and not has_jumped:
		can_jump = false
		can_coyote_jump = true
		$CoyoteJumpTimer.start()
	
	
	if input_axis > 0:
		$Sprite.flip_h = false
		$Keys.scale.x = 1
		$Keys/KeyCount.scale.x = 1
		
	elif input_axis < 0:
		$Sprite.flip_h = true
		$Keys.scale.x = -1
		$Keys/KeyCount.scale.x = -1

func update_keys() -> void:
	$Keys/Sprite.call_deferred("set_visible",false)
	$Keys/KeyCount.call_deferred("set_visible",false)
	if keys == 1:
		$Keys/Sprite.call_deferred("set_visible",true)
	elif keys > 1:
		$Keys/KeyCount.call_deferred("set_visible",true)
		$Keys/KeyCount.text = keys

func update_state() -> void:
	if self.debug_move == true:
		current_state = PlayerStates.Debug
	elif is_climbing:
		current_state = PlayerStates.Climb
	elif self.is_on_floor():
		if velocity.x == 0:
			current_state = PlayerStates.Idle
		else:
			current_state = PlayerStates.Walk
	else:
		if velocity.y > 0:
			current_state = PlayerStates.Fall
		else: current_state = PlayerStates.Jump
	match current_state:
		PlayerStates.Idle:  
			$StateDisplay.text = "Idle"
			$AnimationPlayer.play("Idle")
		PlayerStates.Fall:  
			$StateDisplay.text = "Fall"
			$AnimationPlayer.play("Fall")
		PlayerStates.Jump:  
			$StateDisplay.text = "Jump"
			$AnimationPlayer.play("Fall")
		PlayerStates.Walk:  
			$StateDisplay.text = "Walk"
			$AnimationPlayer.play("Walk")
		PlayerStates.Debug: 
			$StateDisplay.text = "Debug"
			$AnimationPlayer.play("Idle")
		PlayerStates.Climb: 
			$StateDisplay.text = "Climb"
			$AnimationPlayer.play("Climb")

func handle_jump() -> void:
	if (Input.is_action_just_pressed("jump") or jump_buffered) and (can_jump or can_coyote_jump):
		can_jump = false
		can_coyote_jump = false
		velocity.y = -jump_force
		has_jumped = true
	elif Input.is_action_just_pressed("jump") and not (can_coyote_jump or can_jump):
		jump_buffered = true
		$JumpBufferTimer.start()
	
	if Input.is_action_just_released("jump") and not jump_ended_fast and velocity.y < 0:
		velocity.y = velocity.y / 3
		jump_ended_fast = true
	
	if crystal != null:
		crystal.recharge(self)

func handle_debug() -> void:
	if debug_mode == true: 
		if Input.is_action_just_pressed("debug_toggle"):
			debug_move = !debug_move
			if debug_move == false:
				$Collision.call_deferred("set_disabled",false)
			else:
				$Collision.call_deferred("set_disabled",true)
	if debug_move:
		self.velocity = Input.get_vector("left","right","up","down").normalized() * air_speed

func handle_climb() -> void:
	if in_ladder > 0:
		if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
			is_climbing = true
		if (Input.is_action_pressed("up") or Input.is_action_pressed("down")) and current_state == PlayerStates.Fall:
			is_climbing = true
		if is_climbing:
			if Input.is_action_pressed("down"):
				velocity.y = climb_speed
			if Input.is_action_pressed("up"):
				velocity.y = -climb_speed
			if Input.is_action_just_released("down") or Input.is_action_just_released("up"):
				velocity.y = 0
	if in_ladder == 0 or (in_ladder && Input.is_action_just_pressed("jump")):
		is_climbing = false
	if is_climbing == true:
		position.x = (floori(position.x / 16) * 16) + 7
		velocity.x = 0
		can_jump = true

func _on_coyote_jump_timer_timeout() -> void:
	can_coyote_jump = false

func _on_jump_buffer_timer_timeout() -> void:
	jump_buffered = false
