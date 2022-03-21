import 
    pixie, boxy, sequtils, opengl, staticglfw,
    silicideData

if init() == 0:
    quit("Failed to Initialize GLFW.")

windowHint(SAMPLES, 8)
windowSize = ivec2(1000, 1000)
window = createWindow(windowSize.x, windowSize.y, "Silicide", nil, nil)

makeContextCurrent(window)
loadExtensions()
glDrawBuffer(GL_FRONT)

let bxy* = newBoxy()
bxy.addImage("sqr", readImage("square.png"))

#------------------------------------------------------------------------------

## Draws image at center, rotated by angle, scaled by scale, tinted by tint.
proc drawImCAST*(
    boxy: Boxy,
    key: string,
    center: Vec2,
    angle = 0.0,
    scale = vec2(1, 1),
    tint = color(1, 1, 1, 1)
) =
    let imageInfo = boxy.getImageSize(key)

    boxy.saveTransform()
    boxy.translate(center)
    boxy.rotate(angle)
    boxy.scale(scale)
    boxy.translate(-imageInfo.vec2 / 2)
    boxy.drawImage(key, pos = vec2(0, 0), tintColor = tint)
    boxy.restoreTransform()

#------------------------------------------------------------------------------

var font = readFont("mont.otf")
font.size = 100
font.paint.color = color(0.5, 0.5, 0.5)

proc loadFont*(bxy: Boxy) =
    let text = toSeq ' '..'~'

    for c in text:
        let temp = font.typeset($c)
        let image = newImage(temp.computeBounds.x.int, temp.computeBounds.y.int)
        image.fillText(temp)

        bxy.addImage($c, image)

bxy.loadFont()

proc drawText*(bxy: Boxy, str: string, xpos, ypos: float, scale = vec2(1, 1)) =
    let chars = toSeq str
    let temp = font.typeset(str)
    let width = temp.computeBounds.x.int
    let height = temp.computeBounds.y.int
    let scaleAdj = vec2(scale.x * windowSize.x.float / 1920, scale.y * windowSize.y.float / 1080)
    let xposAdj = xpos - width.float * scaleAdj.x / 2

    for idx, c in chars:
        bxy.drawImCAST(
            $c, 
            vec2(
                xposAdj + temp.positions[idx].x * scaleAdj.x + bxy.getImageSize($c).x.float * scaleAdj.x / 2, 
                ypos - height.float * scaleAdj.y / 2 + bxy.getImageSize($c).y.float * scaleAdj.y / 2
            ),
            scale=scale
        )
