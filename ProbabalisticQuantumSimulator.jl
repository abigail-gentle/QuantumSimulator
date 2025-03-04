module ProbabalisticQuantumSimulator

import Base: zero, one, abs, *, +, -, show, convert, promote_rule
using Random

export Qubit, NOT, CNOT, CCNOT, RNG

# Overide
export zero, one, abs, *, +, -, show, convert, promote_rule
#export zero, one, abs, show, *, +, -

# Our Qubits are just bits at the moment
mutable struct Qubit{T}
    state::T
end
# Default state
## Probability to be 0 is 1
function Qubit() 
    Qubit(zero(Rational))
end

# for creating arrays
function zero(::T) where T<:Qubit
    (one(T))
end

## Probability to be 1 is zero
function one(::T) where T<:Qubit
    (zero(T))
end

function abs(q::T) where T<:Qubit
    (abs(q.state))
end

# Pretty Printing
Base.show(io::IO, q::T) where T<:Qubit = print(io, "|$(q.state)⟩")
Base.show(io::IO, qv::Vector{T}) where T<:Qubit = print(io, "|$(join([string(q.state) for q in qv],", "))⟩")

# <- Doesn't work ->
function *(a::T, b::T) where T<:Qubit
    T(a.state * b.state)
end

convert(::Type{T}, x) where T<:Qubit = T(x)
promote_rule(::Type{T}, ::Type{S}) where {T<:Qubit, S<:Number} = T


# <--------------->

# Quantum operators
"Toggle `bit i`"
function NOT(i::T) where T<:Qubit
    i.state = (1 - i.state)
end

"if `bit i then toggle bit j`"
function CNOT(i::T, j::T) where T<:Qubit
    j.state = (i.state*j.state + (1-i.state)*(1-j.state))
end

"`if (bit i AND bit j) toggle bit k`"
function CCNOT(i::T, j::T, k::T) where T<:Qubit
    k.state = i.state*j.state*k.state + (1-i.state)*(1-j.state)*(1-k.state)
end

"set `bit i` to 0 or 1 with probability 1/2 each"
function RNG(i::T) where T<:Qubit
    i.state = 1//2
end

end