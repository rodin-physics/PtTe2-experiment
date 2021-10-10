using CairoMakie
using Distributed
proc_number = 4;
if nprocs() < proc_number
    addprocs(proc_number - nprocs())
end

include("/Users/harshitramahalingam/Documents/CA2DM/PtTe2-experiment/Calculation/Findpeaks.jl")
@everywhere include("/Users/harshitramahalingam/Documents/CA2DM/PtTe2-experiment/Calculation/calc_settings.jl")

## Calculation

dI_dV = @showprogress pmap(x -> spectral_bulk(x, Location(4,-5), s), ωs)

peaks = findpeaks(dI_dV, ωs, min_prom=0.0001)
println(sort(ωs[peaks], rev = true))
println(2.3 .- sort(ωs[peaks], rev = true))
## Plotting
fig = Figure(resolution = (1800, 1800))
ax =
    fig[1, 1] = Axis(
        fig,
        xlabel = "Energy/eV",
        ylabel = "Spec Func",
        xlabelpadding = 0,
        ylabelpadding = 0,
        xlabelsize = 40,
        ylabelsize = 40,
        title = "U₁ = $U_val1, U₂ = $U_val2",
        titlefont = "Calculation/LibreBaskerville-Regular.ttf",
        titlesize = 60,
        xticklabelsize = 40,
        yticklabelsize = 40,
        aspect = AxisAspect(1),
        xticklabelfont = "Calculation/LibreBaskerville-Regular.ttf",
        yticklabelfont = "Calculation/LibreBaskerville-Regular.ttf",
        xlabelfont = "Calculation/LibreBaskerville-Italic.ttf",
        ylabelfont = "Calculation/LibreBaskerville-Italic.ttf",
    )

lineplot = lines!(2.3 .- ωs, dI_dV, color = :blue, linewidth = 6, label = "Center")

CairoMakie.xlims!(ax, (2.0, 3.0))
CairoMakie.ylims!(ax, (0.0, 1.4))

vlines!(ax,[2.3], color = :black, linewidth = 4, linestyle = :dash)
fig
