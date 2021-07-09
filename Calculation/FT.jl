include("calc_settings.jl")
include("../src/density.jl")
xs = reduce(vcat, XS)
ys = reduce(vcat, YS)
X = d1[1] .* xs + d2[1] .* ys
Y = d1[2] .* xs + d2[2] .* ys
res = @showprogress pmap((x, y) -> spectral_bulk(ω, Location(x, y), s), XS, YS)
signal = reduce(vcat, res)
XS = reshape(X, 1, (2*x_pos+1)^2)
YS = reshape(Y, 1, (2*x_pos+1)^2)
signal1 = reshape(signal, 1, (2*x_pos+1)^2)
signal1 = signal1 .- signal1[1]
function FT_component(qx, qy, ρ, XS, YS)
    res = sum(map((x, y, z) -> exp(1im * (x * qx + y * qy)) * z, XS, YS, ρ))
end
qx_min = -1 * π;
qx_max = 1 * π;

n_pts = 200;

qx = range(qx_min, qx_max, length = n_pts)
qy = range(qx_min, qx_max, length = n_pts)

QX = repeat(qx, 1, n_pts)
QY = repeat(qy, 1, n_pts) |> permutedims

## Calculation
FT_res = @showprogress map((qx, qy) -> FT_component(qx, qy, signal1, XS, YS), QX, QY)

writedlm("QX.dat", QX)
writedlm("QY.dat", QY)
writedlm("FT_real.dat", real.(FT_res))
writedlm("FT_imag.dat", imag.(FT_res))
