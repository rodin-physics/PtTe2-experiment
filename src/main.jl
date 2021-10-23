using DelimitedFiles
using Distributed
using LinearAlgebra
using ProgressMeter
using QuadGK
using SpecialFunctions
using Statistics

## Parameters
const ħ = 1
const ryd = 13.606              # Rydberg constant in eV
const a0 = 0.529                # Bohr radius in angstroms

const lattice_constant = 7.597       # In Bohr radii
const d1 = [lattice_constant / 2, lattice_constant * √(3) / 2]
const d2 = [-lattice_constant / 2, lattice_constant * √(3) / 2]

const scale_factor = 3

const refined_d1 = d1 ./ scale_factor
const refined_d2 = d2 ./ scale_factor

# Effective mass in the armchair(x) and zigzag(y) direction in m_e
const mx = 0.1
const my = 1.4

# Area of the unit cell in Bohr radii squared
const UC_area = d1[1] * d2[2] - d1[2] * d2[1];

# Upper limit of propagator integral
const C = 4 * π / UC_area / sqrt(mx * my) * ryd / 3;

const Rot_Mat = [cos(π / 3) sin(π / 3); -sin(π / 3) cos(π / 3)]
const M = [0, π / lattice_constant]

## Integration
const ν = 1e-4;         # Relative tolerance for integration
const η = 1e-2;         # Small number for imaginary parts

const NumEvals = 1e5;   # Max number of integrals in quadgk

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

function Base.:*(l1::Location, l2::Location)
    return Location(l1.v1 * l2.v1, l1.v2 * l2.v2)
end

## Propagator, r in Bohr radii
function P(r, z::ComplexF64)
    md = √(mx * r[1]^2 + my * r[2]^2)
    if md == 0.0
        return (-1 / C) * (log(Complex(1 - (C / z))))
    else
        return (-2 / C) * besselk(0, (md * √(-z / ryd)))
    end
end

function Ξ(r::Location, z::ComplexF64)
    position = r.v1 * refined_d1 + r.v2 * refined_d2
    res =
        P(position, z) * cos(dot(position, M)) +
        P(Rot_Mat' * position, z) * cos(dot(position, Rot_Mat * M)) +
        P(Rot_Mat * position, z) * cos(dot(position, Rot_Mat' * M))
    return res
end

function propagator_matrix(z, Coords::Vector{Location})
    len_coords = length(Coords)
    out = zeros(ComplexF64, len_coords, len_coords)
    for ii = 1:len_coords
        @inbounds for jj = ii:len_coords
            out[ii, jj] = Ξ(Coords[ii] - Coords[jj], z)
            out[jj, ii] = out[ii, jj]
        end
    end
    return out
end
