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
X = d1[1] .* xs + d2[1] .* ys
Y = d1[2] .* xs + d2[2] .* ys
res = @showprogress pmap((x, y) -> spectral_bulk(ω, Location(x, y), s), XS, YS) #Computation, Get the results
signal = reduce(vcat, res)
final_signal = signal .- signal[1]

x_positions2 = map(y -> y.loc.v1, POTENTIAL)
y_positions2 = map(y -> y.loc.v2, POTENTIAL)

X_LP = d1[1] .* x_positions2 + d2[1] .* y_positions2
Y_LP = d1[2] .* x_positions2 + d2[2] .* y_positions2

if all(>=(0), final_signal)
    color_lim = -findmax(final_signal)[1] / 10
else
    color_lim = findmin(final_signal)[1]
end

fig = Figure(resolution = (1800, 1800))
ax =
    fig[1, 1] = Axis(
        fig,
        xlabel = "x/nm",
        ylabel = "y/nm",
        xlabelpadding = 0,
        ylabelpadding = 0,
        xlabelsize = 12,
        ylabelsize = 12,
        title = "FO map at $ω eV",
        titlefont = "LibreBaskerville-Regular.ttf",
        titlesize = 12,
        xticklabelsize = 11,
        yticklabelsize = 11,
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
    color = signal .- signal[1],
    strokewidth = 0,
    # marker = '◼',
    marker = :hexagon,
    markersize = 7.1,
    # markersize = 14,
    colormap = :bwr,
    colorrange = (color_lim, -color_lim),
)



sc = CairoMakie.scatter!(
    ax,
    X_LP .* a0 / 10,
    Y_LP .* a0 / 10,
    marker = :x,
    markersize = 5,
    # markersize = 10,
    color = :black ,
    strokewidth = 0.4,
)


tightlimits!(ax)
CairoMakie.xlims!(ax, [-10, 10])
CairoMakie.ylims!(ax, [-10, 10])
fig

# save("Spectral_Single_Defect_005eV.pdf", fig)
