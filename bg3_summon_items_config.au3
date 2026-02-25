#include <Misc.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Opt('MouseCoordMode', 1) ; Absolute screen coordinates.

Global Const $gConfigPath = @ScriptDir & '\bg3_summon_items_config.ini'
Global $gIsRunning = True
Global $gSelectedSlot = ''
Global $gOffsetX = 0
Global $gOffsetY = 0
Global $gLblSelected = 0
Global $gActionHotkey = '{F8}'
Global $gStopHotkey = '{F10}'

LoadHotkeys()

; Build UI
Local $hGui = GUICreate('BG3 Summon Items (Config)', 380, 348)
$gLblSelected = GUICtrlCreateLabel('Selected: None', 20, 12, 330, 20)
GUICtrlCreateLabel(StringFormat('Action: %s   Stop: %s', $gActionHotkey, $gStopHotkey), 20, 30, 330, 20)

Local $btnW = 140
Local $btnH = 28
Local $gapY = 8
Local $startY = 56
Local $col1X = 20
Local $col2X = 190

; Column 1
Local $btnHead = GUICtrlCreateButton('Head', $col1X, $startY + (0 * ($btnH + $gapY)), $btnW, $btnH)
Local $btnCloak = GUICtrlCreateButton('Cloak', $col1X, $startY + (1 * ($btnH + $gapY)), $btnW, $btnH)
Local $btnChest = GUICtrlCreateButton('Chest', $col1X, $startY + (2 * ($btnH + $gapY)), $btnW, $btnH)
Local $btnGloves = GUICtrlCreateButton('Gloves', $col1X, $startY + (3 * ($btnH + $gapY)), $btnW, $btnH)
Local $btnBoots = GUICtrlCreateButton('Boots', $col1X, $startY + (4 * ($btnH + $gapY)), $btnW, $btnH)
Local $btnLight = GUICtrlCreateButton('Light', $col1X, $startY + (5 * ($btnH + $gapY)), $btnW, $btnH)
Local $btnMeleeMain = GUICtrlCreateButton('MeleeMain', $col1X, $startY + (6 * ($btnH + $gapY)), $btnW, $btnH)
Local $btnMeleeOff = GUICtrlCreateButton('MeleeOff', $col1X, $startY + (7 * ($btnH + $gapY)), $btnW, $btnH)

; Column 2
Local $btnAmulet = GUICtrlCreateButton('Amulet', $col2X, $startY + (0 * ($btnH + $gapY)), $btnW, $btnH)
Local $btnRing1 = GUICtrlCreateButton('Ring1', $col2X, $startY + (1 * ($btnH + $gapY)), $btnW, $btnH)
Local $btnRing2 = GUICtrlCreateButton('Ring2', $col2X, $startY + (2 * ($btnH + $gapY)), $btnW, $btnH)
Local $btnInstrument = GUICtrlCreateButton('Instrument', $col2X, $startY + (3 * ($btnH + $gapY)), $btnW, $btnH)
Local $btnRangedMain = GUICtrlCreateButton('RangedMain', $col2X, $startY + (4 * ($btnH + $gapY)), $btnW, $btnH)
Local $btnRangedOff = GUICtrlCreateButton('RangedOff', $col2X, $startY + (5 * ($btnH + $gapY)), $btnW, $btnH)

GUISetState(@SW_SHOW, $hGui)
ConsoleWrite('Config file: ' & $gConfigPath & @CRLF)
ConsoleWrite('UI ready. Select a slot button, then press ' & $gActionHotkey & '.' & @CRLF)
ConsoleWrite('Press ' & $gStopHotkey & ' to stop.' & @CRLF)

While $gIsRunning
    Local $msg = GUIGetMsg()
    Switch $msg
        Case $GUI_EVENT_CLOSE
            $gIsRunning = False
        Case $btnHead
            SetSlot('Head')
        Case $btnCloak
            SetSlot('Cloak')
        Case $btnChest
            SetSlot('Chest')
        Case $btnGloves
            SetSlot('Gloves')
        Case $btnBoots
            SetSlot('Boots')
        Case $btnLight
            SetSlot('Light')
        Case $btnMeleeMain
            SetSlot('MeleeMain')
        Case $btnMeleeOff
            SetSlot('MeleeOff')
        Case $btnAmulet
            SetSlot('Amulet')
        Case $btnRing1
            SetSlot('Ring1')
        Case $btnRing2
            SetSlot('Ring2')
        Case $btnInstrument
            SetSlot('Instrument')
        Case $btnRangedMain
            SetSlot('RangedMain')
        Case $btnRangedOff
            SetSlot('RangedOff')
    EndSwitch
    Sleep(20)
