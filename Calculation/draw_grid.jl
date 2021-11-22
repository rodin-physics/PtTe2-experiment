using CairoMakie
using Distributed
proc_number = 4;
if nprocs() < proc_number
    addprocs(proc_number - nprocs())
end

@everywhere include("Calculation/calc_settings.jl")

## Testing parameters
us = vec(US)
vs = vec(VS)

#x and y axis of the spectral map
X = refined_d1[1] .* us + refined_d2[1] .* vs
Y = refined_d1[2] .* us + refined_d2[2] .* vs

# Actual lattice
X_latt = d1[1] .* us + d2[1] .* vs
Y_latt = d1[2] .* us + d2[2] .* vs

u_LP = map(y -> y.loc.v1, POTENTIAL)
v_LP = map(y -> y.loc.v2, POTENTIAL)

X_LP = refined_d1[1] .* u_LP + refined_d2[1] .* v_LP
Y_LP = refined_d1[2] .* u_LP + refined_d2[2] .* v_LP

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
    markersize = 230,
    )

sc = CairoMakie.scatter!(
    ax,
    X .* a0 / 10,
    Y .* a0 / 10,
    strokewidth = 2.3,
    marker = :hexagon,
    strokecolor = :grey,
    color = :transparent,
    markersize = 76,
    )

sc = CairoMakie.scatter!(
    ax,
    X_LP .* a0 / 10,
    Y_LP .* a0 / 10,
    marker = :hexagon,
    markersize = 76,
    # markersize = 10,
    color = RGBA(0.0,0.4,0.8,0.6) ,
    strokewidth = 0.0,
    )


tightlimits!(ax)
xlims!(ax, (-2.0, 2.0))
ylims!(ax, (-2.0, 2.0))
fig
