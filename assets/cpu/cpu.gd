extends Kart

var itemCooldown : float = 0.0;

func getAccelerationInput(): return 1;
func getUseItemInput(): 
	if (itemCooldown > 0.0): return 0;
	itemCooldown = 2.0;
	return 1;

var lastCheckpoint : int = 0;
var targetPoint : Vector3 = Vector3.ZERO;

func _ready():
	$Sprite.texture = CharacterChoice.takeCPUSprite();

func _process(delta):
	if (itemCooldown > 0 && itemType != 0):
		itemCooldown -= delta;
	
func onDeath(sender : Kart):
	if (sender.name == "Player"):
		CharacterChoice.unlockChoice(CharacterChoice.getSpriteIndex($Sprite.texture));

func getTurningInput(): 
	if (!checkpointParent): return 0;
	
	var targetCheckpoint : int = getNextCheckpoint();
	if (targetCheckpoint != lastCheckpoint):
		lastCheckpoint = targetCheckpoint;
		
		var checkpoint : Node3D = checkpointParent.get_child(lastCheckpoint);		
		targetPoint = checkpoint.global_position
		targetPoint += Vector3(cos(checkpoint.global_rotation.y), 0, sin(checkpoint.global_rotation.y)) * randf_range(-1, 1) * 0.5;
	
	var to : Vector3 = global_position - targetPoint;
	var targetAngle : float = (0.25 * TAU) - atan2(to.z, to.x);
	targetAngle = normalizeAngle(targetAngle);
	
	return clampf(getAngleChange(currentAngle, targetAngle), -1, 1);