WEnd

GUIDelete($hGui)

Func LoadHotkeys()
    $gActionHotkey = IniRead($gConfigPath, 'Hotkeys', 'Action', '{F8}')
    $gStopHotkey = IniRead($gConfigPath, 'Hotkeys', 'Stop', '{F10}')

    If Not HotKeySet($gActionHotkey, 'HandleAction') Then
        ConsoleWrite('Invalid Action hotkey in config. Falling back to {F8}.' & @CRLF)
        $gActionHotkey = '{F8}'
        HotKeySet($gActionHotkey, 'HandleAction')
    EndIf

    If Not HotKeySet($gStopHotkey, 'HandleStop') Then
        ConsoleWrite('Invalid Stop hotkey in config. Falling back to {F10}.' & @CRLF)
        $gStopHotkey = '{F10}'
        HotKeySet($gStopHotkey, 'HandleStop')
    EndIf
EndFunc

Func SetSlot($slotName)
    Local $offsetX = IniRead($gConfigPath, 'Offsets', $slotName & 'X', '0')
    Local $offsetY = IniRead($gConfigPath, 'Offsets', $slotName & 'Y', '0')

    If Not StringIsInt($offsetX) Or Not StringIsInt($offsetY) Then
        ConsoleWrite(StringFormat('Invalid offsets for %s in config. Using 0,0.', $slotName) & @CRLF)
        $offsetX = 0
        $offsetY = 0
    EndIf

    $gSelectedSlot = $slotName
    $gOffsetX = Number($offsetX)
    $gOffsetY = Number($offsetY)

    GUICtrlSetData($gLblSelected, StringFormat('Selected: %s (%d, %d)', $gSelectedSlot, $gOffsetX, $gOffsetY))
    ConsoleWrite(StringFormat('Slot selected: %s, offsetX=%d, offsetY=%d', $gSelectedSlot, $gOffsetX, $gOffsetY) & @CRLF)
EndFunc

Func HandleAction()
    If $gSelectedSlot = '' Then
        ConsoleWrite($gActionHotkey & ' ignored: no slot selected.' & @CRLF)
        Return
    EndIf

    ConsoleWrite(StringFormat('Action hotkey pressed for %s, capturing current mouse position.', $gSelectedSlot) & @CRLF)

    ; Collecting start x,y position
    Local $aPos = MouseGetPos()
    Local $x = $aPos[0]
    Local $y = $aPos[1]
    ConsoleWrite(StringFormat('Captured position: x=%d, y=%d', $x, $y) & @CRLF)

    ; Setting offsets for the selected slot
    Local $targetX = $x + $gOffsetX
    Local $targetY = $y + $gOffsetY
    ConsoleWrite(StringFormat('Target position: x=%d, y=%d', $targetX, $targetY) & @CRLF)

    ; Setting drag offsets so we can move the item
    Local $dragX = $targetX + 30
    Local $dragY = $targetY + 30
    ConsoleWrite(StringFormat('Drag position: x=%d, y=%d', $dragX, $dragY) & @CRLF)

    ; Pressing the preview button
    MouseClick('left', $x, $y, 1, 0)

    ; Move to the slot
    MouseMove($targetX, $targetY, 3)
    ; Holding left mouse button down
    MouseDown('left')
    ConsoleWrite(StringFormat('Mouse down at x=%d, y=%d', $targetX, $targetY) & @CRLF)

    ; Move mouse while holding down for the drag effect
    MouseMove($dragX, $dragY, 4)
    ConsoleWrite(StringFormat('Dragged to position: x=%d, y=%d', $dragX, $dragY) & @CRLF)
EndFunc

Func HandleStop()
    ConsoleWrite($gStopHotkey & ' pressed. Stopping script.' & @CRLF)
    MouseUp('left')
    $gIsRunning = False
EndFunc
