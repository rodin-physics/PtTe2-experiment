include("../src/density.jl")

## Parameters for the spectral function plot
μ = 0.30            # Chemical potential
T = 0.0             # Temperature

nPts = 600;         # Number of points in the spectral function curve
x_pos = 50;  # Number of unit cells to be plotted in positive x  direction for neutral SV
# y_pos = 10;        #Number of unit cells to be plotted in positive y direction for both SVs

# Cut settings
xs = -x_pos:x_pos

#slice energy
ω = -0.01


# Coordinates of the UC's
XS = repeat(xs, 1, length(xs))
YS = permutedims(XS)


# Energies used in the spectral function
ω_min = -1.5;
ω_max = 4.5;
ωs = range(ω_min, ω_max, length = nPts)

# Plotting for different values of the potential
Delta_1 = LocalPotential(-0.5, Location(0, 0))
Delta_2 = LocalPotential(-1.0, Location(0, 0))
Delta_3 = LocalPotential(-1.5, Location(0, 0))
#List of local potentials to simulate the charged and neutral SVs
U_val1 = -1.5
U_val2 = -0.2


## Base units for vacancy clusters
small_triangle_base = [Location(0,0), Location(0,1), Location(1,0)]

some_2NNs_base = vcat(small_triangle_base,[Location(-1,0), Location(0,-1), Location(0,2), Location(-1,2), Location(2,0), Location(2,-1)])

all_2NNs_base = vcat(small_triangle_base, [Location(-1,0), Location(0,-1), Location(0,2), Location(-1,2), Location(2,0), Location(2,-1), Location(1,1), Location(-1,1), Location(1,-1)])


## Function to place potentials in correct UCs
function make_shape(U1::Float64, U2::Float64, shape::Int64, base_unit::Vector{Location})
    vec = [Location(0,0), Location(2,0), Location(0,2), Location(4,0), Location(0,4), Location(2,2), Location(6,0), Location(0,6), Location(4,2), Location(2,4)]

    shift = shape ÷ -5

    vec = vec .+ [Location(shift, shift)]

    if length(base_unit) == 3 || length(base_unit) == 4
        pot = vcat(map(y -> map(x -> LocalPotential(U1, x), base_unit.+ [y]), vec[1:shape])...)
        return pot

    else
        first = base_unit[1:3]
        second = base_unit[3:end]
        pot1 = vcat(map(y -> map(x -> LocalPotential(U1, x), first.+ [y]), vec[1:shape])...)
        pot2 = vcat(map(y -> map(x -> LocalPotential(U2, x), second .+ [y]), vec[1:shape])...)
        return vcat(pot1, pot2)
    end
end


# Use 1 - SV, 3 - trimer, 6 - hexamer, 10 - decamer
# POTENTIAL = make_shape(U_val1, U_val2, 1, small_triangle_base)

POTENTIAL = [Delta_3]

s = AtomsSystem(μ, T, POTENTIAL)
