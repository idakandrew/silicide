import 
    pixie, boxy, sequtils, opengl, staticglfw,
    silicideData

if init() == 0:
    quit("Failed to Initialize GLFW.")

vidMode = getVideoMode(getPrimaryMonitor())
windowHint(SAMPLES, 8)
window = createWindow(vidMode.width, vidMode.height, "silicide", getPrimaryMonitor(), nil)
windowSize = ivec2(vidMode.width, vidMode.height)
windowScale = vec2(vidMode.width / 1920, vidMode.height / 1080)

makeContextCurrent(window)
loadExtensions()
glDrawBuffer(GL_FRONT)

bxy = newBoxy()
bxy.addImage("sqr", readImage("square.png"))

proc genCircle(): Image =
    result = newImage(500, 500)
    let ctx = newContext(result)
    ctx.fillStyle = rgba(255, 0, 0, 125)
    ctx.fillCircle(circle(vec2(250, 250), 200))

bxy.addImage("crc", genCircle())

#------------------------------------------------------------------------------

## Draws image at center, rotated by angle, scaled by scale, tinted by tint.
proc drawImCAST*(
    key: string,
    center: Vec2,
    angle = 0.0,
    scale = vec2(1, 1),
    tint = color(1, 1, 1, 1)
) =
    let imageInfo = bxy.getImageSize(key)

    bxy.saveTransform()
    bxy.translate(center)
    bxy.rotate(angle)
    bxy.scale(scale)
    bxy.translate(-imageInfo.vec2 / 2)
    bxy.drawImage(key, pos = vec2(0, 0), tintColor = tint)
    bxy.restoreTransform()

proc drawLine*(
    strtPnt: Vec2,
    endPnt: Vec2,
    tint = color(1, 1, 1, 1)
) = 
    let key = "sqr"
    let imageInfo = bxy.getImageSize(key)

    bxy.saveTransform()
    bxy.translate(strtPnt + (endPnt - strtPnt) / 2)
    bxy.rotate(arctan2(endPnt.x - strtPnt.x, endPnt.y - strtPnt.y) - PI / 2)

    let dist = sqrt((endPnt.x - strtPnt.x)^2 + (endPnt.y - strtPnt.y)^2) / imageInfo.x.float

    bxy.scale(vec2(dist, 1))
    bxy.translate(-imageInfo.vec2 / 2)
    bxy.drawImage(key, pos = vec2(0, 0), tintColor = tint)
    bxy.restoreTransform()

#------------------------------------------------------------------------------

var font = readFont("mont.otf")
font.size = 100
font.paint.color = color(0.5, 0.5, 0.5)

proc loadFont() =
    let glyphs = toSeq ' '..'~'

    for c in glyphs:
        let cArng = font.typeset($c)
        let image = newImage(cArng.layoutBounds.x.int, cArng.layoutBounds.y.int)
        image.fillText(cArng)

        bxy.addImage($c, image)

loadFont()

proc drawText*(str: string, xpos, ypos: float, scale = vec2(1, 1)) =
    let chars = toSeq str
    let strArng = font.typeset(str)
    let width = strArng.layoutBounds.x
    let height = strArng.layoutBounds.y
    let xposAdj = xpos - width / 2

    for idx, c in chars:
        drawImCAST(
            $c, 
            vec2(
                xposAdj + strArng.positions[idx].x + bxy.getImageSize($c).x.float / 2, 
                ypos - height / 2 + bxy.getImageSize($c).y.float / 2
            ),
            scale=scale
        )

#------------------------------------------------------------------------------