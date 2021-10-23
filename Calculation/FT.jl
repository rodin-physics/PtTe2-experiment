include("calc_settings.jl")

## Grid definitions
xs = reduce(vcat, XS)
ys = reduce(vcat, YS)

X = small_d1[1] .* xs + small_d2[1] .* ys
Y = small_d1[2] .* xs + small_d2[2] .* ys



## Real-space computation
res = @showprogress pmap((x, y) -> spectral_bulk(ω, Location(x, y), s), XS, YS)
signal = reduce(vcat, res)


XS = reshape(X, 1, (2*x_pos+1)^2)
YS = reshape(Y, 1, (2*x_pos+1)^2)
signal1 = reshape(signal, 1, (2*x_pos+1)^2)
signal1 = signal1 .- signal1[1]

## Fourier components
function FT_component(qx, qy, ρ, XS, YS)
    res = sum(map((x, y, z) -> exp(1im * (x * qx + y * qy)) * z, XS, YS, ρ))
end

reciprocal_const = 2*π / lattice_constant

r_d1 = [reciprocal_const, reciprocal_const * √(3) / 3]
r_d2 = [-reciprocal_const, reciprocal_const * √(3) / 3]

X_reci = r_d1[1] .* xs + r_d2[1] .* ys
Y_reci = r_d1[2] .* xs + r_d2[2] .* ys

qx_min = -2 * π / lattice_constant;
qx_max = 2 * π / lattice_constant;

n_pts = 800;

qx = range(4*qx_min, 4*qx_max, length = n_pts)
qy = range(4*qx_min, 4*qx_max, length = n_pts)

QX = repeat(qx, 1, n_pts)
QY = repeat(qy, 1, n_pts) |> permutedims

## Calculation
FT_res = @showprogress map((qx, qy) -> FT_component(qx, qy, signal1, XS, YS), QX, QY)

writedlm("QX.dat", QX)
writedlm("QY.dat", QY)
writedlm("FT_real.dat", real.(FT_res))
writedlm("FT_imag.dat", imag.(FT_res))
