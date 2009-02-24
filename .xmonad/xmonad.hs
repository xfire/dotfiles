import XMonad hiding (Tall)
import XMonad.Operations

import XMonad.Actions.DwmPromote
import XMonad.Actions.CycleWS
import XMonad.Actions.RotSlaves
import XMonad.Actions.FindEmptyWorkspace

import XMonad.Layout hiding (Tall)
import XMonad.Layout.NoBorders
import XMonad.Layout.WindowNavigation
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Reflect
import XMonad.Layout.MultiToggle
import XMonad.Layout.HintedTile
import XMonad.Layout.IM
--  import XMonad.Layout.Grid

import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.Input

import XMonad.Util.Run

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog   ( PP(..), dynamicLogWithPP, dzenColor, wrap, defaultPP )
import XMonad.Hooks.XPropManage
import XMonad.Hooks.UrgencyHook

import qualified XMonad.StackSet as W

import qualified Data.Map as M
import Data.Bits ((.|.))
import Data.Ratio
import Data.Maybe
import Data.List
import Graphics.X11
--  import Graphics.X11.ExtraTypes.XF86
import System.IO
import System.Exit

-- needed till Graphics.X11.ExtraTypes.XF86 is available
xF86XK_AudioLowerVolume     :: KeySym
xF86XK_AudioLowerVolume     = 269025041
xF86XK_AudioMute            :: KeySym
xF86XK_AudioMute            = 269025042
xF86XK_AudioRaiseVolume     :: KeySym
xF86XK_AudioRaiseVolume     = 269025043
xF86XK_ScreenSaver          :: KeySym
xF86XK_ScreenSaver          = 269025069
xF86XK_AudioPlay            :: KeySym
xF86XK_AudioPlay            = 269025044
xF86XK_AudioStop            :: KeySym
xF86XK_AudioStop            = 269025045
xF86XK_AudioPrev            :: KeySym
xF86XK_AudioPrev            = 269025046
xF86XK_AudioNext            :: KeySym
xF86XK_AudioNext            = 269025047

fireFont = "snap"
fireXFont = "-artwiz-snap-*-*-*-*-*-*-*-*-*-*-iso8859"

colorNormalFG = "#B6B4B8"
colorNormalBG = "#1C2636"
colorNormalBO = "#1C2636"
colorFocusFG = "#FFFFFF"
colorFocusBG = "#1C2636"
colorFocusBO = "#FF0000"
colorOtherFG = "#707070"
colorOtherBG = "#1C2636"

statusBarCmd = "dzen2_multiscreen" ++ 
               " -bg '" ++ colorNormalBG ++ "'" ++
               " -fg '" ++ colorNormalFG ++ "'" ++
               " -w 620 -sa c" ++
               " -fn '" ++ fireXFont ++ "'" ++
               " -ta l -e ''"

fireWorkspaces = map ("F" ++ ) (map show [1..12 :: Int]) ++ map show [1..9 :: Int] ++ ["0"]
fireWorkspacesKM = [xK_F1..xK_F12] ++ [xK_1..xK_9] ++ [xK_0]
fireScreensKM = [xK_w, xK_q]
--  fireScreensKM = [xK_q, xK_w]
 
