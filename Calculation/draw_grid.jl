using CairoMakie
using Distributed
proc_number = 4;
if nprocs() < proc_number
    addprocs(proc_number - nprocs())
end

@everywhere include("calc_settings.jl")

## Testing parameters
us = vec(US)
vs = vec(VS)

#x and y axis of the spectral map
X = refined_d1[1] .* us + refined_d2[1] .* vs
Y = refined_d1[2] .* us + refined_d2[2] .* vs

# Actual lattice
X_latt = d1[1] .* us + d2[1] .* vs
Y_latt = d1[2] .* us + d2[2] .* vs

# Local Potential locations
u_LP = map(y -> y.loc.v1, POTENTIAL)
v_LP = map(y -> y.loc.v2, POTENTIAL)

X_LP = refined_d1[1] .* u_LP + refined_d2[1] .* v_LP
Y_LP = refined_d1[2] .* u_LP + refined_d2[2] .* v_LP

# Center of Potential Wells
newPOT = filter(x -> x.V == U_val1, POTENTIAL)
u_LP_center = map(y -> y.loc.v1, newPOT)
v_LP_center = map(y -> y.loc.v2, newPOT)

X_LP_center = refined_d1[1] .* u_LP_center + refined_d2[1] .* v_LP_center
Y_LP_center = refined_d1[2] .* u_LP_center + refined_d2[2] .* v_LP_center

# Passivated Corners
pass_cor = filter(x -> x.V == -0.14 || x.V == -0.12, POTENTIAL)
u_LP_pass_cor = map(y -> y.loc.v1, pass_cor)
v_LP_pass_cor = map(y -> y.loc.v2, pass_cor)

X_LP_pass_cor = refined_d1[1] .* u_LP_pass_cor + refined_d2[1] .* v_LP_pass_cor
Y_LP_pass_cor = refined_d1[2] .* u_LP_pass_cor + refined_d2[2] .* v_LP_pass_cor


# Positions of Calculated Spectrum
# u_calc = map(y -> y.v1, vcat(Decamer.Center, neighbors(Decamer.Center)))
# v_calc = map(y -> y.v2, vcat(Decamer.Center, neighbors(Decamer.Center)))
#
# X_calc = refined_d1[1] .* u_calc + refined_d2[1] .* v_calc
# Y_calc = refined_d1[2] .* u_calc + refined_d2[2] .* v_calc

## Plotting

fig = Figure(resolution = (1800, 1800), backgroundcolor = :white)
ax =
    fig[1, 1] = Axis(
        fig,
        xlabel = "x/nm",
        ylabel = "y/nm",
        xlabelpadding = 0,
        ylabelpadding = 0,
        xlabelsize = 20,
        ylabelsize = 20,
        title = "Grid Comparison",
        titlefont = "Calculation/LibreBaskerville-Regular.ttf",
        titlesize = 30,
        xticklabelsize = 18,
        yticklabelsize = 18,
        aspect = DataAspect(),
        xticklabelfont = "Calculation/LibreBaskerville-Regular.ttf",
        yticklabelfont = "Calculation/LibreBaskerville-Regular.ttf",
        xlabelfont = "Calculation/LibreBaskerville-Italic.ttf",
        ylabelfont = "Calculation/LibreBaskerville-Italic.ttf",
        backgroundcolor = :transparent
    )

sc = CairoMakie.scatter!(
    ax,
    X_latt .* a0 / 10,
    Y_latt .* a0 / 10,
    strokewidth = 3.5,
    marker = :hexagon,
    strokecolor = :black,
    color = :transparent,
    markersize = 115,
    )

sc = CairoMakie.scatter!(
    ax,
    X .* a0 / 10,
    Y .* a0 / 10,
    strokewidth = 2.3,
    marker = :hexagon,
    strokecolor = :grey,
    color = :transparent,
    markersize = 40,
    )

sc = CairoMakie.scatter!(
    ax,
    X_LP .* a0 / 10,
    Y_LP .* a0 / 10,
    marker = :hexagon,
    markersize = 40,
    # markersize = 10,
    color = RGBA(0.0,0.4,0.8,0.6) ,
    strokewidth = 0.0,
    )

sc = CairoMakie.scatter!(
    ax,
    X_LP_center .* a0 / 10,
    Y_LP_center .* a0 / 10,
    marker = :circle,
    markersize = 35,
    # markersize = 10,
    color = :black ,
    strokewidth = 0.0,
    )


sc = CairoMakie.scatter!(
    ax,
    X_LP_pass_cor .* a0 / 10,
    Y_LP_pass_cor .* a0 / 10,
    marker = :hexagon,
    markersize = 40,
    # markersize = 10,
    color = RGBA(1.0,0.0,0.0,0.4) ,
    strokewidth = 0.0,
    )

# sc = CairoMakie.scatter!(
#     ax,
#     X_calc .* a0 / 10,
#     Y_calc .* a0 / 10,
#     marker = :hexagon,
#     markersize = 40,
#     # markersize = 10,
#     color = RGBA(1.0,0.0,0.0,0.8) ,
#     strokewidth = 0.0,
#     )
#

tightlimits!(ax)
xlims!(ax, (-4.0, 4.0))
ylims!(ax, (-4.0, 4.0))
fig
