include("general.jl")

struct LocalPotential           # This is Dirac potential
    V::Float64                  # Additive potential
    loc::Location               # Location of the unit cell
end

struct AtomsSystem
    μ::Float64                          # Chemical potential
    T::Float64                          # Temperature
    potential::Vector{LocalPotential}   # Local potential
end

function diag_V(potential::Vector{LocalPotential})
    U_ = map(x -> x.V, potential) |> Diagonal
    return U_
end
