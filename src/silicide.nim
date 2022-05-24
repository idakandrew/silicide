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

    glClearColor(0.12, 0.12, 0.12, 1)
    glClear(GL_COLOR_BUFFER_BIT)

    window.getCrsPos()

    drawImCst("sqr", vec2(580, 400), scalePx=vec2(70, 70), tint=PTS_HI)
    drawImCst("sqr", vec2(680, 400), scalePx=vec2(70, 70), tint=PTS_LO)

    drawImCst("sqr", vec2(580, 500), scalePx=vec2(70, 70), tint=NTS_HI)
    drawImCst("sqr", vec2(680, 500), scalePx=vec2(70, 70), tint=NTS_LO)

    drawImCst("sqr", vec2(900, 400), scalePx=vec2(200, 70), tint=PTS_HI)

    drawImCst("sqr", vec2(900, 330), scalePx=vec2(70, 70), tint=NTS_LO)
    drawImCst("sqr", vec2(900, 365), scalePx=vec2(70, 80), angle=45, opOrder=RotFirst, tint=NTS_LO)
    drawImCst("sqr", vec2(900, 400), scalePx=vec2(35, 70), tint=NTS_LO)

    drawImCst("sqr", vec2(crsXPos-100, crsYPos), scalePx=vec2(40, 40), tint=MET_HI)
    drawImCst("sqr", vec2(crsXPos, crsYPos), scalePx=vec2(40, 40), tint=MET_LO)

    drawImCst("crcBrd", vec2(680, 400), scalePx=vec2(30, 30), tint=VIA_HI)
    drawImCst("crcBrd", vec2(680, 500), scalePx=vec2(30, 30), tint=VIA_LO)

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