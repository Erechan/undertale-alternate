extends Node

var _db : Dictionary[StringName,BaseItem] = {}

func _init() -> void:
	register_item(ItemBandage)
	register_item(ItemStick)
	register_item(ItemPie)
	
## 注册物品(把物品脚本实例化，存储在 _db 字典中，以物品的唯一ID作为键)
func register_item(item : Script) -> Error :
	var obj : Object = item.new()
	if obj is BaseItem :
		_db[obj._get_id()] = obj
		return OK
	elif obj is not RefCounted:
		obj.free()
	return FAILED
	
## 通过ID获取物品的显示名称
func get_display_name(id : StringName) -> String:
	if _db.has(id) :
		return _db[id]._get_display_name()
	return ""

## 通过ID创建类实例
func new_instance(id: StringName) -> BaseItem :
	if _db.has(id) :
		return _db[id].get_script().new()
	return null
