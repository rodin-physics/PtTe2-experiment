using CairoMakie
using Distributed
proc_number = 4;
if nprocs() < proc_number
    addprocs(proc_number - nprocs())
end

@everywhere include("/Users/harshitramahalingam/Documents/CA2DM/PtTe2-experiment/Calculation/calc_settings.jl")

## Plotting
# Convert X and Y to Bohr radii. Reshape the arrays
xs = reduce(vcat, XS)
ys = reduce(vcat, YS)
#x and y axis of the spectral map
X = small_d1[1] .* xs + small_d2[1] .* ys
Y = small_d1[2] .* xs + small_d2[2] .* ys

X_latt = d1[1] .* xs + d2[1] .* ys
Y_latt = d1[2] .* xs + d2[2] .* ys
# res = @showprogress pmap((x, y) -> spectral_bulk(ω, Location(x, y), s), XS, YS) #Computation, Get the results
signal = reduce(vcat, res)

x_positions2 = map(y -> y.loc.v1, POTENTIAL)
y_positions2 = map(y -> y.loc.v2, POTENTIAL)

X_LP = small_d1[1] .* x_positions2 + small_d2[1] .* y_positions2
Y_LP = small_d1[2] .* x_positions2 + small_d2[2] .* y_positions2

# if all(>=(0), final_signal)
#     color_lim = -findmax(final_signal)[1] / 10
# else
#     color_lim = findmin(final_signal)[1]
# end

fig = Figure(resolution = (1800, 1800))
ax =
    fig[1, 1] = Axis(
        fig,
        # xlabel = "x/nm",
        # ylabel = "y/nm",
        xlabelpadding = 0,
        ylabelpadding = 0,
        xlabelsize = 50,
        ylabelsize = 50,
        # title = "FO map at $ω eV",
        titlefont = "LibreBaskerville-Regular.ttf",
        titlesize = 60,
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
    color = signal,
    strokewidth = 0,
    # marker = '◼',
    marker = :hexagon,
    # markersize = 45,
    markersize = 41,
    colormap = :jet,
    colorrange = (0.1, 1.45)
    # colorrange = (color_lim, -color_lim),
)



sc = CairoMakie.scatter!(
    ax,
    X_LP .* a0 / 10,
    Y_LP .* a0 / 10,
    marker = :x,
    markersize = 20,
    # markersize = 10,
    color = :black ,
    strokewidth = 0.3,
)

sc = CairoMakie.scatter!(
    ax,
    X_latt .* a0 / 10,
    Y_latt .* a0 / 10,
    strokewidth = 1.8,
    marker = :hexagon,
    # strokecolor = RGBA(1.0,1.0,1.0,0.25),
    strokecolor = RGBA(0.0,0.0,0.0,0.25),
    color = :transparent,
    markersize = 120,
    strokestyle = :dot
    )


tightlimits!(ax)
xlims!(ax, (-4.0, 4.0))
ylims!(ax, (-4.0, 4.0))
fig

# save("Spectral_Single_Defect_005eV.pdf", fig)
