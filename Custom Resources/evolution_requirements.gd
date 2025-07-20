class_name EvolutionRequirements
extends Resource

@export var runStats: RunStats
@export var evolutionPrimary: CharacterStats
@export var evolutionSecondary: CharacterStats = null
@export var canEvolve := false

var currentEvolution := evolutionPrimary

func check_evolution() -> bool:
	if canEvolve:
		return false
	return false
