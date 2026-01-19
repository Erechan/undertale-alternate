## 物品道具的基类
@abstract
class_name BaseItem  
extends RefCounted

enum ItemType{
	NORMAL,
	ARMOR,
	WEAPON
}

## 返回物品的显示名称
@abstract 
func _get_display_name() -> StringName

## 返回物品的内部存贮ID
@abstract 
func _get_id() -> StringName

## 使用物品时触发的回调方法
###注意！还未设置该项！（该项改为抽象函数后，记得给所有的Item脚本都要加上这项）
func _used() :
	pass
	
## 获取类型
@abstract
func _get_type() -> ItemType
	 
	
