extends Node
class_name FiniteStateMachine

var states : Dictionary = {}
var currentState : State
@export var initialState : State

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.stateTransition.connect(changeState)
			
	if initialState:
		initialState.enter()
		currentState = initialState
			
func changeState(sourceState : State, newStateName : StringName):
	if sourceState != currentState:
		print("Invalid change_state trying from: " + sourceState.name + " but currently in: " + currentState.name)
		return
	
	var newState = states.get(newStateName.to_lower())
	if !newState:
		print("New state is empty")
		return
	
	if currentState:
		currentState.exit()
		
	newState.enter()
	
	currentState = newState

func forceChangeState(newStateName : StringName):
	var newState = states.get(newStateName.to_lower())
	
	if !newState:
		print(newState + " does not exist in the dictionary of states")
		return
		
	if currentState == newState:
		print("State is same, aborting")
		return
		
	if currentState:
		var exitCallable = Callable(currentState, "Exit")
		exitCallable.call_deferred()
		
	newState.enter()
	
	currentState = newState
	

func _process(delta):
	if currentState:
		currentState.update(delta)
		
func _physics_process(delta):
	if currentState:
		currentState.physics_update(delta)
		
