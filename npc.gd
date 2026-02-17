extends CharacterBody2D

## The dialogue resource file for this NPC (e.g., res://razon.dialogue)
@export var dialogue_resource: Resource
## The title/label to start dialogue from
@export var dialogue_start: String = "start"

var player_in_range: bool = false
var is_talking: bool = false

func _ready():
	# Connect dialogue ended signal so we know when conversation finishes
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and not is_talking and event.is_action_pressed("interact"):
		is_talking = true
		# Freeze the player during dialogue
		var player = _get_player()
		if player:
			player.set_physics_process(false)
		# Show the dialogue balloon
		DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false

func _on_dialogue_ended(_resource) -> void:
	is_talking = false
	# Unfreeze the player
	var player = _get_player()
	if player:
		player.set_physics_process(true)

func _get_player() -> CharacterBody2D:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		return players[0]
	return null
