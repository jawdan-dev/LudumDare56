extends Kart

func getAccelerationInput(): return Input.get_axis("player_backward", "player_forward");
func getTurningInput(): return Input.get_axis("player_right", "player_left");
func getUseItemInput(): return Input.is_action_just_pressed("player_item");

func _process(_delta):
	var turningInput : float = getTurningInput();
	if (turningInput != 0):
		$Sprite.frame = 1;
		$Sprite.flip_h = turningInput >= 0;
	else:
		$Sprite.frame = 0;
		$Sprite.flip_h = false;
