import 
    staticglfw, vmath,
    silicideData

proc keyCallBack(window: Window, key, scancode, action, mods: cint) {.cdecl.} =
    keyList[key] = action

    if keyList[KEY_ESCAPE] == PRESS: 
        setWindowShouldClose(window, 1)

    if keyList[KEY_SPACE] == PRESS:
        lastClicked = 100
        
    if keyList[KEY_TAB] == PRESS:
        showDebug = not showDebug


discard setKeyCallback(window, keyCallBack)

proc mouseButtonCallback(window: Window, button, action, mode: cint) {.cdecl.} =
    mouseBtns[button] = action

    if mouseBtns[MOUSE_BUTTON_1] == PRESS:
        showDebug = not showDebug
    
    if mouseBtns[MOUSE_BUTTON_3] == PRESS:
        showDebug = not showDebug

discard setMouseButtonCallback(window, mouseButtonCallback)

proc getCrsPos*(window: Window) =
    window.getCursorPos(addr crsXPos, addr crsYPos)

    crsXPos /= windowScale.x
    crsYPos /= windowScale.y