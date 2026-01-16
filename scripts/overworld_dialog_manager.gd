extends CanvasLayer

@export var panel : Panel
@export var typer: TextTyper

var dialog_list : Array[String] = []
var started : bool = false # 对话是否启动

func _process(delta: float) -> void :
	if started : 
		if typer.is_typer_finished():
			if Input.is_action_just_pressed("confirm"):
				if dialog_list.is_empty() :
					dialog_end()
				else : 
					_goto_next()
			pass

func dialog_add(msg:String) -> void :
	dialog_list.append(msg)

func dialog_start() -> void :
	self.visible = true
	started = true
	_goto_next()

func dialog_end() -> void :
	self.visible = false
	await get_tree().create_timer(0.025).timeout
	started = false


func _goto_next() -> void :
	var _next_msg : String = dialog_list.pop_front() # 注意，使用pop_front可能导致性能问题，以后可以改进
	typer.restart(_next_msg)
