using CairoMakie
using DelimitedFiles
include("calc_settings.jl")

signal_vb = reshape(readdlm("signal_vb.dat"), length(US))
signal_cb = reshape(readdlm("signal_cb.dat"), length(US))
signal_total = (1.0 .* signal_vb) .+ (0.5 .* signal_cb)

## Definitions
us = vec(US)
vs = vec(VS)

X = refined_d1[1] .* us + refined_d2[1] .* vs
Y = refined_d1[2] .* us + refined_d2[2] .* vs

# Actual lattice
X_latt = d1[1] .* us + d2[1] .* vs
Y_latt = d1[2] .* us + d2[2] .* vs

newPOT = filter(x -> x.V == U_val1 || x.V == U_val3, POTENTIAL)
u_LP = map(y -> y.loc.v1, newPOT)
v_LP = map(y -> y.loc.v2, newPOT)

X_LP = refined_d1[1] .* u_LP + refined_d2[1] .* v_LP
Y_LP = refined_d1[2] .* u_LP + refined_d2[2] .* v_LP



## Plotting
fig = Figure(resolution = (1800, 1800))
ax =
    fig[1, 1] = Axis(
        fig,
        xlabel = "x/nm - $ω eV",
        ylabel = "y/nm",
        xlabelpadding = 0,
        ylabelpadding = 0,
        xlabelsize = 50,
        ylabelsize = 50,
        # title = "FO map at $ω eV",
        titlefont = "Calculation/LibreBaskerville-Regular.ttf",
        titlesize = 60,
        xticklabelsize = 18,
        yticklabelsize = 18,

        xticklabelfont = "Calculation/LibreBaskerville-Regular.ttf",
        yticklabelfont = "Calculation/LibreBaskerville-Regular.ttf",
        xlabelfont = "Calculation/LibreBaskerville-Italic.ttf",
        ylabelfont = "Calculation/LibreBaskerville-Italic.ttf",
    )

sc = CairoMakie.scatter!(
    ax,
    X .* a0 / 10,
    Y .* a0 / 10,
    color = signal_total,
    strokewidth = 0,
    # marker = '◼',
    marker = :hexagon,
    # markersize = 40.6,
    markersize = 40.6,
    colormap = cgrad(:custom_rainbow),
    colorrange = (0.28, 0.315)
)


sc = CairoMakie.scatter!(
    ax,
    X_LP .* a0 / 10,
    Y_LP .* a0 / 10,
    marker = :circle,
    markersize = 38,
    # markersize = 10,
    color = :transparent ,
    strokewidth = 6,
    strokecolor = :white
)

# sc = CairoMakie.scatter!(
#     ax,
#     X_latt .* a0 / 10,
#     Y_latt .* a0 / 10,
#     strokewidth = 1.8,
#     marker = :hexagon,
#     # strokecolor = RGBA(1.0,1.0,1.0,0.25),
#     strokecolor = RGBA(0.0,0.0,0.0,0.25),
#     color = :transparent,
#     markersize = 120,
#     strokestyle = :dot
#     )


tightlimits!(ax)
xlims!(ax, (-4.0, 4.0))
ylims!(ax, (-4.0, 4.0))
fig
