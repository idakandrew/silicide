import staticglfw, boxy

# main
#------------------------------------------------------------------------------


# graphics
#------------------------------------------------------------------------------

var vidMode*: ptr VidMode
var window*: Window
var windowSize*: IVec2
var windowScale*: Vec2

var bxy*: Boxy

let PTS_CLR* = color(0, 0.8, 0)
let NTS_CLR* = color(0.2, 0.4, 1)
let MET_CLR* = color(1, 1, 1, 0.5)
let VIA_CLR* = color(0.35, 0.35, 0.35, 0.5)

# controls
#------------------------------------------------------------------------------

var crsXPos* = 0.0
var crsYPos* = 0.0

var keyList*: array[KEY_LAST + 1, int]

var lastClicked* = 0

var showDebug* = false

# util
#------------------------------------------------------------------------------

var estimate* = 1e-3
var observed* = 0.0