import 
    boxy, opengl, staticglfw, 
    silicideData, silicideGraphics, silicideControls

proc display() =
    bxy.saveTransform()
    bxy.beginFrame(windowSize)
    bxy.scale(windowScale)

    glClearColor(0.125, 0.125, 0.125, 1)
    glClear(GL_COLOR_BUFFER_BIT)

    window.getCrsPos()

    for i in 1..30:
        drawLine(vec2(-10, i.float*50), vec2(i.float*50, -10), color(1, 0, 0, 0.5))
    
    drawImCAST("crc", vec2(crsXPos, crsYPos), scale=vec2(0.2, 0.2))

    bxy.restoreTransform()
    bxy.endFrame()

    glFlush()

#------------------------------------------------------------------------------

var frame = 0
var lastTime = getTime().float
var targetFPS = 60.0

while windowShouldClose(window) != 1:
    display()

    pollEvents()

    while getTime() < lastTime + 1.0/targetFPS:
        continue
    lastTime += 1.0/targetFPS
    
    frame += 1