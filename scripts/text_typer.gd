class_name TextTyper
extends RichTextLabel

signal typer_finished() # 打字完成后发出的信号

## 打字机的文本
@export_multiline var typer_text : String = ""
## 基础打字速度（普通字符的间隔）
@export var base_speed : float = 0.075
## 不同标点的停顿倍数（基于base_speed）
@export var comma_pause : float = 2.0    # 逗号停顿倍数
@export var period_pause : float = 3.0   # 句号/问号/感叹号停顿倍数
@export var space_pause : float = 1.2   # 空格轻微停顿
@export var auto_destroy : bool = false # 打字机完成打字是否销毁（注意！一般都设为false不要销毁）
@export var type_sound : AudioStream # 打字音效

## 打字机进度
var progress_index : int = 0
## 打字计时器
var _timer : float = 0.0

func _process(delta: float) -> void:
	if is_typer_finished(): # 判断打字是否完成
		if Input.is_action_just_pressed("confirm") : # 打字完成后按确认键，关闭对话
			typer_finished.emit()
			if auto_destroy :
				self.queue_free()
	else :
		if Input.is_action_just_pressed("cancel") : # 打字未完成按取消键，玩家跳过对话
			# 跳过打字时直接输出全部内容，不等待停顿
			while progress_index < typer_text.length() :
				print_char(true)
			return
		
		if _timer <= 0.0 :
			# 获取当前字符对应的停顿时长
			var current_char = typer_text[progress_index]
			_timer = get_pause_duration(current_char)
			print_char()
			if type_sound :
				GlobalSoundPlayer.play_sound(type_sound)
		else :
			_timer -= delta

# 获取对应字符的停顿时长
func get_pause_duration(char_: String) -> float:
	# 定义需要特殊停顿的字符
	var comma_chars = [",", "，"]          # 中文/英文逗号
	var period_chars = [".", "。", "?", "？", "!", "！", ";", "；"] # 句末标点
	var space_chars = [" ", "\t"]         # 空格/制表符
	
	if char_ in comma_chars:
		return base_speed * comma_pause
	elif char_ in period_chars:
		return base_speed * period_pause
	elif char_ in space_chars:
		return base_speed * space_pause
	else:
		return base_speed # 普通字符用基础速度

func print_char(skip_mode: bool = false) -> void :
	if progress_index >= typer_text.length():
		return
	
	var char_ : String = typer_text[progress_index] # 当前打印的字符
	var bbcode_buffer : String = ''
	
	# 检测是否有bbcode标签（标签不触发停顿）
	if char_ == '[' :
		bbcode_buffer = char_
		progress_index += 1
		# 循环读取直到标签结束
		while progress_index < typer_text.length() and typer_text[progress_index] != "]":
			bbcode_buffer += typer_text[progress_index]
			progress_index += 1
		# 加上结束符
		if progress_index < typer_text.length() and typer_text[progress_index] == "]":
			bbcode_buffer += "]"
			progress_index += 1
		# 将完整的BBCODE标签添加到展示文本中
		self.text += bbcode_buffer
	else: # 普通字符处理
		self.text += char_
		progress_index += 1
	# 跳过模式下重置计时器，避免停顿
	if skip_mode:
		_timer = 0.0
		
		
func restart(txt : String) :
	self.text = ""
	typer_text = txt
	progress_index = 0
	_timer = 0.0
	
# 检查打字机是否完成全部打字内容
func is_typer_finished() -> bool :
	return progress_index >= typer_text.length()
	
	
