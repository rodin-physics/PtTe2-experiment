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
n_UC = 50           # Number of real UC's along the sample dimension
grid_num = n_UC * scale_factor
grid = -grid_num : grid_num

US = repeat(grid, 1, length(grid))
VS = permutedims(US)

# slice energy
ω = 0.1

# Energies used in the spectral function
ω_min = -0.7
ω_max = 0.3
ωs = range(ω_min, ω_max, length=nPts)

# LocalPotential parameters
U_val1 = -0.22
U_val2 = -0.155

## System parameters

# make_shape takes in (U1, U2, cluster_size, Pt_centred)
# Cluster_size: use 1 - SV, 3 - trimer, 6 - hexamer, 10 - decamer
# Inverted: Optional arg, true for Pt-centred (default), false for Te-centred
POTENTIAL = make_shape(U_val1, U_val2, 1)

s = AtomsSystem(μ, T, POTENTIAL)
# s = AtomsSystem(μ, T, [LocalPotential(1.0 * scale_factor^2, Location(0, 0))])

## Fourier analysis
function FT_component(qx, qy, ρ, XS, YS)
    res = sum(map((x, y, z) -> exp(1im * (x * qx + y * qy)) * z, XS, YS, ρ))
end

# Momenta in inverse Bohr radii
qx_max = 4 * π / lattice_constant * √(3) / 3;
qx_min = -qx_max;

n_pts = 800;
qx = range(qx_min, qx_max, length=n_pts)

QX = repeat(qx, 1, n_pts)
QY = QX |> permutedims
