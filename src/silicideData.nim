import staticglfw, boxy

var vidMode*: ptr VidMode
var window*: Window
var windowSize*: IVec2
var windowScale*: Vec2

var bxy*: Boxy

#------------------------------------------------------------------------------

var crsXPos* = 0.0
var crsYPos* = 0.0

var keyList*: array[KEY_LAST + 1, int]