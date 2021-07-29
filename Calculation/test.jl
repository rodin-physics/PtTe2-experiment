using CairoMakie
using Distributed
proc_number = 4;
if nprocs() < proc_number
    addprocs(proc_number - nprocs())
end

@everywhere include("/Users/harshitramahalingam/Documents/CA2DM/PtTe2-experiment/Calculation/calc_settings.jl")

## Calculation
location_list = range(-8, 8, step = 1)
full_map = @showprogress pmap(x -> pmap(y -> spectral_bulk(x, Location(y, 0), s), location_list), ωs)
# full_grid = reshape([(full_map...)...], length(location_list), :)
#
# distx = d1[1] .* location_list
# disty = d1[2] .* location_list

## Plotting
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
                xticks = -2.0:0.5:2.0,
                # aspect = AxisAspect(1.5),
        )

sc = CairoMakie.heatmap!(
        ωs,
        distx,
        transpose(full_grid),
        # strokewidth = 0,
        # marker = :hexagon,
        # markersize = 9,
        colormap = cgrad(:jet, rev = false),
        colorrange = (0.03, 0.07)
        )
