class Prototype
    attr_accessor :inputs, :outputs, :state
  
    def tick
        defaults
        render
        calc
        process_inputs
    end

    def defaults
        state.currentPlayer ||= 1
        state.walkingSpeed  ||= 4

        state.players ||= [
            [:playerOne,  4590, 230, 1],
            [:playerTwo,  4000,   0, 2],
            [:playerThree,4800, 200, 3]
        ].map do |name, x, y, order|
            state.new_entity(name) do |p|
                p.name = name
                p.absolutex = x
                p.absolutey = y
                p.order = order
                p.sprite = "sprites/player" + order.to_s + ".png"
            end
        end

        state.playerControlCord = [state.players[state.currentPlayer - 1].absolutex, state.players[state.currentPlayer - 1].absolutey]

    end

    def render
        state.deltaX = state.playerControlCord[0] - 590
        state.deltaY = state.playerControlCord[1] - 230
        outputs.sprites += state.players.map {
            |p|
            if render?(p.absolutex, p.absolutey)
                [p.absolutex - state.deltaX, p.absolutey - state.deltaY, 75, 150, p.sprite]
            else
                []
            end
        }
    end

    def render? x, y
        if x >= state.playerControlCord[0] - 590 && x <= state.playerControlCord[0] + 690 &&
           y >= state.playerControlCord[1] - 230 && y <= state.playerControlCord[1] + 490
            return true
        end
        return false
    end

    def calc

    end

    def process_inputs
        if inputs.keyboard.key_up.r
            $dragon.reset
        end

        transitionPlayer(1) if inputs.keyboard.key_up.one   && state.currentPlayer != 1
        transitionPlayer(2) if inputs.keyboard.key_up.two   && state.currentPlayer != 2
        transitionPlayer(3) if inputs.keyboard.key_up.three && state.currentPlayer != 3

        state.players[state.currentPlayer - 1].absolutex += state.walkingSpeed if inputs.keyboard.key_down.d
        state.players[state.currentPlayer - 1].absolutex -= state.walkingSpeed if inputs.keyboard.key_down.a
        state.players[state.currentPlayer - 1].absolutey += state.walkingSpeed if inputs.keyboard.key_down.w
        state.players[state.currentPlayer - 1].absolutey -= state.walkingSpeed if inputs.keyboard.key_down.s
        
    end

    def transitionPlayer n
        state.currentPlayer = n

        state.deltaX = state.players[n - 1].absolutex - state.playerControlCord[0]
        state.deltaY = state.players[n - 1].absolutey - state.playerControlCord[1]

        state.players.map {
            |p|
            p.absolutex -= state.deltaX
            p.absolutey -= state.deltaY
        }

        state.playerControlCord[0] = state.players[n - 1].absolutex
        state.playerControlCord[1] = state.players[n - 1].absolutey

    end
  
end

$prototype = Prototype.new

def tick args
    $prototype.inputs = args.inputs
    $prototype.state = args.state
    $prototype.outputs = args.outputs
    $prototype.tick
end
