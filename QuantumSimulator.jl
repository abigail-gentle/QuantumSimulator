module QuantumSimulator

import Base: zero, one, abs, *, +
using Random

export Qubit, NOT, CNOT, CCNOT, RNG

# Overide
export zero, one, abs, *, show

# Our Qubits are just bits at the moment
mutable struct Qubit
    state
end
# Default state
function Qubit()
    Qubit(false)
end

# for creating arrays
function zero(::Type{Qubit})
    Qubit()
end
function one(::Type{Qubit})
    Qubit(true)
end
function abs(q::Type{Qubit})
    Int(q.state)
end

# Common operators
function *(x::T, y::T) where T<:Qubit
    Qubit(x.state * y.state)
end

# Pretty Printing
Base.show(io::IO, q::Qubit) = print(io, "|$(Int(q.state))⟩")
Base.show(io::IO, qv::Vector{Qubit}) = print(io, "|$([Int(q.state) for q in qv]...)⟩")
# Quantum operators

"Toggle `bit i`"
function NOT(i::Qubit)
    i.state = !i.state
end

"if `bit i then toggle bit j`"
function CNOT(i::Qubit, j::Qubit)
    if i.state
        j.state = !j.state
    end
end

"`if (bit i AND bit j) toggle bit k`"
function CCNOT(i::Qubit, j::Qubit, k::Qubit)
    if (i.state && j.state)
        k.state = !k.state
    end
end

"set `bit i` to 0 or 1 with probability 1/2 each"
function RNG(i::Qubit)
    i.state = rand(Bool)    
end

end