main = do din <- spawnPipe statusBarCmd
          xmonad $ withUrgencyHook NoUrgencyHook
          --  xmonad $ withUrgencyHook dzenUrgencyHook { args = ["-bg", "darkgreen", "-xs", "0"] }
                 $ defaultConfig { 
              borderWidth        = 1,
              normalBorderColor  = colorNormalBO,
              focusedBorderColor = colorFocusBO,
              workspaces         = fireWorkspaces,
              terminal           = "x-terminal-emulator",
              modMask            = mod4Mask,
              manageHook         = manageDocks <+> xPropManageHook fireXPropHook,
              logHook            = dynamicLogWithPP $ firePP din,
              layoutHook         = 
                  onWorkspace "F2" ( 
                    windowNavigation ( 
                      avoidStruts (
                        noBorders Full ||| 
                        mkToggle (single REFLECTX) (tiled)
                      )
                    )
                  ) $
                  onWorkspace "F3" (
                    windowNavigation (
                      avoidStruts (
                        -- HintedTile 1 (3%100) (1%4) Center Tall
                        withIM (1%4) (And (ClassName "Pidgin") (Role "buddy_list")) (Mirror tiled)
                      )
                    )
                  ) $
                  onWorkspace "F5" (
                    windowNavigation (
                      avoidStruts (
                        Mirror tiled
                      )
                    )
                  ) $
                  windowNavigation( 
                    avoidStruts (
                      mkToggle (single REFLECTX) (tiled) ||| 
                      Mirror tiled ||| 
                      noBorders Full ||| 
                      ThreeCol 1 (3/100) (1/2)
                      --  Grid
                    )
                  ),
              keys               = fireKeys
          } where
            tiled = HintedTile 1 (3%100) (1%2) Center Tall
            fireKeys conf@(XConfig {modMask = modMask}) = M.fromList $
               [ ((modMask                                 , xK_p         ), shellPrompt fireSPConfig),
                 ((modMask               .|. controlMask   , xK_Return    ), dwmpromote),

                 ((modMask                                 , xK_space     ), sendMessage NextLayout),
                 ((modMask .|. shiftMask                   , xK_space     ), setLayout $ XMonad.layoutHook conf),

                 ((modMask                                 , xK_x         ), sendMessage $ Toggle REFLECTX),
                 ((modMask                                 , xK_y         ), sendMessage $ Toggle REFLECTY),

                 ((modMask                                 , xK_b         ), sendMessage ToggleStruts),
                 ((modMask                                 , xK_BackSpace ), toggleWS),

                 ((modMask                                 , xK_Tab       ), rotAllUp),
                 ((modMask .|. shiftMask                   , xK_Tab       ), rotAllDown),

                 ((modMask                                 , xK_Left      ), moveTo Prev HiddenNonEmptyWS),
                 ((modMask                                 , xK_Right     ), moveTo Next HiddenNonEmptyWS),
                 ((modMask                                 , xK_l         ), moveTo Next HiddenNonEmptyWS),
                 ((modMask                                 , xK_h         ), moveTo Prev HiddenNonEmptyWS),

                 ((modMask               .|. controlMask   , xK_e         ), tagToEmptyWorkspace),
                 ((modMask                                 , xK_e         ), viewEmptyWorkspace),

                 ((modMask .|. shiftMask                   , xK_Right     ), sendMessage $ Go R),
                 ((modMask .|. shiftMask                   , xK_Left      ), sendMessage $ Go L),
                 ((modMask .|. shiftMask                   , xK_Up        ), sendMessage $ Go U),
                 ((modMask .|. shiftMask                   , xK_Down      ), sendMessage $ Go D),
                 ((modMask .|. shiftMask                   , xK_l         ), sendMessage $ Go R),
                 ((modMask .|. shiftMask                   , xK_h         ), sendMessage $ Go L),
                 ((modMask .|. shiftMask                   , xK_k         ), sendMessage $ Go U),
                 ((modMask .|. shiftMask                   , xK_j         ), sendMessage $ Go D),
                 ((modMask               .|. controlMask   , xK_Right     ), sendMessage $ Swap R),
                 ((modMask               .|. controlMask   , xK_Left      ), sendMessage $ Swap L),
                 ((modMask               .|. controlMask   , xK_Up        ), sendMessage $ Swap U),
                 ((modMask               .|. controlMask   , xK_Down      ), sendMessage $ Swap D),
                 ((modMask               .|. controlMask   , xK_l         ), sendMessage $ Swap R),
                 ((modMask               .|. controlMask   , xK_h         ), sendMessage $ Swap L),
                 ((modMask               .|. controlMask   , xK_k         ), sendMessage $ Swap U),
                 ((modMask               .|. controlMask   , xK_j         ), sendMessage $ Swap D),

                 ((modMask                                 , xK_comma     ), sendMessage Shrink),
                 ((modMask                                 , xK_period    ), sendMessage Expand),
                 ((modMask .|. shiftMask                   , xK_comma     ), sendMessage (IncMasterN 1)),
                 ((modMask .|. shiftMask                   , xK_period    ), sendMessage (IncMasterN (-1))),

                 ((modMask                                 , xK_t         ), withFocused $ windows . W.sink),
                 ((modMask                                 , xK_f         ), focusUrgent),

                 ((modMask               .|. controlMask   , xK_c         ), kill),
                 ((modMask                                 , xK_n         ), refresh),
                 ((modMask                                 , xK_r         ), restart "xmonad" True),

                 ((modMask                                 , xK_Return    ), spawn $ terminal conf),
                 ((modMask .|. shiftMask                   , xK_Return    ), spawn $ terminal conf ++ " -fg red -e sudo su -"),
                 ((modMask .|. shiftMask                   , xK_b         ), spawn $ "set_random_wallpaper.zsh"),
                 ((modMask                                 , xK_a         ), commandPrompt fireSPConfig "command" commands),

                 ((0                            , xF86XK_ScreenSaver      ), spawn "slock"),
                 ((0                            , xF86XK_AudioMute        ), spawn "sound.sh mute"),
                 ((0                            , xF86XK_AudioLowerVolume ), spawn "sound.sh lower"),
                 ((0                            , xF86XK_AudioRaiseVolume ), spawn "sound.sh raise")
               ]
               ++ -- workspaces 1..9 0 F1..F12
               [((m .|. modMask, k), windows $ f i)
                   | (i, k) <- zip (workspaces conf) fireWorkspacesKM
                   , (f, m) <- [(W.greedyView, 0),          -- view workspace
                                (W.shift, controlMask)]       -- move to workspace
               ]
               ++ -- screens qw
               [((m .|. modMask, k), screenWorkspace sc >>= flip whenJust (windows . f))
                   | (k, sc) <- zip fireScreensKM [0..]
                   , (f, m) <- [(W.view, 0),                -- switch to screen
                                (W.shift, controlMask)]     -- move to screen
               ]

