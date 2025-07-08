class_name CouponsRelic
extends Relic

@export_range(1,100) var discount := 30

var relicUI: RelicUI

func initialize_relic(owner: RelicUI) -> void:
	Events.shop_entered.connect(add_shop_modifier)
	relicUI = owner

func deactivate_relic(_owner: RelicUI) -> void:
	Events.shop_entered.disconnect(add_shop_modifier)

func add_shop_modifier(shop: Shop) -> void:
	relicUI.flash()
	
	var shopCostModifier := shop.modifierHandler.get_modifier(Modifier.Type.SHOP_COST)
	assert(shopCostModifier, "No shop modifier in Shop!")
	
	var couponsModifierValue := shopCostModifier.get_value("coupons")
	
	if not couponsModifierValue:
		couponsModifierValue = ModifierValue.create_new_modifier("coupons", ModifierValue.Type.PERCENT)
		couponsModifierValue.percentValue = -1 * discount/100.0
		shopCostModifier.add_new_value(couponsModifierValue)
