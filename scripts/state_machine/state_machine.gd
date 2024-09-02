class_name StateMachine
extends Node

var states :Dictionary = {}
var current_state: State = null
var current_state_name : StringName = ""
var last_state_name : StringName = ""
@export var initial_state : State 

func _ready():
	#Append states
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
			child.back_transition.connect(change_state_back)
	
	#Initialize state
	if initial_state:
		initial_state.enter()
		current_state = initial_state
		current_state_name = current_state.get_name()
		
	

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
	
	last_state_name = current_state_name
	current_state_name = new_state_name	
	current_state = new_state
	
	new_state.enter()
	
func change_state_back(source_state : State):
	if source_state != current_state:
		print("Invalid change_state trying from: " + source_state.name + " but currently in: " + current_state.name)
		return
	
	if current_state:
		current_state.exit()
	
	var new_state = states.get(last_state_name.to_lower())
	if !new_state:
		print("New state is empty")
		return
	
	current_state_name = last_state_name	
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
		

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		current_state.on_escape()
