extends Area3D

func _ready():
	body_entered.connect(bodyEntered);
	
func bodyEntered(body : Node3D):
	var kart : Kart = body as Kart;
	if (!kart): return;
	
	kart.onCheckpointEnter(getCheckpointNumber());
	
func getCheckpointNumber():
	return get_index();
