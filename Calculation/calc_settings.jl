using Colors, ColorSchemes
include("../src/helper_functions.jl")
# include("../src/custom_rainbow.jl")
# include("../src/custom_FT_scheme.jl")

## Parameters for the spectral function plot
μ = 0.30            # Chemical minpotential
T = 0.0             # Temperature
nPts = 750          # Number of points in the spectral function curve
band_edge_vb = 2.3     # Value of band edge reference in experiment
band_edge_cb = 2.75

n_UC = 30           # Number of real-space UC's along the sample dimension
grid_num = n_UC * scale_factor
grid = -grid_num : grid_num

US = repeat(grid, 1, length(grid))
VS = permutedims(US)

# slice energy
ω = 0.3

# Energies used in the spectral function
ω_min = -0.8
ω_max = 0.2
ωs = range(ω_min, ω_max, length=nPts)

# LocalPotential parameters
U_val1 = 0.22 * (1 - 2 * M_scatter)
U_val2 = 0.155 * (1 - 2 * M_scatter)

## System parameters

# make_shape takes in (U1, U2, cluster_size, Pt_centred)
# Cluster_size: use 1 - SV, 3 - trimer, 6 - hexamer, 10 - decamer
# Inverted: Optional arg, true for Pt-centred (default), false for Te-centred

POTENTIAL = make_shape(U_val1, U_val2, 1)
s = AtomsSystem(μ, T, POTENTIAL)
s_trimer = AtomsSystem(μ, T, make_shape(U_val1, U_val2, 3))
s_hexamer = AtomsSystem(μ, T, make_shape(U_val1, U_val2, 6))
s_decamer = AtomsSystem(μ, T, make_shape(U_val1, U_val2, 10))

## Fourier analysis
# Momenta in inverse Bohr radii
qx_max = 4 * π / lattice_constant * √(3) / 3;
qx_min = -qx_max;

n_pts = 400;
qx = range(qx_min, qx_max, length=n_pts)

QX = repeat(qx, 1, n_pts)
QY = QX |> permutedims
