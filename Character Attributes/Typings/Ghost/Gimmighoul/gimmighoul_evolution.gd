extends EvolutionRequirements

const GOLD_REQUIREMENT := 1000

func check_evolution() -> bool:
	if canEvolve:
		if runStats.gold >= GOLD_REQUIREMENT:
			return true
	return false
