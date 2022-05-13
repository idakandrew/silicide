import 
    boxy, opengl, staticglfw,
    silicideData, silicideGraphics, silicideControls, silicideUtil

when defined(windows):
    import winim/inc/mmsystem

var frame = 0.0
var lastTime = getTime().float
var nextTime = 0.0
var targetFPS = 120.0

#------------------------------------------------------------------------------

proc display() =
    bxy.saveTransform()
    bxy.beginFrame(windowSize)
    bxy.scale(windowScale)

    glClearColor(0.12, 0.12, 0.12, 1)
    glClear(GL_COLOR_BUFFER_BIT)

    window.getCrsPos()

    drawImCAST("sqr", vec2(580, 400), scale=imScale("sqr", vec2(70, 70)), tint=PTS_CLR)
    drawImCAST("sqr", vec2(680, 400), scale=imScale("sqr", vec2(70, 70)), tint=color(0, 0.7, 0, 0.4))

    drawImCAST("sqr", vec2(580, 500), scale=imScale("sqr", vec2(70, 70)), tint=NTS_CLR)
    drawImCAST("sqr", vec2(680, 500), scale=imScale("sqr", vec2(70, 70)), tint=color(0.2, 0.4, 1, 0.4))

    drawImCAST("sqr", vec2(crsXPos-100, crsYPos), scale=imScale("sqr", vec2(40, 40)), tint=MET_CLR)
    drawImCAST("sqr", vec2(crsXPos, crsYPos), scale=imScale("sqr", vec2(40, 40)), tint=color(0.5, 0.5, 0.5, 0.5))

    # drawImCAST("sqr", vec2(500, 500), scale=imScale("sqr", vec2(30, 30)), tint=VIA_CLR)

    if showDebug:
        debugMenu()

    bxy.restoreTransform()
    bxy.endFrame()

    window.swapBuffers()
    
#------------------------------------------------------------------------------

when defined(windows):
    timeBeginPeriod(1)

while windowShouldClose(window) != 1:
    pollEvents()

    display()

    nextTime = lastTime + 1.0/targetFPS

    if getTime().float < nextTime:
        hybridSleep(nextTime - lastTime)
    else:
        nextTime = getTime()

    lastTime = nextTime

    frame += 1

when defined(windows):
    timeEndPeriod(1)