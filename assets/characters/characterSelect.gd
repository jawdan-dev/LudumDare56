extends Control

func _ready():
	CharacterChoice.resetSprites();
	for i : int in range(0, $ItemList.item_count):
		$ItemList.set_item_disabled(i, !CharacterChoice.unlockedCharacters.has(i));

func onSelect(index : int):
	CharacterChoice.playerChoice = index;
	$Button.disabled = false;
	#sounds 
	match index:
		0: $Announcer1.play()
		1: $Announcer2.play()
		2: $Announcer3.play()
		3: $Announcer4.play()
		4: $Announcer5.play()
		5: $Announcer6.play()
		6: $Announcer7.play()
		7: $Announcer8.play()
		8: $Announcer9.play()
	
	
func onStart():
	get_tree().change_scene_to_file("res://scenes/grayBox.tscn");
