extends Node


enum Platform {walk, jump, ladder}
const _enum_platform_to_foldername := ["walk", "jump", "ladder"]

@export var platform_type: Platform
