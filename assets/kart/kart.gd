extends CharacterBody3D
class_name Kart;

@export var maxForwardSpeed : float = 3.0;
@export var maxReverseSpeed : float = 1.5;
@export var maxTurnSpeed : float = 1.0;
@export var turnDampeningSpeed : float = 10.0;
@export var accelerationSpeed : float = 3.0;

var currentAngle : float = 0.0;
var currentTurning : float = 0.0;
var currentVelocity : float = 0.0;

func getAccelerationInput(): return 0;
func getTurningInput(): return 0;

func _physics_process(delta): 
	handleAcceleration(delta);
	handleTurning(delta);
	#
	handleSprite();
	handleParticles();
	#
	handleMoveAndSlide();
	
###################################################################################

func handleAcceleration(delta):
	var accelerationInput : float = getAccelerationInput() * getSpeedMultiplier();
	
	if (accelerationInput >= 0): accelerationInput *= maxForwardSpeed;
	else: accelerationInput *= maxReverseSpeed;
	currentVelocity = move_toward(currentVelocity, accelerationInput, accelerationSpeed * delta);

func handleTurning(delta):
	var turningInput : float = getTurningInput();
	turningInput *= currentVelocity;
	
	currentTurning = move_toward(currentTurning, turningInput, delta * turnDampeningSpeed);
	
	currentAngle += currentTurning * delta * maxTurnSpeed;
	currentAngle = normalizeAngle(currentAngle);
	
func normalizeAngle(angle : float) -> float:
	while (angle >= TAU): angle -= TAU;
	while (angle < 0.0): angle += TAU;
	return angle;
	
func getAngleChange(a : float, b : float) -> float:
	var atb = b - (TAU + a);
	var bat = b - (a - TAU);
	var ba = b - a;
	
	if (abs(atb) <= abs(bat)):
		if (abs(atb) <= abs(ba)):
			return atb;
	elif (abs(bat) <= abs(ba)):
		return bat;
	return ba;
	
func handleSprite():
	rotation.y = currentAngle;
	
func handleParticles():
	var particleAmount : float = absf(currentVelocity) * abs(currentTurning) * 10.0;	
	if (currentTurning == 0):
		particleAmount = 0;
		
	var turningLeft : bool = currentTurning >= 0.0;
	var color : Color = getGroundType().lerp(Color.WHITE, 0.25);
	
	setParticleEmitter($TireSmoke_Left1, turningLeft, particleAmount * 0.5, color);
	setParticleEmitter($TireSmoke_Left2, !turningLeft, particleAmount, color);
	setParticleEmitter($TireSmoke_Right1, !turningLeft, particleAmount * 0.5, color);
	setParticleEmitter($TireSmoke_Right2, turningLeft, particleAmount, color);
	
func setParticleEmitter(emitter : ParticleEmitter, active : bool, rate : float, color : Color):
	if (active && rate <= 0.0): active = false;
	emitter.active = active;
	emitter.emissionsPerSecond = rate;
	emitter.color = color;
	
func handleMoveAndSlide():
	var forwardMotion : Vector3 = Vector3(-sin(currentAngle), 0, -cos(currentAngle)) * currentVelocity;
	velocity = forwardMotion;
	move_and_slide();

###################################################################################

@export var checkpointParent : Node3D;

var currentCheckpoint : int = 0;
func getNextCheckpoint():
	if (!checkpointParent): return -1;
	var checkpoint : int = currentCheckpoint + 1;
	while (checkpoint >= checkpointParent.get_child_count()):
		checkpoint -= checkpointParent.get_child_count();
	return checkpoint;

func onCheckpointEnter(checkpointIndex : int):
	var nextCheckpoint : int = getNextCheckpoint();
	if (checkpointIndex == nextCheckpoint):
		currentCheckpoint = checkpointIndex;
	elif (checkpointIndex != currentCheckpoint): 
		getLakisuedNerd();
		
func getLakisuedNerd():
	var checkpoint : Node3D = checkpointParent.get_child(currentCheckpoint);
	position = checkpoint.global_position;
	currentAngle = checkpoint.global_rotation.y;

###################################################################################

@export var trackSprite : Sprite3D;
func getSpeedMultiplier():
	var groundColor = getGroundType();
	if (groundColor == null || typeof(groundColor) != TYPE_COLOR): return 0.1;
	if (groundColor != Color("ffaa77")): return 0.3;
	return 1.0;
func getGroundType():
	if (!trackSprite): return 0;
	
	var trackSize : Vector2 = trackSprite.texture.get_size() * trackSprite.pixel_size;
	var topLeft : Vector3 = Vector3(trackSize.x, 0, trackSize.y) * -0.5;
	var relativePosition : Vector3 = Vector3(position.x - trackSprite.position.x, 0, position.z - trackSprite.position.z) - topLeft;
	
	var pixelLocation : Vector3i = relativePosition / trackSprite.pixel_size;
	if (pixelLocation.x < 0 || pixelLocation.x >= trackSprite.texture.get_width() || 
		pixelLocation.z < 0 || pixelLocation.z >= trackSprite.texture.get_height()):
		return null;
		
	return trackSprite.texture.get_image().get_pixel(pixelLocation.x, pixelLocation.z);

###################################################################################

@export var maxHealth : float = 100.0;
@onready var currentHealth : float = maxHealth;

@export var lightDamage : float = 9.0;
@export var mediumDamage : float = 22.0;
@export var heavyDamage : float = 22.0;

func takeDamage(damage : float):
	currentHealth -= damage;
	if (currentHealth <= 0.0):
		queue_free();
		return;
	
	$HealthBar.frame = (currentHealth / maxHealth) * $HealthBar.hframes;
