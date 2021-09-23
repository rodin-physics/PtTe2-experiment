using Colors
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
ω = 0.27


# Coordinates of the UC's
XS = repeat(xs, 1, length(xs))
YS = permutedims(XS)


# Energies used in the spectral function
ω_min = -0.5;
ω_max = 1.5;
ωs = range(ω_min, ω_max, length = nPts)

# Plotting for different values of the potential
Delta_1 = LocalPotential(-0.5, Location(0, 0))
Delta_2 = LocalPotential(-1.0, Location(0, 1))
Delta_3 = LocalPotential(-1.5, Location(0, 0))

U_val1 = -0.35
U_val2 = -0.15


## Base units for vacancy clusters
small_triangle_base = [Location(0,0), Location(0,1), Location(1,0)]

some_2NNs_base = vcat(small_triangle_base,[Location(-1,0), Location(0,-1), Location(0,2), Location(-1,2), Location(2,0), Location(2,-1)])

all_2NNs_base = vcat(small_triangle_base, [Location(-1,0), Location(0,-1), Location(0,2), Location(-1,2), Location(2,0), Location(2,-1), Location(1,1), Location(-1,1), Location(1,-1)])

# Configurations for small grid
config1 = [Location(1,1), Location(1,0), Location(0,1), Location(2,0), Location(0,2), Location(1,2), Location(2,1), Location(2,2), Location(-1,2), Location(2,-1)]

config1_len = length(config1)

small_grid_ext = [Location(0,0), Location(0,-1), Location(-1,0), Location(-1,-1), Location(-1,1), Location(1,-1)]

config2 = vcat(config1, small_grid_ext, small_grid_ext .+ [Location(0,4)], small_grid_ext .+ [Location(4,0)])

config3 = [Location(1,1), Location(1,2), Location(2,1), Location(2,0), Location(0,2), Location(1,0), Location(0,1)]

config4 = vcat(config3, [Location(2,2), Location(3,1), Location(3,0), Location(3,-1), Location(2,-1), Location(1,-1), Location(1,3), Location(0,3), Location(-1,3), Location(-1,2), Location(-1,1), Location(0,0)])

config7 = [Location(1,1), Location(1,2), Location(2,1), Location(2,0), Location(0,2), Location(1,0), Location(0,1), Location(3,0), Location(0,3), Location(0,0)]

config8 = vcat(config7, [Location(1,-1), Location(-1,1), Location(-1,0), Location(0,-1), Location(0,4), Location(1,3), Location(-1,4), Location(-1,3), Location(4,0), Location(3,1), Location(4,-1), Location(3,-1)])

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

# Same function as above but for the finer grid
function make_shape2(U1::Float64, U2::Float64, shape::Int64, base_unit::Vector{Location})
    vec = [Location(0,0), Location(2,0), Location(0,2), Location(4,0), Location(0,4), Location(2,2), Location(6,0), Location(0,6), Location(4,2), Location(2,4)] .* [Location(3,3)]

    shift = (shape ÷ -5) * 3

    vec = vec .+ [Location(shift, shift)]

    if base_unit == config2
        first = base_unit[1:config1_len]
        second = base_unit[config1_len+1:end]

        pot1 = vcat(map(y -> map(x -> LocalPotential(U1, x), first.+ [y]), vec[1:shape])...)
        pot2 = vcat(map(y -> map(x -> LocalPotential(U2, x), second .+ [y]), vec[1:shape])...)

        return vcat(pot1, pot2)

    elseif base_unit == config4
        first = base_unit[1:7]
        second = base_unit[8:end]

        pot1 = vcat(map(y -> map(x -> LocalPotential(U1, x), first.+ [y]), vec[1:shape])...)
        pot2 = vcat(map(y -> map(x -> LocalPotential(U2, x), second .+ [y]), vec[1:shape])...)

        return vcat(pot1, pot2)

    elseif base_unit == config7
        first = [base_unit[1]]
        second = base_unit[2:end]

        pot1 = vcat(map(y -> map(x -> LocalPotential(U1, x), first.+ [y]), vec[1:shape])...)
        pot2 = vcat(map(y -> map(x -> LocalPotential(U2, x), second .+ [y]), vec[1:shape])...)

        return vcat(pot1, pot2)

    elseif base_unit == config8
        first = base_unit[1:10]
        second = base_unit[11:end]

        pot1 = vcat(map(y -> map(x -> LocalPotential(U1, x), first.+ [y]), vec[1:shape])...)
        pot2 = vcat(map(y -> map(x -> LocalPotential(U2, x), second .+ [y]), vec[1:shape])...)

        return vcat(pot1, pot2)

    else
        pot = vcat(map(y -> map(x -> LocalPotential(U1, x), base_unit.+ [y]), vec[1:shape])...)
        return pot

    end
end


# Use 1 - SV, 3 - trimer, 6 - hexamer, 10 - decamer
# POTENTIAL = make_shape(U_val1, U_val2, 3, small_triangle_base)
POTENTIAL = make_shape2(U_val1, U_val2, 10, config7)
# POTENTIAL = LocalPotential[]

s = AtomsSystem(μ, T, POTENTIAL)
