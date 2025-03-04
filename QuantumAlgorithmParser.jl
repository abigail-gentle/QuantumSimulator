include("ProbabalisticQuantumSimulator.jl")
using .ProbabalisticQuantumSimulator

using StatsBase

function QuantumAlgorithmParser(n::Int, file, print_commands=false, print_states=false, target=zeros(n))
    qubits = [Qubit() for _ in 1:n]

    qubits = parseQuantumInstructions(qubits, file, print_commands, print_states)
    

    println("p(|0...0⟩)=$(prod(
        Rational{BigInt}.(getfield.(qubits, :state))
    ))")
    return qubits
end

function parseQuantumInstructions(qubits, file, print_commands=false, print_states=false)
    # Formatting
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
        (command_symbol ∉ names(ProbabalisticQuantumSimulator)) && error("Unregistered Quantum Function $(command)")
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
    return qubits

end

function probabalistic_quantum_parser(qubits, file, target, print_commands=false, print_states=false)
    spaces = "                "
    print_states && println("$spaces $(vec(qubits))")
    # Code
    instructions = readlines(file)
    
    (length(target) != length(qubits)) && error("Length of target must be the same as qubits ($(length(target))≠$(length(qubits)))")
    
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

function create_random_program(n, num_lines, output, rng_set=collect(1:n)[rand(Bool,n)])
    qubits = collect(1:n)
    program = []

    for i in rng_set
        push!(program, "RNG $i")
    end
    commands_and_arguments = Dict(
        "NOT"   => 1,
        "CNOT"  => 2,
        "CCNOT" => 3
    )
    for _ in 1:num_lines
        (command, num_args) = rand(commands_and_arguments)
        targets = sample(qubits, num_args, replace=false)
        push!(program, "$command $(join(targets, " "))")
    end
    write(output, join(program, "\n"))
end