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
bxy.addImage("crc", readImage("circle.png"))
bxy.addImage("crcBrd", readImage("circleBorder.png"))

#------------------------------------------------------------------------------

proc imScale*(key: string, size: Vec2): Vec2 =
    ## Returns scale ratio for image to be resized to certain pixel size

    let imageInfo = bxy.getImageSize(key)
    result = vec2(size.x / imageInfo.x.float, size.y / imageInfo.y.float)

proc drawImCst*(
    key: string,
    center: Vec2,
    angle = 0.0,
    scalePx = vec2(100, 100),
    tint = color(1, 1, 1, 1),
    opOrder = SclFirst
) =
    ## Draws image at center, rotated by angle degrees, scaled to ScalePx pixels, tinted by tint

    let scaleRatio = imScale(key, scalePx)
    let imageInfo = bxy.getImageSize(key)
    let angleRad = angle * PI / 180

    bxy.saveTransform()
    bxy.translate(center)

    if opOrder == RotFirst:
        bxy.scale(
            scaleRatio / imScale(
                key,
                vec2(
                    abs(imageInfo.x.float * sin(angleRad)) + abs(imageInfo.y.float * cos(angleRad)),
                    abs(imageInfo.x.float * cos(angleRad)) + abs(imageInfo.y.float * sin(angleRad))
                )
                
            )
        )

    bxy.rotate(angleRad)

    if opOrder == SclFirst:
        bxy.scale(scaleRatio)

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
    heightPx = 100.0, 
    tint = color(1, 1, 1),
    hAlign = CenterAlign
) =
    let chars = @str
    let scale = heightPx / font.size
    let fontSave = font.size

    font.size *= scale
    let strArng = font.typeset(str, hAlign=hAlign)
    font.size = fontSave

    let height = strArng.layoutBounds.y

    for idx, c in chars:
        let charStr = $c
        let imgSize = bxy.getImageSize(charStr)
        let scaledGlyphWidth = imgSize.x.float * scale

        drawImCst(
            charStr, 
            vec2(
                xPos + strArng.positions[idx].x + scaledGlyphWidth / 2, 
                yPos - height / 2 + imgSize.y.float * scale / 2
            ),
            scalePx=vec2(scaledGlyphWidth, height)
        )

#------------------------------------------------------------------------------

proc debugMenu*() =
    ## Draw debug info
    
    drawText("Frame Time: " & ($(frameTime * 1e3))[0..4] & "ms", 50, 50, 35, hAlign=LeftAlign)
    drawText("Skipped Syncs: " & $skippedSyncs, 50, 100, 35, hAlign=LeftAlign)
    drawText("Observed sleep: " & $round(observed * 1e3, 2) & "ms", 50, 150, 35, hAlign=LeftAlign)
    drawText("Sleep estimate: " & $round(estimate * 1e3, 2) & "ms", 50, 200, 35, hAlign=LeftAlign)