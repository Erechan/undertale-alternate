extends Control

#将切换场景的函数封装，便于修改
func goto_scene_to_path(path: String) -> Error:
	return get_tree().change_scene_to_file(path)

#新增通过PackedScene跳转场景的方法
func goto_scene_to_packed(packed: PackedScene) -> Error:
	return get_tree().change_scene_to_packed(packed)
