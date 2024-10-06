extends Sprite3D

var mainCamera : Camera3D;

func _ready():
	mainCamera = get_viewport().get_camera_3d();

func _process(delta):
	var rotationTo : float = rad_to_deg(fmod(mainCamera.global_rotation.y, TAU) - fmod(global_rotation.y, TAU));
	var flipped : bool = false;
	if (rotationTo < 0.0):	
		flipped = true;

	var absRotation : float = abs(rotationTo);
	var frameTarget = getTurnFrame(absRotation);
	
	if (frameTarget == 0 || frameTarget == angleThresholds.size()):
		flipped = false;
	flip_h = flipped;
	
	frame = frameTarget;

const angleThresholds : Array[float] = [ 25, 50, 85, 150 ];
func getTurnFrame(rotation):
	for index : int in range(0, angleThresholds.size()):
		if (rotation < angleThresholds[index]):
			return index;
	return angleThresholds.size();
