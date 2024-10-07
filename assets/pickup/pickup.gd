extends Area3D


var cooldown : float = 0.0;
func _process(delta):
	cooldown -= delta;
	if (cooldown <= 0):
		visible = true;	

func onBodyEntered(body):
	if (!visible): return;
	
	var kart : Kart = body as Kart;
	if (!kart): return;
	
	if (!kart.pickupItem()): return;
	
	visible = false;
	cooldown = 10.0;
