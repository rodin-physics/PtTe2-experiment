using Colors, ColorSchemes
include("../src/helper_functions.jl")
include("../src/custom_rainbow.jl")
include("../src/custom_FT_scheme.jl")

## Parameters for the spectral function plot
μ = 0.30            # Chemical potential
T = 0.0             # Temperature
nPts = 750          # Number of points in the spectral function curve
band_edge = 2.3     # Value of band edge reference in experiment

# Cut settings
x_pos = 50
xs = -x_pos:x_pos

#slice energy
ω = -0.1

# Coordinates of the UC's
XS = repeat(xs, 1, length(xs))
YS = permutedims(XS)

# Energies used in the spectral function
ω_min = -0.7
ω_max = 0.3
ωs = range(ω_min, ω_max, length = nPts)

# LocalPotential parameters
U_val1 = -0.22
U_val2 = -0.155

## System parameters

# make_shape takes in (U1, U2, cluster_size, Pt_centred)
# Cluster_size: use 1 - SV, 3 - trimer, 6 - hexamer, 10 - decamer
# Inverted: Optional arg, true for Pt-centred (default), false for Te-centred
POTENTIAL = make_shape(U_val1, U_val2, 1)

s = AtomsSystem(μ, T, POTENTIAL)
