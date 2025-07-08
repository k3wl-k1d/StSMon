class_name RunStartup
extends Resource

enum Type {NEW_RUN, CONTINUED_RUN}

@export var type: Type
@export var pickedCharacterP1: CharacterStats
@export var pickedCharacterP2: CharacterStats
