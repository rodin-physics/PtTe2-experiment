include("density.jl")

# Struct of locations used in calculating spectral function
struct KeyLocations
    Corner::Location
    Edge::Location
    Center::Location
end

# Base unit for vacancy clusters
config1 = [Location(1,1)]
config2 = [Location(1,2), Location(2,1), Location(2,0), Location(0,2), Location(1,0), Location(0,1), Location(3,0), Location(0,3), Location(0,0)]

# Function to get neighbouring cells given a location
function neighbors(loc::Location)
    vec = [Location(1,0), Location(0,1), Location(1,-1), Location(-1,1), Location(-1,0), Location(0,-1)]

    return [loc] .+ vec
end

# Function to place potentials in correct locations for finer grid
function make_shape(U1::Float64, U2::Float64, shape::Int64, pt::Bool = true)
    inv = 2 * pt - 1
    
    vec = [Location(0,0), Location(2,0), Location(0,2), Location(4,0), Location(0,4), Location(2,2), Location(6,0), Location(0,6), Location(4,2), Location(2,4)] .* [(Location(inv,inv) * Location(3,3))]

    shift = (shape ÷ -5) * (inv * 3)

    vec = vec .+ [Location(shift, shift)]

    pot1 = vcat(map(y -> map(x -> LocalPotential(U1, x), config1 .+ [y]), vec[1:shape])...)
    pot2 = vcat(map(y -> map(x -> LocalPotential(U2, x), config2 .+ [y]), vec[1:shape])...)

    return vcat(pot1, pot2)
end

# List of KeyLocations for all vacancy clusters
Trimer = KeyLocations(Location(1,1), Location(4,1), Location(3,3))
Hexamer = KeyLocations(Location(-2,-2), Location(4,-2), Location(2,2))
Decamer = KeyLocations(Location(-5, -5), Location(4,-5), Location(1,1))
Inverted_Trimer = KeyLocations(Location(-1,-1), Location(1,1), Location(1,-2))
