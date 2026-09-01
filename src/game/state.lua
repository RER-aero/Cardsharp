local State = {}

State.current = nil

function State.switch(newState)
    if State.current and State.current.exit then
        State.current.exit()
    end

    State.current = newState

    if State.current and State.current.enter then
        State.current.enter()
    end
end

function State.update(dt)
    if State.current and State.current.update then
        State.current.update(dt)
    end
end

function State.draw()
    if State.current and State.current.draw then
        State.current.draw()
    end
end

function State.keypressed(key)
    if State.current and State.current.keypressed then
        State.current.keypressed(key)
    end
end

return State