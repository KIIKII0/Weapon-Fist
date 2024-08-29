extends Node


var gravity = 10

#player variables
var normal_speed: float = 5.0
var jump_velocity:float = 5.0

#knockback fist variables
var knockback_fist_force: float = 25
var knockback_fist_power: float = 5
@onready var knocbackfisthandright = preload("res://Fists/knocback_fist/knocback_fist_right/knockbackfisthandright.tscn")
@onready var knocbackfisthandleft = preload("res://Fists/knocback_fist/knockback_fist_left/knockbackfisthabdleft.tscn")



#basic fist variables
var basic_fist_power: float = 15
@onready var basicfisthandright = preload("res://Fists/Basic_fist/basic_fist_right/basicfisthandright.tscn")
@onready var basicfisthandleft = preload("res://Fists/Basic_fist/baasic_fist_left/basicfisthandleft.tscn")

