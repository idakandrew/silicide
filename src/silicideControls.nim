import 
    staticglfw, vmath,
    silicideData

proc snapPos*(crsX, crsY: int32): IVec2 =
    return ivec2((crsX / 80).int32 * 80, (crsY / 80).int32 * 80)

# rounding towards zero is an issue
proc snapPosCntr*(crsX, crsY: float): IVec2 =
    return ivec2(vec2(floor(crsX / 80) * 80 + 40, floor(crsY / 80) * 80 + 40))

proc getCrsPos*() =
    window.getCursorPos(addr crsScrnX, addr crsScrnY)

    crsScrnX /= windowScale.x
    crsScrnY /= windowScale.y

proc getCrsMapPos*() =
    (crsMapX, crsMapY) = snapPosCntr(crsScrnX + mapX.float, crsScrnY + mapY.float)

#------------------------------------------------------------------------------

proc keyCallBack(window: Window, key, scancode, action, mods: cint) {.cdecl.} =
    ## Reads key inputs and handles non-repeating key events
    
    keyList[key] = action

    if keyList[KEY_ESCAPE] == PRESS: 
        setWindowShouldClose(window, 1)

    if keyList[KEY_TAB] == PRESS:
        showDebug = not showDebug

    if keyList[KEY_1] == PRESS:
        selectedElem = Nts
    elif keyList[KEY_2] == PRESS:
        selectedElem = Pts
    elif keyList[KEY_3] == PRESS:
        selectedElem = Met
    elif keyList[KEY_4] == PRESS:
        selectedElem = Via

discard setKeyCallback(window, keyCallBack)

proc keyRepeatHandler*(window: Window) =
    ## Handles repeating key events
    
    if keyList[KEY_W] in {PRESS, REPEAT}:
        mapY -= 3

    if keyList[KEY_S] in {PRESS, REPEAT}:
        mapY += 3

    if keyList[KEY_D] in {PRESS, REPEAT}:
        mapX += 3

    if keyList[KEY_A] in {PRESS, REPEAT}:
        mapX -= 3

proc mouseButtonCallback(window: Window, button, action, mode: cint) {.cdecl.} =
    mouseBtns[button] = action

    if mouseBtns[MOUSE_BUTTON_1] == PRESS:
        map[ivec2(crsMapX, crsMapY)] = Component(elem: selectedElem, activ: false, nghbrs: 0)
    elif mouseBtns[MOUSE_BUTTON_2] == PRESS:
        map.del(ivec2(crsMapX, crsMapY))
    
    if mouseBtns[MOUSE_BUTTON_3] == PRESS:
        showDebug = not showDebug

discard setMouseButtonCallback(window, mouseButtonCallback)