-- special command prompt
commandPrompt :: XPConfig -> String -> M.Map String (X ()) -> X ()
commandPrompt c p m = inputPromptWithCompl c p (mkComplFunFromList (M.keys m)) ?+ (\k -> fromMaybe (return ()) (M.lookup k m))

commands :: M.Map String (X ())
commands = M.fromList [
    ("quit"         , io $ exitWith ExitSuccess),
    ("restart"      , restart "xmonad" True),
    ("lock"         , spawn $ "slock"),
    ("mail"         , spawn $ "start.mail"),
    ("firefox"      , spawn $ "firefox"),
    ("opera"        , spawn $ "opera")]

-- Window rules (floating, tagging, etc) {{{
--
fireXPropHook :: [XPropMatch]
fireXPropHook = 
    [ ([ (wM_CLASS, any ("MPlayer"==))],          pmX float),
      ([ (wM_CLASS, any ("gimp"==))],             pmX float),
      ([ (wM_CLASS, any ("Gimp"==))],             pmX float),
      ([ (wM_CLASS, any ("mail_downgrade"==))],   pmP (W.shift "F1")),
      ([ (wM_CLASS, any ("Firefox-bin"==))],      pmP (W.shift "F2")),
      ([ (wM_CLASS, any ("Iceweasel"==))],        pmP (W.shift "F2")),
      ([ (wM_CLASS, any ("opera"==))],            pmP (W.shift "F2")),
      ([ (wM_CLASS, any ("irssi_downgra_de"==))], pmP (W.shift "F3")),
      ([ (wM_CLASS, any ("pidgin"==))],           pmP (W.shift "F3")),
      ([ (wM_CLASS, any ("logger_osd"==))],       pmP (W.shift "F5")),
      ([ (wM_CLASS, any ("logger_syslog"==))],    pmP (W.shift "F5"))
    ]


-- dynamiclog pretty printer for dzen
--
firePP h = defaultPP 
                 { ppCurrent = wrap ("^fg(" ++ colorFocusFG ++ ")^bg(" ++ colorFocusBG ++ ")^p(2)") "^p(2)^fg()^bg()",
                   ppVisible = wrap ("^fg(" ++ colorOtherFG ++ ")^bg(" ++ colorOtherBG ++ ")^p(2)") "^p(2)^fg()^bg()",
                   ppSep     = " ^fg(grey60)^r(1x8)^fg() ",
                   ppLayout  = dzenColor colorNormalFG "" . (\x -> case x of
                                    "Tall"                 -> "^i(/home/fire/.xmonad/icons/tall.xbm)"
                                    "ReflectX Tall"        -> "^i(/home/fire/.xmonad/icons/rtall.xbm)"
                                    "Mirror Tall"          -> "^i(/home/fire/.xmonad/icons/mtall.xbm)"
                                    "IM Mirror Tall"       -> "^i(/home/fire/.xmonad/icons/mtall.xbm)"
                                    "ReflectY Mirror Tall" -> "^i(/home/fire/.xmonad/icons/rmtall.xbm)"
                                    "Full"                 -> "^i(/home/fire/.xmonad/icons/full.xbm)"
                                    "ThreeCol"             -> "^i(/home/fire/.xmonad/icons/threecol.xbm)"
                                    "Grid"                 -> "^i(/home/fire/.xmonad/icons/grid.xbm)"
                                    _                      -> " " ++ x ++ " "
                               ),
                   ppTitle   = dzenColor colorFocusFG "" . wrap "<" ">" ,
                   ppOutput  = hPutStrLn h,
                   ppUrgent  = wrap ("^fg(#FF0000)^bg(" ++ colorOtherBG ++ ")^p(2)") "^p(2)^fg()^bg()"
                  }
 
-- shellprompt config
--

fireSPConfig = XPC { font              = fireXFont,
                     bgColor           = colorFocusBG,
                     fgColor           = colorNormalFG,
                     bgHLight          = colorNormalBG,
                     fgHLight          = colorFocusFG,
                     borderColor       = "black",
                     promptBorderWidth = 0,
                     position          = Bottom,
                     height            = 12,
                     historySize       = 256,
                     defaultText       = "",
                     autoComplete      = Nothing
                   }
