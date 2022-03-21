import 
    staticglfw, 
    silicideData

var keyList*: array[KEY_LAST + 1, int]

proc keyCallBack*(window: Window, key, scancode, action, mods: cint) {.cdecl.} =
    keyList[key] = action

    if keyList[KEY_ESCAPE] == PRESS: 
        setWindowShouldClose(window, 1)
    if keyList[KEY_SPACE] == PRESS:
        ##

discard setKeyCallback(window, keyCallBack)