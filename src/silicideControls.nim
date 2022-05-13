import 
    staticglfw, vmath,
    silicideData

proc keyCallBack*(window: Window, key, scancode, action, mods: cint) {.cdecl.} =
    keyList[key] = action

    if keyList[KEY_ESCAPE] == PRESS: 
        setWindowShouldClose(window, 1)
    if keyList[KEY_SPACE] == PRESS:
        lastClicked = 100
    if keyList[KEY_TAB] == PRESS:
        showDebug = not showDebug


discard setKeyCallback(window, keyCallBack)

proc getCrsPos*(window: Window) =
    window.getCursorPos(addr crsXPos, addr crsYPos)

    crsXPos /= windowScale.x
    crsYPos /= windowScale.y