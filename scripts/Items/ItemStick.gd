class_name ItemStick extends BaseItem

func _get_display_name() -> StringName :
	return "木棍"
	
func _get_id() -> StringName : 
	return "item:stick"
	
func _get_type() -> ItemType :
	return ItemType.WEAPON
