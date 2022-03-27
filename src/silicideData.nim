import staticglfw, pixie, boxy

var windowSize*: Ivec2
var window*: Window

let bxy* = newBoxy()
bxy.addImage("sqr", readImage("square.png"))