extends Node

func print_hello(task: Task):
	print("Hello")
	task.success()

func print_world(task: Task):
	print("World")
	task.success()

func print_break(task: Task):
	print("=====")
	task.success()
