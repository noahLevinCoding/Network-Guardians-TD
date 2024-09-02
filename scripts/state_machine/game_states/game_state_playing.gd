extends State
class_name GameStatePlaying

@export var playing_ui_node : Playing = null

func _ready():
	playing_ui_node.pause.connect(_on_pause)
	playing_ui_node.start_next_wave.connect(_on_start_next_wave)
	SignalManager.defeat.connect(_on_defeat)
	SignalManager.wiki_shop_button.connect(_on_wiki_shop_button)
	SignalManager.wiki_tower_button.connect(_on_wiki_tower_button)
	SignalManager.wiki_mechanics_button.connect(_on_wiki_mechanics_button)
	
func _on_wiki_mechanics_button():
	state_transition.emit(self, "Options")
	SignalManager.enter_wiki.emit()
	SignalManager.enter_wiki_mechanics.emit()
	
func _on_wiki_shop_button():
	state_transition.emit(self, "Options")
	SignalManager.enter_wiki.emit()
	
func _on_wiki_tower_button(wiki_tower_index : int):
	state_transition.emit(self, "Options")
	SignalManager.enter_wiki.emit()
	SignalManager.enter_wiki_tower.emit(wiki_tower_index)
	
func _on_reset():
	playing_ui_node.deselect()
	
		
func on_escape():
	SignalManager.on_button_click.emit()
	_on_pause()


func enter():
	print("Enter GameState Playing")
	playing_ui_node.visible = true
	GameManager.is_paused = false
	
	
func exit():
	print("Exit GameState Playing")
	playing_ui_node.visible = false
	GameManager.is_paused = true
	
func _on_pause():
	SignalManager.pause_game.emit()
	state_transition.emit(self, "Pause")
	
func _on_start_next_wave():
	SignalManager.start_next_wave.emit()
	
func _on_defeat():
	state_transition.emit(self, "Defeat")


