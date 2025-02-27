include("QuantumSimulator.jl")
using .QuantumSimulator



function QuantumAlgorithmParser(n::Int, file, print_commands=false, print_states=false)
    qubits = [Qubit() for i in 1:n]

    parseQuantumInstructions(qubits, file, print_commands, print_states)
    
    println(qubits)
    return qubits
end

function parseQuantumInstructions(qubits, file, print_commands=false, print_states=false)
    # Formatting
    line_length = 16
    spaces = "                "
    print_states && println("$spaces $(vec(qubits))")
    # Code
    instructions = readlines(file)
    
    
    for line in instructions
        parts = split(line)
        command = parts[1]
        variables = parse.(Int, parts[2:end])

        # Parsing Function
        ## Convert String to Julia "Symbol" Type
        command_symbol = Meta.parse(command)
        ## Make sure function is exported from our Quantum Simulator
        (command_symbol ∉ names(QuantumSimulator)) && error("Unregistered Quantum Function $(command)")
        ## Evaluate the symbol into a function
        command_function = eval(command_symbol)
        ## Call the function on the variables
        command_function(qubits[variables]...)

        # Printing
        if (print_commands || print_states)
            l = length(line) + 1
            print_commands && print("$line ")
            print_commands && print(spaces[l:end])
            print_states && print(vec(qubits))
            println()
        end
    end

end