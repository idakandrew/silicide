import 
    boxy, opengl, staticglfw,
    silicideData, silicideGraphics, silicideControls, silicideUtil

when defined(windows):
    import winim/inc/mmsystem

var frame = 0.0
var targetFPS = 120.0

#------------------------------------------------------------------------------

proc display() =
    bxy.saveTransform()
    bxy.beginFrame(windowSize)
    bxy.scale(windowScale)
    # bxy.translate(vec2(xCoord.float, yCoord.float))

    glClearColor(0.12, 0.12, 0.12, 1)
    glClear(GL_COLOR_BUFFER_BIT)

    # drawImCstm("sqr", vec2(40, 40), scalePx=vec2(60, 60), tint=PTS_HI)
    # drawImCstm("sqr", vec2(680, 400), scalePx=vec2(60, 60), tint=PTS_LO)

    # drawImCstm("sqr", vec2(120, 40), scalePx=vec2(60, 60), tint=NTS_HI)
    # drawImCstm("sqr", vec2(680, 500), scalePx=vec2(60, 60), tint=NTS_LO)

    # drawImCstm("sqr", vec2(900, 400), scalePx=vec2(200, 60), tint=PTS_HI)

    # drawImCstm("sqr", vec2(900, 330), scalePx=vec2(60, 60), tint=NTS_LO)
    # drawImCstm("sqr", vec2(900, 360), scalePx=vec2(60, 70), angle=45, rotFirst=true, tint=NTS_LO)
    # drawImCstm("sqr", vec2(900, 400), scalePx=vec2(34, 60), tint=NTS_LO)

    # drawImCstm("sqr", vec2(crsScrnX-100, crsScrnY), scalePx=vec2(38, 38), tint=MET_HI)
    # drawImCstm("sqr", vec2(crsScrnX, crsScrnY), scalePx=vec2(38, 38), tint=MET_LO)

    # drawImCstm("crcBrdr", vec2(680, 400), scalePx=vec2(26, 26), tint=VIA_HI)
    # drawImCstm("crcBrdr", vec2(680, 500), scalePx=vec2(26, 26), tint=VIA_LO)

    drawMap()

    if showDebug:
        debugMenu()

    bxy.restoreTransform()
    bxy.endFrame()

    window.swapBuffers()
    
#------------------------------------------------------------------------------

when defined(windows):
    timeBeginPeriod(1)

while windowShouldClose(window) != 1:
    var frameStart = getTime().float
    var expectFrameEnd = frameStart + 1.0/targetFPS

    pollEvents()

    window.keyRepeatHandler()

    getCrsPos()
    (crsScrnSnapX, crsScrnSnapY) = snapPosCntr(crsScrnX, crsScrnY)
    getCrsMapPos()

    display()

    var now = getTime().float

    if now < expectFrameEnd:
        hybridSleep(expectFrameEnd - now)
    else:
        inc skippedSyncs

    frame += 1
    frameTime = getTime().float - frameStart

when defined(windows):
    timeEndPeriod(1)