include("defects.jl")

function Matrix_D(position::Location, z, potential::Vector{LocalPotential})
    D = inv(
        (diag_V(potential) |> inv) -
        propagator_matrix(z, map(x -> x.loc, potential)),
    )
end


function δρ_calc(position::Location, z, potential::Vector{LocalPotential})
    D = Matrix_D(position, z, potential)
    PropVectorR = map(x -> Ξ(x.loc - position, z), potential)
    output = transpose(PropVectorR) * D * PropVectorR
    return output
end


function δρR(R::Location, s::AtomsSystem)
    μ = s.μ
    potential = s.potential
    f_int(x) = (1 / 2 * π) * δρ_calc(R, μ + 1im * x, potential)
    res = quadgk(f_int, 0, Inf, maxevals = NumEvals, rtol = ν)
    return 2 * real(res[1][1])
end

function spectral_bulk(ω, R::Location, s::AtomsSystem)
    μ = s.μ
    potential = s.potential
    pristine_spectral = -Ξ(Location(0, 0), ω + 1im * η) / π |> imag
    correction_spectral = -δρ_calc(R, ω + 1im * η, potential) / π |> imag
    return (pristine_spectral + correction_spectral)
end

function spectral_bulk_average(ω, Rs::Vector{Location}, s::AtomsSystem)
    res = map(x -> spectral_bulk(ω, x, s), Rs)
    return mean(res)
end
