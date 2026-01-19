class_name ItemPie extends BaseItem

func _get_display_name() -> StringName :
	return "奶油糖肉桂派"
	
func _get_id() -> StringName : 
	return "item:pie"
	
func _get_type() -> ItemType :
	return ItemType.NORMAL
