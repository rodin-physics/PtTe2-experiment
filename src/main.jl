using DelimitedFiles
using Distributed
using LinearAlgebra
using ProgressMeter
using QuadGK
using SpecialFunctions
using Statistics

## Parameters
const M_scatter = true      # True for M-point scattering, false for Γ and K- scattering
const ħ = 1
const ryd = 13.606          # Rydberg constant in eV
const a0 = 0.529            # Bohr radius in angstroms

const lattice_constant = 7.597                  # In Bohr radii
const d1 = lattice_constant .* [1/2, √(3)/2]    # Lattice vectors of PtTe2
const d2 = lattice_constant .* [-1/2, √(3)/2]

const scale_factor = 3                 # Scaling factor for refined lattice
const refined_d1 = d1 ./ scale_factor   # Scaled lattice vectors
const refined_d2 = d2 ./ scale_factor

const r_d1 = 2*π / lattice_constant .* [1, √(3)/3]  # Reciprocal lattice vectors
const r_d2 = 2*π / lattice_constant .* [-1, √(3) / 3]

# Area of the unit cell in Bohr radii squared
const UC_area = d1[1] * d2[2] - d1[2] * d2[1];

struct ScatterType
    mx::Float64         # Effective mass in x direction (m_e)
    my::Float64         # Effective mass in y direction (m_e)
    C::Float64          # Upper limit of propagator integral (m_e)
end

M = ScatterType(0.1, 1.4, 4 * π / UC_area * ryd / 3)
Γ = ScatterType(0.13, 0.12, 2 * π / UC_area * ryd)
K = ScatterType(0.64, 0.52, 3 * π / UC_area * ryd)


const Rot_Mat = [cos(π / 3) sin(π / 3); -sin(π / 3) cos(π / 3)]
const M_coord = [0, π / lattice_constant]
const K_coord = [(2*π)/(√(3) * lattice_constant), 0]

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
function P(r, z::ComplexF64, point::ScatterType)
    md = √(point.mx * r[1]^2 + point.my * r[2]^2)
    C_val = point.C / sqrt(point.mx * point.my)
    if md == 0.0
        return (-1 / C_val) * (log(Complex(1 - (C_val / z))))
    else
        return (-2 / C_val) * besselk(0, (md * √(-z / ryd)))
    end
end

function Ξ(r::Location, z::ComplexF64)
    position = r.v1 * refined_d1 + r.v2 * refined_d2

    if M_scatter
        res = P(position, z, M) * cos(dot(position, M_coord)) +
        P(Rot_Mat' * position, z, M) * cos(dot(position, Rot_Mat * M_coord)) +
        P(Rot_Mat * position, z, M) * cos(dot(position, Rot_Mat' * M_coord))
    else
        res = P(position, (z - 0.19), Γ) + (2/3 * P(position, z, K)) * (cos(dot(position, K_coord)) + cos(dot(position, Rot_Mat * K_coord)) + cos(dot(position, Rot_Mat' * K_coord)))
    end

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
