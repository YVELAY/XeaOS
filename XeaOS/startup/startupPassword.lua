local function setPassWAttempt(pass,attempt,user)
    local try = ""

    while true do
        term.write("Please enter password to continue: ")
        try = read("*")
        if try ~= pass then
            term.clear()
            term.setCursorPos(1,1)
            attempt = attempt - 1
            print("Wrong password. "..attempt.." attempts left.")
        else
            term.clear()
            term.setCursorPos(1,1)
            print("Welcome "..user.." !")
            shell.setDir("./root/home/"..user)
            break
        end
        if attempt == 0 then
            term.clear()
            term.setCursorPos(1,1)
            print("No attempt left.")
            os.shutdown()
        end
    end
end

local old_pullEvent = os.pullEvent
os.pullEvent = os.pullEventRaw
setPassWAttempt('pass',10,'xea')
os.pullEvent = old_pullEvent
