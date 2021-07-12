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

x_positions2 = map(y -> y.loc.v1, POTENTIAL)
y_positions2 = map(y -> y.loc.v2, POTENTIAL)

X_LP = d1[1] .* x_positions2 + d2[1] .* y_positions2
Y_LP = d1[2] .* x_positions2 + d2[2] .* y_positions2


fig = Figure(resolution = (1600, 1600))
ax =
    fig[1, 1] = Axis(
        fig,
        xlabel = "x/nm",
        ylabel = "y/nm",
        xlabelpadding = 0,
        ylabelpadding = 0,
        xlabelsize = 16,
        ylabelsize = 16,
        title = "FO map - $ω eV",
        xticklabelsize = 14,
        yticklabelsize = 14,
        aspect = DataAspect(),
        xticklabelfont = "serif-roman",
        yticklabelfont = "serif-roman",
        xlabelfont = "serif-italic",
        ylabelfont = "serif-italic",
    )

sc = CairoMakie.scatter!(
    ax,
    X .* a0 / 10,
    Y .* a0 / 10,
    color = signal .- signal[1],
    strokewidth = 0,
    # marker = '◼',
    marker = :hexagon,
    markersize = 6.8,
    colormap = :bwr,
    colorrange = (-.2, 0.2),
)



sc = CairoMakie.scatter!(
    ax,
    X_LP .* a0 / 10,
    Y_LP .* a0 / 10,
    marker = :circle,
    markersize = 1,
    color = :black
)

# sc = CairoMakie.scatter!(
#     ax,
#     [0],[0],
#     marker = :circle,
#     markersize = 1,
#     color = :blue,
# )

tightlimits!(ax)
CairoMakie.xlims!(ax, [-10, 10])
CairoMakie.ylims!(ax, [-10, 10])
fig

# save("Spectral_Single_Defect_005eV.pdf", fig)
