extends CharacterBody2D

@export var animated_sprite : AnimatedSprite2D
@export var ray_cast: RayCast2D 

const SPEED := 5000.0
var state :String = "idle"
var dir : String ="down"

func _physics_process(delta: float) -> void:
	if OverworldDialogManager.started :
		return

	process_move(delta)
	process_animation()
	process_action()
	move_and_slide()

func process_move(delta:float) -> void:
	var move_dir : Vector2 = Input.get_vector("left","right","up","down").normalized()
	if move_dir != Vector2.ZERO:
		velocity = move_dir * SPEED * delta
		ray_cast.target_position =move_dir * 20#此处×25是因为move_dir模长为1
		state = "move"
	else :
		velocity = Vector2.ZERO 
		state = "idle"
		
func process_animation() -> void:
	if velocity.x != 0 :
		if velocity.x > 0 : dir = "right"
		elif velocity.x < 0 : dir = "left"
	elif velocity.y != 0 :
		if velocity.y > 0 : dir = "down"
		elif velocity.y < 0 : dir = "up"
	var x : String = state + "_" + dir
	animated_sprite.play(x)
	
func process_action() -> void :
	if Input.is_action_just_pressed("confirm") :
		var collider : Object = ray_cast.get_collider()
		if collider is OverworldObject :
			collider.call("_on_player_action")
