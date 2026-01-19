extends Node
 ## 存储角色信息
var player_name : String = "FIRSK"
var player_hp : float = 20.0
var player_maxhp : float = 20.0
var player_exp : float = 0.0
var player_lv : float = 0.0
var player_gold : float = 0.0

var player_max_inventory_capacity : int = 8
var player_box_max_inventory_capacity : int = 10

const SAVE_PATH : String = "user://save.ini" ## 游戏存档路径

var player_armor : BaseItem = null
var player_weapon :BaseItem = null
var player_inventory : Array[BaseItem] = [] ##角色背包物品
var player_box_inventory : Array[BaseItem] = []  ##角色箱子物品

func _init() -> void:
	player_inventory.resize(player_max_inventory_capacity)
	player_box_inventory.resize(player_box_max_inventory_capacity)

#region 存档和读档
## 存档
func save_file() -> void :
	var config : ConfigFile = ConfigFile.new()
	config.set_value("info", "name", player_name)
	config.set_value("info", "hp", player_hp)
	config.set_value("info", "maxhp", player_maxhp)
	config.set_value("info", "exp", player_exp)
	config.set_value("info", "lv", player_lv)
	config.set_value("info", "gold", player_gold)
	if is_instance_valid(player_armor) :
		config.set_value("info", "armor", player_armor._get_id())
	if is_instance_valid(player_weapon) :
		config.set_value("info", "weapon", player_weapon._get_id())
	
	for i : int in player_inventory.size() :
		if is_instance_valid(player_inventory[i]):
			config.set_value("inventory", str(i), player_inventory[i]._get_id())
	for ii : int in player_box_inventory.size() :
		if is_instance_valid(player_box_inventory[ii]):
			config.set_value("box_inventory", str(ii), player_box_inventory[ii]._get_id())
	
	config.save(SAVE_PATH) ## 按存储路径存储以上所有信息

## 读档
func load_file() :
	var config : ConfigFile = ConfigFile.new()
	config.load(SAVE_PATH)
	
	player_name = config.get_value("info", "name", player_name)
	player_hp = config.get_value("info", "hp", player_hp)
	player_maxhp = config.get_value("info", "maxhp", player_maxhp)
	player_exp = config.get_value("info", "exp", player_exp)
	player_lv = config.get_value("info", "lv", player_lv)
	player_gold = config.get_value("info", "gold", player_gold)
	var armor_id = config.get_value("info", "armor","") ##若读取的存档玩家没有武器，返回默认为""（为null会报错）
	var weapon_id = config.get_value("info", "weapon", "") ##没有护甲则同上
	player_armor = ItemDB.new_instance(armor_id)
	player_weapon = ItemDB.new_instance(weapon_id)
	
	for i : int in player_inventory.size() :
		var inventory_id : String = config.get_value("inventory", str(i), "")
		set_inventory(i , ItemDB.new_instance(inventory_id))
	for ii : int in player_box_inventory.size() :
		var box_id : String = config.get_value("box_inventory", str(ii), "")
		set_box_inventory(ii , ItemDB.new_instance(box_id))
		

#endregion

func _ready() -> void:
	load_file()
	pass

func set_armor(item:BaseItem) -> void:
	if item._get_type() == BaseItem.ItemType.ARMOR :
		player_armor = item
		
func set_weapon(item:BaseItem) -> void:
	if item._get_type() == BaseItem.ItemType.WEAPON :
		player_weapon = item
		
#region 背包和箱子的操作

## 设置背包中某个位置上的物品
func set_inventory(ind : int, item : BaseItem) -> void :
	if(ind >= 0 && ind < player_inventory.size()) :
		player_inventory[ind] = item

## 向背包添加一个物品
func add_inventory(item : BaseItem) -> Error :
	for slot : int in player_inventory.size():
		var existing_item : BaseItem = player_inventory[slot]
		if !is_instance_valid(existing_item) :
			player_inventory[slot] = item
			return OK
	return FAILED
	
## 设置箱子中某个位置上的物品
func set_box_inventory(ind : int, item : BaseItem) -> void :
	if(ind >= 0 && ind < player_box_inventory.size()) :
		player_box_inventory[ind] = item

## 向箱子添加一个物品
func add_box_inventory(item : BaseItem) -> Error :
	for slot : int in player_box_inventory.size():
		var existing_item : BaseItem = player_box_inventory[slot]
		if !is_instance_valid(existing_item) :
			player_box_inventory[slot] = item
			return OK
	return FAILED

## 从背包某位置移除一个物品
func remove_item_from_inventory(ind:int) -> void :
	if(ind >= 0 && ind < player_inventory.size()) :
		player_inventory.remove_at(ind)
		player_inventory.resize(player_max_inventory_capacity)
		
## 从箱子某位置移除一个物品
func remove_item_from_box(ind:int) -> void :
	if(ind >= 0 && ind < player_box_inventory.size()) :
		player_box_inventory.remove_at(ind)
		player_box_inventory.resize(player_box_max_inventory_capacity)

## 把物品从背包放入箱子
func move_item_from_inventory_to_box(ind : int) -> void :
	if(ind >= 0 && ind < player_inventory.size()) :
		var item : BaseItem = player_inventory[ind]
		if is_instance_valid(item) :
			if add_box_inventory(item) == OK: ## 1. 先尝试添加到箱子，确认成功后再移除
				remove_item_from_inventory(ind) ## 2. 只有添加成功，才从背包移除
			else:      
				print("箱子已满，无法放入物品！") ### 3. 箱子已满，给出提示或不做任何操作

## 把物品从箱子放入背包
func move_item_from_box_to_inventory(ind : int) -> void :
	if(ind >= 0 && ind < player_box_inventory.size()) :
		var item : BaseItem = player_box_inventory[ind]
		if is_instance_valid(item) :
			if add_inventory(item) == OK: ## 1. 先尝试添加到背包，确认成功后再移除
				remove_item_from_box(ind) ## 2. 只有添加成功，才从箱子移除
			else:      
				print("背包已满，无法放入物品！") ### 3. 箱子已满，给出提示或不做任何操作
			
		

#endregion



	
