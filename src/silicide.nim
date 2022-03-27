import 
    boxy, opengl, staticglfw, pixie, 
    silicideData, silicideGraphics, silicideControls

#------------------------------------------------------------------------------

var xpos = 0.0
var ypos = 0.0
let windowScale = vec2(windowSize.x / 1920, windowSize.y / 1080)

proc display() =
    bxy.saveTransform()
    bxy.beginFrame(windowSize)
    bxy.scale(windowScale)

    glClearColor(0.125, 0.125, 0.125, 1)
    glClear(GL_COLOR_BUFFER_BIT)

    window.getCursorPos(addr xpos, addr ypos)

    bxy.drawText("Hello, world!", xpos, ypos)

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