using CairoMakie
using Distributed
proc_number = 4;
if nprocs() < proc_number
    addprocs(proc_number - nprocs())
end

@everywhere include("/Users/harshitramahalingam/Documents/CA2DM/PtTe2-experiment/Calculation/calc_settings.jl")

## Testing parameters
x_pos = 80
xs = -x_pos:x_pos

# Coordinates of the UC's
XS = repeat(xs, 1, length(xs))
YS = permutedims(XS)

# Convert X and Y to Bohr radii. Reshape the arrays
xs = reduce(vcat, XS)
ys = reduce(vcat, YS)
# x and y axis of the spectral map
X = d1[1] .* xs + d2[1] .* ys
Y = d1[2] .* xs + d2[2] .* ys

# Coordinates of small lattice
X2 = small_d1[1] .* xs + small_d2[1] .* ys
Y2 = small_d1[2] .* xs + small_d2[2] .* ys

# Positions of local potentials for small lattice
# x_positions2 = map(y -> y.loc.v1, POTENTIAL)
# y_positions2 = map(y -> y.loc.v2, POTENTIAL)
#
# X_LP = d1[1] .* x_positions2 + d2[1] .* y_positions2
# Y_LP = d1[2] .* x_positions2 + d2[2] .* y_positions2

## Testing out potential positions on small grid
# tester = make_shape2(U_val1, U_val2, 3, config3)
# tester = make_shape2(U_val1, U_val2, 10, config7)
LP_xpos2 = map(y -> y.loc.v1, POTENTIAL)
LP_ypos2 = map(y -> y.loc.v2, POTENTIAL)

X_LP2 = small_d1[1] .* LP_xpos2 + small_d2[1] .* LP_ypos2
Y_LP2 = small_d1[2] .* LP_xpos2 + small_d2[2] .* LP_ypos2


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
    X .* a0 / 10,
    Y .* a0 / 10,
    strokewidth = 3.5,
    marker = :hexagon,
    strokecolor = :black,
    color = :transparent,
    markersize = 116,
    )

sc = CairoMakie.scatter!(
    ax,
    X2 .* a0 / 10,
    Y2 .* a0 / 10,
    strokewidth = 2.3,
    marker = :hexagon,
    strokecolor = :grey,
    color = :transparent,
    markersize = 38,
    )

# sc = CairoMakie.scatter!(
#     ax,
#     X_LP .* a0 / 10,
#     Y_LP .* a0 / 10,
#     marker = :hexagon,
#     markersize = 90,
#     # markersize = 10,
#     color = RGBA(0.0,0.0,0.0,0.3) ,
#     strokewidth = 0.0,
#     markeralpha = 0.3
#     )

sc = CairoMakie.scatter!(
    ax,
    X_LP2 .* a0 / 10,
    Y_LP2 .* a0 / 10,
    marker = :hexagon,
    markersize = 38,
    # markersize = 10,
    color = RGBA(0.0,0.4,0.8,0.6) ,
    strokewidth = 0.0,
    )


tightlimits!(ax)
xlims!(ax, (-4.0, 4.0))
ylims!(ax, (-4.0, 4.0))
fig
