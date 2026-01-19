class_name ItemBandage extends BaseItem

func _get_display_name() -> StringName :
	return "绷带"
	
func _get_id() -> StringName : 
	return "item:bandage"
	
func _get_type() -> ItemType :
	return ItemType.ARMOR
