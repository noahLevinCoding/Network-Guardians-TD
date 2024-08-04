class_name StateMachine
extends Node

var states :Dictionary = {}
var current_state: State = null
@export var initial_state : State 

func _ready():
	#Append states
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
	
	#Initialize state
	if initial_state:
		initial_state.enter()
		current_state = initial_state
	

func change_state(source_state : State, new_state_name : StringName):
	
	if source_state != current_state:
		print("Invalid change_state trying from: " + source_state.name + " but currently in: " + current_state.name)
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		print("New state is empty")
		return
	
	if current_state:
		current_state.exit()
		
	current_state = new_state
	
	new_state.enter()
	

func force_change_state(new_state_name : StringName):
	var new_state = states.get(new_state_name.to_lower())
	
	if !new_state:
		print(new_state + " does not exist in the dictionary of states")
		return
		
	if current_state == new_state:
		print("State is same, aborting")
		return
		
	if current_state:
		var exitCallable = Callable(current_state, "Exit")
		exitCallable.call_deferred()
		
	new_state.enter()
	
	current_state = new_state
	

func _process(delta):
	if current_state:
		current_state.update(delta)
		
func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)
		

