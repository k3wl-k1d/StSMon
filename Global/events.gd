extends Node

# Card related events
signal card_drag_started(cardUI: CardUI)
signal card_drag_ended(cardUI: CardUI)
signal card_aim_started(cardUI: CardUI)
signal card_aim_ended(cardUI: CardUI)
signal card_played(card: Card)
signal card_tooltip_requested(card: Card)
signal card_tooltip_hide

# Player related events
signal player_card_drawn(card: Card)
signal player_hand_drawn
signal player_hand_discarded
signal player_turn_started
signal player_turn_ended
signal player_died(player: Player)
signal player_revived(player: Player)
signal both_players_died
signal player_hit_without_block

# Enemy related events
signal enemy_hit_without_block(enemy: Enemy, damage: int)
signal enemy_action_completed(enemy: Enemy)
signal enemy_fainted(enemy: Enemy)
signal all_enemies_fainted

# Battle related events
signal battle_won
signal battle_started
signal entity_fainted_early
signal damage_dealt_to(targets: Array[Entity])
signal status_tooltip_requested(statuses: Array[Status])
signal battle_over_screen_requested(text: String, type: BattleOverPanel.Type)
signal turn_order_changed(currentEntity: Entity, entities: Array[Entity])
signal character_icon_updated(char: CharacterStats)
signal crit_ready
signal increase_crit(amount: int)
signal reset_crit

# Status related events
signal spotlight_active(targets: Entity)
signal spotlight_deactive(targets: Entity)
signal skip_current_turn(target: Entity)
signal detonate_poison(target: Entity)

# Map related events
signal map_exited(room: Room)

# Shop related events
signal shop_entered(shop: Shop)
signal shop_exited
signal shop_relic_bought(relic: Relic, price: int)
signal shop_card_bought(card: Card, price: int)

# Pokecenter related events
signal pokecenter_exited

# Battle reward related events
signal battle_reward_exited

# Treasure room related events
signal treasure_room_exited(foundRelic: Relic)

# Event room related events
signal event_room_exited

# Relic related events
signal relic_tooltip_requested(relic: Relic)
signal spell_tag_activated
signal spell_tag_deactivated

# Meta related events
