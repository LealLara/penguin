extends CharacterBody2D

enum SkeletonState{
	walk,
	attack,
	hurt
}
@onready var colli : CollisionShape2D = $CollisionShape2D 

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var player_detector: RayCast2D = $PlayerDetector

 
const SPEED = 10.0
const JUMP_VELOCITY = -400.0
var direction = 1
var status: SkeletonState

func _ready() -> void:
	go_to_walk_state()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
 
	match status:
		SkeletonState.walk:
			walk_state(delta)
		SkeletonState.attack:
			attack_state(delta)
		SkeletonState.hurt:
			hurt_state(delta)
	

	move_and_slide()

func go_to_walk_state(): 
	status = SkeletonState.walk
	anim.play("walk")
	
func go_to_attack_state():
	status = SkeletonState.attack
	anim.play("attack")
	velocity = Vector2.ZERO
	
func go_to_hurt_state():
	status = SkeletonState.hurt
	anim.play("hurt") 
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED 
	hitbox.monitoring = false
	#colli.set_deferred("disabled", true)
	#var hitbox_shape = hitbox.get_node("CollisionShape2D")
	#hitbox_shape.set_deferred("disabled", true)
	velocity = Vector2.ZERO
	call_deferred("set_small_collider")
	#hitbox.collision_layer = -1 
	#colli.disabled = true  
	
func walk_state(_delta):
	velocity.x = SPEED * direction
	
	if wall_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		
	if !ground_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		
	if player_detector.is_colliding():
		go_to_attack_state()
		return
	
func attack_state(_delta):
	pass

func hurt_state(_delta):
	pass
	
func take_damage():
	go_to_hurt_state() 
 
func set_small_collider():
	colli.shape = colli.shape.duplicate()
		
	if colli.shape is CapsuleShape2D:
		colli.shape.radius = 0
		colli.shape.height = 0
	
	colli.position.y = 15
	return 

#func set_small_collider(): //também funciona, mas é menos preciso
	#colli.scale = Vector2(0,0)

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation ==  "attack":
		go_to_walk_state()
		return
