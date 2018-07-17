local state

local gameStates = {}

gameStates.menu = {
    bindings = {
        backToGame = function()  state = gameStates.gameLoop  end,
        scrollUp   = function() --[[<...>]] end,
        scrollDown = function() --[[<...>]] end,
        select     = function() --[[<...>]] end,
    },
    keys = {
        escape     = "backToGame",
        up         = "scrollUp",
        down       = "scrollDown",
        ["return"] = "select",
    },
    keysReleased = {},
    buttons = {
        back = "backToGame",
        up   = "scrollUp",
        down = "scrollDown",
        a    = "select",
    }
    buttonsReleased = {},
    -- <...>
}
gameStates.gameLoop = {
    bindings = {
        openMenu   = function()  state = gameStates.menu  end,
        jump       = function() --[[<...>]] end,
        left       = function() --[[<...>]] end,
        right      = function() --[[<...>]] end,
    },
    keys = {
        escape = "openMenu",
        lshift = "jump",
        left   = "left",
        right  = "right",
    },
    keysReleased = {},
    buttons = {
        back    = "openMenu",
        a       = "jump",
        dpleft  = "left",
        dpright = "right",
    }
    buttonsReleased = {},
    -- <...>
}

function inputHandler( input )
    local action = state.bindings[input]
    if action then  return action()  end
end

function love.keypressed( k )
    -- you might want to keep track of this to change display prompts
    INPUTMETHOD = "keyboard"
    local binding = state.keys[k]
    return inputHandler( binding )
end
function love.keyreleased( k )
    local binding = state.keysReleased[k]
    return inputHandler( binding )
end
function love.gamepadpressed( gamepad, button )
    -- you might want to keep track of this to change display prompts
    INPUTMETHOD = "gamepad"
    local binding = state.buttons[button]
    return inputHandler( binding )
end
function love.gamepadreleased( gamepad, button )
    local binding = state.buttonsReleased[button]
    return inputHandler( binding )
end
