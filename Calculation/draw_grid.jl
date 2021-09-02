using CairoMakie
using Distributed
using Colors
proc_number = 4;
if nprocs() < proc_number
    addprocs(proc_number - nprocs())
end

@everywhere include("/Users/harshitramahalingam/Documents/CA2DM/PtTe2-experiment/Calculation/calc_settings.jl")

## Testing parameters
small_lattice = 7.604/3         # In Bohr radii
small_d1 = [small_lattice / 2, small_lattice * √(3) / 2]
small_d2 = [-small_lattice / 2, small_lattice * √(3) / 2]

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

# Positions of local potentials for usual lattice
x_positions2 = map(y -> y.loc.v1, POTENTIAL)
y_positions2 = map(y -> y.loc.v2, POTENTIAL)

X_LP = d1[1] .* x_positions2 + d2[1] .* y_positions2
Y_LP = d1[2] .* x_positions2 + d2[2] .* y_positions2


## Plotting

fig = Figure(resolution = (1800, 1800))
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
        titlefont = "LibreBaskerville-Regular.ttf",
        titlesize = 30,
        xticklabelsize = 18,
        yticklabelsize = 18,
        aspect = DataAspect(),
        xticklabelfont = "LibreBaskerville-Regular.ttf",
        yticklabelfont = "LibreBaskerville-Regular.ttf",
        xlabelfont = "LibreBaskerville-Italic.ttf",
        ylabelfont = "LibreBaskerville-Italic.ttf",
    )

sc = CairoMakie.scatter!(
    ax,
    X .* a0 / 10,
    Y .* a0 / 10,
    strokewidth = 3.5,
    marker = :hexagon,
    strokecolor = :black,
    color = :transparent,
    markersize = 92,
    )

sc = CairoMakie.scatter!(
    ax,
    X2 .* a0 / 10,
    Y2 .* a0 / 10,
    strokewidth = 2.3,
    marker = :hexagon,
    strokecolor = :grey,
    color = :transparent,
    markersize = 30,
    )

sc = CairoMakie.scatter!(
    ax,
    X_LP .* a0 / 10,
    Y_LP .* a0 / 10,
    marker = :hexagon,
    markersize = 90,
    # markersize = 10,
    color = RGBA(0.0,0.0,0.0,0.3) ,
    strokewidth = 0.0,
    markeralpha = 0.3
    )

tightlimits!(ax)
xlims!(ax, (-5.0, 5.0))
ylims!(ax, (-5.0, 5.0))
fig
