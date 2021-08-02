using CairoMakie
using Distributed
proc_number = 4;
if nprocs() < proc_number
    addprocs(proc_number - nprocs())
end

@everywhere include("/Users/harshitramahalingam/Documents/CA2DM/PtTe2-experiment/Calculation/calc_settings.jl")

## Calculation
# dI_dV = @showprogress pmap(x -> spectral_bulk(x, Location(1, 1), s), ωs)

## Plotting
fig = Figure(resolution = (1800, 1800))
ax =
    fig[1, 1] = Axis(
        fig,
        xlabel = "Energy/eV",
        ylabel = "Spec Func",
        xlabelpadding = 0,
        ylabelpadding = 0,
        xlabelsize = 12,
        ylabelsize = 12,
        title = "Spectral Func - Center with U = $U_val1",
        titlefont = "LibreBaskerville-Regular.ttf",
        titlesize = 12,
        xticklabelsize = 11,
        yticklabelsize = 11,
        aspect = AxisAspect(1),
        xticklabelfont = "LibreBaskerville-Regular.ttf",
        yticklabelfont = "LibreBaskerville-Regular.ttf",
        xlabelfont = "LibreBaskerville-Italic.ttf",
        ylabelfont = "LibreBaskerville-Italic.ttf",
    )

lineplot = lines!(ωs, dI_dV, color = :blue, linewidth = 2, label = "Center")

CairoMakie.xlims!(ax, [-0.3, 0.1])
CairoMakie.ylims!(ax, [0.0, 0.7])

fig
