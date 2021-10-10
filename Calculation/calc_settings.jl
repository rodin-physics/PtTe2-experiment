
using Colors, ColorSchemeTools
include("../src/density.jl")
include("../src/custom_rainbow.jl")

## Parameters for the spectral function plot
μ = 0.30            # Chemical potential
T = 0.0             # Temperature

nPts = 750;         # Number of points in the spectral function curve
x_pos = 50;  # Number of unit cells to be plotted in positive x  direction for neutral SV
# y_pos = 10;        #Number of unit cells to be plotted in positive y direction for both SVs

# Cut settings
xs = -x_pos:x_pos

#slice energy
ω = 0.3


# Coordinates of the UC's
XS = repeat(xs, 1, length(xs))
YS = permutedims(XS)


# Energies used in the spectral function
ω_min = -0.7;
ω_max = 0.3;
ωs = range(ω_min, ω_max, length = nPts)

# Plotting for different values of the potential
Delta_1 = LocalPotential(-0.5, Location(0, 0))
Delta_2 = LocalPotential(-1.0, Location(0, 1))
Delta_3 = LocalPotential(-1.5, Location(0, 0))

U_val1 = -0.22
U_val2 = -0.155
U3 = -0.17

# Defining colors
black = (0.0, 0.0, 0.0)
blue1 = (0.0196078, 0.0196078, 0.603922)
blue2  = (0, 0.141176, 0.752941)
blue3 = (0, 0.360784, 0.835294)
cyan = (0.00392157, 0.635294, 0.811765)
green1 = (0, 0.815686, 0.65098)
green2 = (0.00392157, 0.827451, 0.329412)
green3 = (0.266667, 0.839216, 0)
green_yellow = (0.615686, 0.866667, 0)
yellow1 = (0.905882, 0.886275, 0)
yellow2 = (0.960784, 0.635294, 0.00392157)
orange = (0.988235, 0.356863, 0 )
red = (0.913725, 0.054902, 0.0392157)

color_list = [black, blue1, blue2, blue3, cyan, green1, green2, green3, green_yellow, yellow1, yellow2, orange, red]
positions = [0, 0.0, 0.0894632, 0.17495, 0.264414, 0.355865, 0.449304, 0.544732, 0.636183, 0.727634, 0.819085, 0.916501, 1]
rainbow_scheme = make_colorscheme((
                 (0, black),
                 (0, blue1),
                 (0.0894632, blue2),
                 (0.17495, blue3),
                 (0.264414, cyan),
                 (0.355865, green1),
                 (0.449304, green2),
                 (0.544732, green3),
                 (0.636183, green_yellow),
                 (0.727634, yellow1),
                 (0.819085, yellow2),
                 (0.916501, orange),
                 (1, red)), length = 400)


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

config7_v2 = [Location(1,1), Location(2,1), Location(1,2), Location(2,0), Location(0,2), Location(1,0), Location(0,1), Location(3,0), Location(0,3), Location(0,0)]

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

    elseif base_unit == config7_v2
        first = [base_unit[1]]
        second = base_unit[2:7]
        third = base_unit[8:end]

        pot1 = vcat(map(y -> map(x -> LocalPotential(U1, x), first.+ [y]), vec[1:shape])...)
        pot2 = vcat(map(y -> map(x -> LocalPotential(U2, x), second .+ [y]), vec[1:shape])...)
        pot3 = vcat(map(y -> map(x -> LocalPotential(U3, x), third .+ [y]), vec[1:shape])...)

        return vcat(pot1, pot2, pot3)


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
POTENTIAL = make_shape2(U_val1, U_val2, 3, config7)

s = AtomsSystem(μ, T, POTENTIAL)
