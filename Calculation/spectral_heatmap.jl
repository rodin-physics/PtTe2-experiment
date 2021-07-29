using CairoMakie
using Distributed
proc_number = 4;
if nprocs() < proc_number
    addprocs(proc_number - nprocs())
end

@everywhere begin
    using ProgressMeter
    using Distributed
end

@everywhere include("/Users/harshitramahalingam/Documents/CA2DM/PtTe2-experiment/Calculation/calc_settings.jl")
## Calculation
location_list = range(-10, 10, step = 1)
full_map = @showprogress map(x -> map(y -> spectral_bulk(x, Location(0, y), s), location_list), ωs)
full_grid = reshape([(full_map...)...], length(location_list), :)
#
distx = d1[1] .* location_list
disty = d1[2] .* location_list

## Plotting

lower, upper = 0.0, 1.5

fig = Figure(resolution = (1800, 1800))
ax =
        fig[1, 1] = Axis(
                fig,
                xlabel = "ω (eV)",
                ylabel = "r (nm)",
                xlabelpadding = 0,
                ylabelpadding = 8,
                xlabelsize = 14,
                ylabelsize = 14,
                xticklabelsize = 9.5,
                yticklabelsize = 9.5,
                xticklabelfont = "Times New Roman.ttf",
                yticklabelfont = "Times New Roman.ttf",
                titlefont = "Times New Roman.ttf",
                xlabelfont = "Times New Roman Italic.ttf",
                ylabelfont = "Times New Roman Italic.ttf",
                title = "Full Heatmap",
                titlesize = 10,
                xticks = -2.0:0.05:2.0,
                # aspect = AxisAspect(1.5),
        )

sc = CairoMakie.heatmap!(
        ωs,
        distx .* 0.0529177249,
        transpose(full_grid),
        # strokewidth = 0,
        # marker = :hexagon,
        # markersize = 9,
        colormap = cgrad(:jet, rev = false),
        colorrange = (lower, upper)
        )


cbar = Colorbar(fig[1,2],
        width = 10,
        # limits = sc.colorrange,
        # limits = [minimum(signal), maximum(signal)],
        limits = [lower, upper],
        colormap = cgrad(:jet, rev = false),
        ticklabelfont = "Times New Roman.ttf",
        ticklabelsize = 10,
        labelfont = "Times New Roman.ttf",
        labelsize = 10,
        # label = "A(ω) (electron/orbital) ",
        # ticks = 0.00:0.005:0.06,
        ticksize = 5,
        # height = Relative(2/3)
)

tightlimits!(ax)
CairoMakie.xlims!(ax, [-0.2, 1.5])
# CairoMakie.ylims!(ax, [0, 17])
colgap!(fig.layout, 1, Fixed(0))


fig
