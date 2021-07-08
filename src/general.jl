using DelimitedFiles
using Distributed
using LinearAlgebra
using ProgressMeter
using QuadGK
using SpecialFunctions

## Parameters
const ħ = 1;
const ryd = 13.606;     # Rydberg constant in eV
const a0 = 0.529;       # Bohr radius in angstroms

# Effective mass in the armchair(x) and zigzag(y) direction in m_e
const mx = 0.15;
const my = 1.18;

# Lattice constants in Å
a1 = 4.42 #in Å along armchair (x) direction
a2 = 3.28 #in Å along zigzag (y) direction

L = π * sqrt(27.2/0.3/0.6)*a0

# Lattice constants in Bohr radii
c1 = a1 / a0
c2 = a2 / a0

const d1 = [c1, 0]       # Basis vector 1 in Bohr radii
const d2 = [0, c2]       # Basis vector 2 in Bohr radii

# Area of the unit cell in Bohr radii squared
const UC_area = d1[1] * d2[2] - d1[2] * d2[1];

# Upper limit of propagator integral
const C = 4 * π / UC_area / sqrt(mx * my) / 3 * ryd;

## Integration
const ν = 1e-4;         # Relative tolerance for integration
const η = 1e-6;         # Small number for imaginary parts

const NumEvals = 1e5;   # Max number of integrals in quadgk

R_60 = [cos(π/3) sin(π/3) ; -sin(π/3) cos(π/3)] #Rotation matrix by π/3 in clockwise direction
I2 = Matrix{Float64}(I,2,2) # 2×2 identity matrix

#M points in the BZ
M1 = [0,1]
M2 = [cos(π/3) , sin(π/3)]
M3 = [-cos(π/3) , sin(π/3)]
## Location struct to label bulk unit cells.
struct Location
    v1::Int64   # Coefficient of d1
    v2::Int64   # Coefficient of d2
end

# Introduce addition and subtraction for the Location struct
# so we can use arithmetic operations on Locations

function Base.:+(l1::Location, l2::Location)
    return Location(l1.v1 + l2.v1, l1.v2 + l2.v2)
end

function Base.:-(l1::Location, l2::Location)
    return Location(l1.v1 - l2.v1, l1.v2 - l2.v2)
end

##Propagator
function Ξ(r::Location, z::ComplexF64)
    position = r.v1 * d1 + r.v2 * d2
    md = √(mx * position[1]^2 + my * position[2]^2)
    if md == 0.0
        return (-1 / C) * (log(Complex(1 - (C / z))))
    else
        return (-2 / C) * besselk(0, (md * √(-z / ryd)))
    end
end

## Propagator P(z, Rr̂) where R ∈ {Matrix(I,2,2), R_60 and R_60'}
function P(R, r::Location, z::ComplexF64)
    """
    R is a matrix
    returns propagator evaluated at coordinate r, the location of UC.
    """
    r_ = r.v1 * d1 + r.v2 * d2 #position in Å
    position = R*r_
    md = √(mx * position[1]^2 + my * position[2]^2)
    if md == 0
        return (-1 / C) * (log(Complex(1 - (C / z))))
    else
        return (-2 / C) * besselk(0, (md * √(-z / ryd)))
    end
end


function propagator_matrix(z, Coords::Vector{Location})
    len_coords = length(Coords)
    out = zeros(ComplexF64, len_coords, len_coords)
    for ii = 1:len_coords
        @inbounds for jj = ii:len_coords
            r = Coords[ii] - Coords[jj]
            rÅ = r.v1 * d1 + r.v2 * d2 # r in Å
            out[ii, jj] = P(I2, r, z) * cos(dot(rÅ, M1)) + P(R_60, r, z) * cos(dot(rÅ , M2)) + P(R_60', r, z) * cos(dot(rÅ , M3))
            out[jj, ii] = out[ii, jj]
        end
    end
    return out
end
