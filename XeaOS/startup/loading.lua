local utils = require("utils")
local termUtil = utils.termUtil

termUtil.clear()

local x, y = term.getCursorPos()
local width, height = term.getSize()
term.setCursorPos(math.floor((width - #"XeaOS") / 2) + 1, 7)
term.write("XeaOS")
term.setCursorBlink(false)

function loadingPrint(text,offset)
    term.setCursorPos(math.floor((width - #text) / 2) + offset, 8)
    term.clearLine()
    term.write(text)
    os.sleep(0.7)
end

function progressPrint(text,offset,sleep)
    term.setCursorPos(math.floor((width - #text) / 2) + offset, 10)
    term.clearLine()
    term.write(text)
    os.sleep(sleep)
end

function loading()
    while true do
        loadingPrint("Loading.",1)
        loadingPrint("Loading..",1)
        loadingPrint("Loading...",2)
    end
end

function loadingProgress()
    progressPrint("[#            ]",1,1)
    progressPrint("[##           ]",1,1)
    progressPrint("[###          ]",1,1)
    progressPrint("[####         ]",1,0.2)
    progressPrint("[#####        ]",1,1)
    progressPrint("[######       ]",1,1)
    progressPrint("[#######      ]",1,0)
    progressPrint("[########     ]",1,0)
    progressPrint("[#########    ]",1,1)
    progressPrint("[##########   ]",1,3)
    progressPrint("[###########  ]",1,0.2)
    progressPrint("[############ ]",1,0.2)
    progressPrint("[#############]",1,1)
end

parallel.waitForAny(loading,loadingProgress)

term.setCursorPos(math.floor((width - #"Done.") / 2) + 1, 8)
term.clearLine()
term.write("Done.")
term.setCursorPos(math.floor((width - #"Welcome to XeaOS !") / 2) + 2, 10)
term.clearLine()
textutils.slowPrint("Welcome to XeaOS !", 5)
os.sleep(2)
termUtil.clear()
shell.run("mainMenu")