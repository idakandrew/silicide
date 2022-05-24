import staticglfw, boxy

# main
#------------------------------------------------------------------------------

var frameTime* = 0.0
var skippedSyncs* = 0

# graphics
#------------------------------------------------------------------------------

var vidMode*: ptr VidMode
var window*: Window
var windowSize*: IVec2
var windowScale*: Vec2

var bxy*: Boxy

let PTS_HI* = color(0, 0.75, 0)
let PTS_LO* = color(0.075, 0.349, 0.075)
let NTS_HI* = color(0.2, 0.4, 1)
let NTS_LO* = color(0.153, 0.231, 0.471)
let MET_HI* = color(1, 1, 1, 0.5)
let MET_LO* = color(0.5, 0.5, 0.5, 0.5)
let VIA_HI* = color(0.35, 0.35, 0.35, 0.5)
let VIA_LO* = color(0.9, 0.9, 0.9, 0.5)

type RotateScaleOrder* = enum
    RotFirst, SclFirst

# controls
#------------------------------------------------------------------------------

var crsXPos* = 0.0
var crsYPos* = 0.0

var keyList*: array[KEY_LAST + 1, int]
var mouseBtns*: array[MOUSE_BUTTON_LAST + 1, int]

var lastClicked* = 0

var showDebug* = false

# util
#------------------------------------------------------------------------------

var estimate* = 1e-3
var observed* = 0.0