extends Node

var thrust_price = 500
var armor_price = 500

var money = 11000
var bought = [0]
var current = 0

var offhp = 50;
var offmaxhp = 50;
var offforce = -12000

var handhp = 50;
var handmaxhp = 50;
var handforce = -12000

var drilhp = 70;
var drilmaxhp = 70;
var drilforce = -18000

func restore():
	thrust_price = 500
	armor_price = 500
	money = 0
	bought = [0]
	current = 0
	offhp = 50;
	offmaxhp = 50;
	offforce = -12000
	handhp = 50;
	handmaxhp = 50;
	handforce = -12000
	drilhp = 50;
	drilmaxhp = 50;
	drilforce = -12000
