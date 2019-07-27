class Prototype
    attr_accessor :inputs, :outputs, :state
  
    def tick
        defaults
        render
        calc
        process_inputs
    end

    def defaults
        state.playerControlCord ||= [590, 230]
        state.currentPlayer ||= 1

        state.players ||= [
            [:playerOne,   590, 230, 1],
            [:playerTwo,     0,   0, 2],
            [:playerThree, 800, 200, 3]
        ].map do |name, x, y, order|
            state.new_entity(name) do |p|
                p.name = name
                p.absolutex = x
                p.absolutey = y
                p.relativex = x - state.playerControlCord[0]
                p.relativey = y - state.playerControlCord[1]
                p.order = order
                p.sprite = "sprites/player" + order.to_s + ".png"
            end
        end
    end

    def render
        outputs.sprites += state.players.map {
            |p|
            [p.absolutex, p.absolutey, 75, 150, p.sprite]
        }


    end

    def calc

    end

    def process_inputs
        if inputs.keyboard.key_up.r
            $dragon.reset
        end

        if inputs.keyboard.key_up.1 && state.currentPlayer != 1
            transition(1)
        end

    end

    def transition n
        state.currentPlayer = n
        state.playerControlCord = [state.players[n - 1].absolutex, state.players[n - 1].absolutey]

        state.players.map {
            |p|
            unless p.order == n
              p.absolutex = p.x + state.playerControlCord[0]    #Double check logic plz future me
              p.absolutey = p.y + state.playerControlCord[1]
            end
        }

    end
  
end

$prototype = Prototype.new

def tick args
    $prototype.inputs = args.inputs
    $prototype.state = args.state
    $prototype.outputs = args.outputs
    $prototype.tick
end

