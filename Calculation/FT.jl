@everywhere include("calc_settings.jl")


## Definitions and Calculation
# Convert X and Y to Bohr radii. Reshape the arrays
us = vec(US)
vs = vec(VS)
# x and y axis of the spectral map in Bohr radii
X = refined_d1[1] .* us + refined_d2[1] .* vs
Y = refined_d1[2] .* us + refined_d2[2] .* vs

signal = @showprogress pmap((u, v) -> spectral_bulk(ω, Location(u, v), s), us, vs)

fig = Figure(resolution=(1800, 1800))
ax =
    fig[1, 1] = Axis(
        fig,
        xlabel="x/nm",
        ylabel="y/nm",
        xlabelpadding=0,
        ylabelpadding=0,
        xlabelsize=50,
        ylabelsize=50,
        # title = "FO map at $ω eV",
        titlefont="Calculation/LibreBaskerville-Regular.ttf",
        titlesize=60,
        xticklabelsize=18,
        yticklabelsize=18,
        
        xticklabelfont="Calculation/LibreBaskerville-Regular.ttf",
        yticklabelfont="Calculation/LibreBaskerville-Regular.ttf",
        xlabelfont="Calculation/LibreBaskerville-Italic.ttf",
        ylabelfont="Calculation/LibreBaskerville-Italic.ttf",
    )

sc = CairoMakie.scatter!(
    ax,
    X,
    Y,
    color=signal,
    strokewidth=0,
    marker=:hexagon,
    markersize=8,
    # markersize=40.6,
    colormap=cgrad(:custom_rainbow_scheme),
    colorrange = (0.3, 1.2)
)

lim = maximum(X)
tightlimits!(ax)
xlims!(ax, (-lim, lim))
ylims!(ax, (-lim, lim))
fig


## Calculation
signal = signal .- signal[1]
FT_res = @showprogress pmap((qx, qy) -> FT_component(qx, qy, signal, X, Y), QX, QY)

writedlm("QX.dat", QX)
writedlm("QY.dat", QY)
writedlm("FT_real.dat", real.(FT_res))
writedlm("FT_imag.dat", imag.(FT_res))

r_d1 = 2 * π / lattice_constant .* [1, √(3) / 3]
r_d2 = 2 * π / lattice_constant .* [-1, √(3) / 3]

X_reci = r_d1[1] .* us + r_d2[1] .* vs
Y_reci = r_d1[2] .* us + r_d2[2] .* vs

fig2 = CairoMakie.Figure(resolution=(1800, 1800))
ax2 =
        fig2[1, 1] = Axis(
                fig2,
                xlabel="kx",
                ylabel="ky",
                xlabelpadding=0,
                ylabelpadding=0,
                xlabelsize=40,
                ylabelsize=40,
                xticklabelsize=40,
                yticklabelsize=40,
                title="FT at $ω eV",
                titlefont="Calculation/LibreBaskerville-Regular.ttf",
                titlesize=40,
                aspect=AxisAspect(1),
                xticklabelfont="Calculation/LibreBaskerville-Regular.ttf",
                yticklabelfont="Calculation/LibreBaskerville-Regular.ttf",
                xlabelfont="Calculation/LibreBaskerville-Italic.ttf",
                ylabelfont="Calculation/LibreBaskerville-Italic.ttf",
        )

hm2 = heatmap!(QX[:,1], QY[1,:], abs.(FT_res),
                colormap=cgrad(:FT_scheme),
                # colorrange=(0, 13)
                )

scatter!(
    ax2,
    X_reci,
    Y_reci,
    strokewidth=1.8,
    marker=:circle,
    # strokecolor = RGBA(1.0,1.0,1.0,0.25),
    strokecolor=RGBA(0.0, 0.0, 0.0, 0.25),
    color=:white,
    markersize=40,
    strokestyle=:dot
    )

tightlimits!(ax2)
xlims!(ax2, (qx_min, qx_max))
ylims!(ax2, (qx_min, qx_max))
fig2


