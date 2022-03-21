import 
    boxy, opengl, staticglfw, pixie, 
    silicideData, silicideGraphics, silicideControls

#------------------------------------------------------------------------------

var xpos = 0.0
var ypos = 0.0

proc display() =
    bxy.saveTransform()
    bxy.beginFrame(windowSize)

    glClearColor(0.125, 0.125, 0.125, 1)
    glClear(GL_COLOR_BUFFER_BIT)

    window.getCursorPos(addr xpos, addr ypos)

    # for x in -4..4:
    #     for y in -4..4:
    #         bxy.drawText("test", xpos+x.float*200, ypos+y.float*100)

    bxy.drawText("Hello, my name is Test", xpos, ypos)

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