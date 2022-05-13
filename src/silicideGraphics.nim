import 
    pixie, boxy, opengl, staticglfw,
    silicideData

if init() == 0:
    quit("Failed to Initialize GLFW.")

vidMode = getVideoMode(getPrimaryMonitor())
windowHint(SAMPLES, 8)
window = createWindow(vidMode.width, vidMode.height, "silicide", getPrimaryMonitor(), nil)
windowSize = ivec2(vidMode.width, vidMode.height)
windowScale = vec2(vidMode.width / 1920, vidMode.height / 1080)

makeContextCurrent(window)
swapInterval(0) # must be after makeContextCurrent()
loadExtensions()

bxy = newBoxy()
bxy.addImage("sqr", readImage("square.png"))
bxy.addImage("sqr2", readImage("square2.png"))

#------------------------------------------------------------------------------

proc genCircle(): Image =
    ## Generates a white circle for insertion into boxy
    ## 
    result = newImage(500, 500)
    let ctx = newContext(result)
    ctx.fillStyle = rgba(0, 0, 0, 255)
    ctx.fillCircle(circle(vec2(250, 250), 230))
    ctx.fillStyle = rgba(255, 255, 255, 255)
    ctx.fillCircle(circle(vec2(250, 250), 200))

bxy.addImage("crc", genCircle())

#------------------------------------------------------------------------------

proc imScale*(key: string, size: Vec2): Vec2 =
    ## Returns scale ratio for image to be resized to certain pixel size
    ## 
    let imageInfo = bxy.getImageSize(key)
    result = vec2(size.x / imageInfo.x.float, size.y / imageInfo.y.float)

proc drawImCAST*(
    key: string,
    center: Vec2,
    angle = 0.0,
    scale = vec2(1, 1),
    tint = color(1, 1, 1, 1)
) =
    ## Draws image at center, rotated by angle, scaled by scale, tinted by tint.
    ## 
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
font.paint.color = color(1, 1, 1)

# remove eventually
proc saveText*() =
    let temp = font.typeset("silic.ide")
    let image = newImage(temp.layoutBounds.x.int, temp.layoutBounds.y.int)
    image.fillText(temp)
    image.writeFile("test.png")

proc loadFont() =
    ## Load font glyph images into boxy
    ## 
    let glyphs = {' '..'~'} # faster than seq since no repetition

    for glyph in glyphs:
        let glyArng = font.typeset($glyph)
        let image = newImage(glyArng.layoutBounds.x.int, glyArng.layoutBounds.y.int)
        image.fillText(glyArng)

        bxy.addImage($glyph, image)

loadFont()

proc drawText*(
    str: string,
    xPos, yPos: float, 
    scale: float32 = 1.0, 
    tint = color(1, 1, 1),
    hAlign = CenterAlign
) =
    let chars = @str

    font.size *= scale
    let strArng = font.typeset(str, hAlign=hAlign)
    font.size /= scale

    let height = strArng.layoutBounds.y

    for idx, c in chars: 
        drawImCAST(
            $c, 
            vec2(
                xPos + strArng.positions[idx].x + bxy.getImageSize($c).x.float * scale / 2, 
                yPos - height / 2 + bxy.getImageSize($c).y.float * scale / 2
            ),
            scale=vec2(scale, scale)
        )

#------------------------------------------------------------------------------

proc debugMenu*() =
    drawText("Observed sleep: " & $round(observed * 1e3, 2) & "ms", 50, 50, 0.5, hAlign=LeftAlign)
    drawText("Sleep estimate: " & $round(estimate * 1e3, 2) & "ms", 50, 125, 0.5, hAlign=LeftAlign)