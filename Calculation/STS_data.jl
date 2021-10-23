using CairoMakie
using DelimitedFiles

full_data = readdlm("/Users/harshitramahalingam/Documents/CA2DM/PtTe2-experiment/Calculation/Raw data for STS curve.txt", '\t')

bias = full_data[:,1]
bulk = full_data[:,2]
sv =  full_data[:,3]


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
                xticklabelsize = 25,
                yticklabelsize = 25,
                xticklabelfont = "Times New Roman.ttf",
                yticklabelfont = "Times New Roman.ttf",
                titlefont = "Times New Roman.ttf",
                xlabelfont = "Times New Roman Italic.ttf",
                ylabelfont = "Times New Roman Italic.ttf",
                title = "STS data",
                titlesize = 30,
                xticks = -2.0:0.05:3.0,
                # aspect = AxisAspect(1.5),
        )

li = CairoMakie.lines!(
        bias,
        bulk,
        linewidth = 7, color = :red)

# li = CairoMakie.lines!(
#         bias,
#         sv,
#         linewidth = 7, color = :blue)

hlines!(ax, [0.0, -2.3e-13], linewidth = 3, color = :black, linestyle = :dash)
vlines!(ax, [2.26, 2.68], linewidth = 3, color = :black)

tightlimits!(ax)
xlims!(ax, (2.0, 3.0))
ylims!(ax, (-5e-13, 1e-12))
fig
