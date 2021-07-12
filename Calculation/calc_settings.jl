include("../src/density.jl")

## Parameters for the spectral function plot
μ = 0.30            # Chemical potential
T = 0.0             # Temperature

nPts = 600;         # Number of points in the spectral function curve
x_pos = 100;  # Number of unit cells to be plotted in positive x  direction for neutral SV
# y_pos = 10;        #Number of unit cells to be plotted in positive y direction for both SVs

# Cut settings
xs = -x_pos:x_pos

#slice energy
ω = 0.05

# Coordinates of the UC's
XS = repeat(xs, 1, length(xs))
YS = permutedims(XS)


# Energies used in the spectral function
ω_min = -1;
ω_max = 10;
ωs = range(ω_min, ω_max, length = nPts)

# Plotting for different values of the potential
Delta_1 = LocalPotential(-1, Location(-0, 0))
Delta_2 = LocalPotential(-1.5, Location(0, 0))
Delta_3 = LocalPotential(-2.6, Location(0, 1))
#List of local potentials to simulate the charged and neutral SVs
U_val1 = -1.5
U_val2 = -0.4

# POTENTIAL = [Delta_2, Delta_3]

# POTENTIAL = [LocalPotential(U_val1, Location(0,-1)), LocalPotential(U_val1, Location(0,1)), LocalPotential(U_val1, Location(2,-1)),LocalPotential(0.2, Location(0,0)), LocalPotential(0.2, Location(1,-1)),LocalPotential(0.2, Location(1,0))]

# POTENTIAL = [LocalPotential(-0.5, Location(1,1)), LocalPotential(-0.5, Location(1,-2)), LocalPotential(-0.5, Location(-2,1)), LocalPotential(-1.5, Location(0,0))]

# POTENTIAL = [LocalPotential(U_val, Location(-1,0)), LocalPotential(U_val, Location(0,-1)), LocalPotential(U_val, Location(-1,-1)),LocalPotential(U_val, Location(0,1)), LocalPotential(U_val, Location(-1,2)), LocalPotential(U_val, Location(-1,1)),LocalPotential(U_val, Location(1,0)), LocalPotential(U_val, Location(2,-1)), LocalPotential(U_val, Location(1,-1))]

POTENTIAL = [LocalPotential(-1.5, Location(0,0)), LocalPotential(-1.5,   Location(0,-1)), LocalPotential(-1.5, Location(-1,0)),
LocalPotential(-0.5, Location(-2,0)), LocalPotential(-0.5, Location(0,-2)), LocalPotential(-0.5, Location(-1,1)),LocalPotential(-0.5, Location(1,0)),LocalPotential(-0.5, Location(0,1)),LocalPotential(-0.5, Location(1,-1)),LocalPotential(-0.5, Location(-2,1)), LocalPotential(-0.5, Location(1,0)),LocalPotential(-0.5, Location(0,1)), LocalPotential(-0.5, Location(-1,-1)), LocalPotential(-0.5, Location(1,-2))]


# POTENTIAL = [LocalPotential(U_val, Location(-2,0)), LocalPotential(U_val, Location(0,0)), LocalPotential(U_val, Location(2,0)), LocalPotential(U_val, Location(-2,2)), LocalPotential(U_val, Location(0,2)), LocalPotential(U_val, Location(-2,4))]

# POTENTIAL = [LocalPotential(U_val, Location(-2,-1)), LocalPotential(U_val, Location(0,-1)), LocalPotential(U_val, Location(2,-1)), LocalPotential(U_val, Location(-2,1)), LocalPotential(U_val, Location(0,1)), LocalPotential(U_val, Location(-2,3))]

# POTENTIAL = [LocalPotential(U_val, Location(-2,-1)), LocalPotential(U_val, Location(0,-1)), LocalPotential(U_val, Location(2,-1)), LocalPotential(U_val, Location(-2,1)), LocalPotential(U_val, Location(0,1)), LocalPotential(U_val, Location(-2,3)), LocalPotential(U_val, Location(-2,5)), LocalPotential(U_val, Location(0,3)), LocalPotential(U_val, Location(2,1)), LocalPotential(U_val, Location(4,-1))]

s = AtomsSystem(μ, T, POTENTIAL)
