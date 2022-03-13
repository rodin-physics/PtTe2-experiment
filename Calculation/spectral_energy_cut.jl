using CairoMakie
using Distributed
proc_number = 4;
if nprocs() < proc_number
    addprocs(proc_number - nprocs())
end

@everywhere include("Calculation/calc_settings.jl")

## Calculation
dI_dV1 = @showprogress pmap(x -> spectral_bulk(x, Location(1,1), s), ωs)
#
dI_dV2 = @showprogress pmap(x -> spectral_bulk(x, Inverted_Trimer.Center, s_trimer), ωs)
#
dI_dV3 = @showprogress pmap(x -> spectral_bulk_average(x, [Hexamer.Center, Hexamer.Center + Location(-1,0), Hexamer.Center + Location(0,-1)], s_hexamer), ωs)

dI_dV4 = @showprogress pmap(x -> spectral_bulk_average(x, [Decamer.Center, Decamer.Center + Location(-1,0), Decamer.Center + Location(0, -1)], s_decamer), ωs)

xs =  band_edge_vb .- ωs

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
        xticks = -4.5:0.5:8.0
    )

lineplot = lines!(xs, dI_dV1, color = :red, linewidth = 6, label = "SV")
lineplot = lines!(xs, dI_dV2, color = :blue, linewidth = 6, label = "Trimer")
lineplot = lines!(xs, dI_dV3, color = :gold, linewidth = 6, label = "Hexamer")
lineplot = lines!(xs, dI_dV4, color = :green, linewidth = 6, label = "Decamer")

CairoMakie.xlims!(ax, (2.0, 3.5))
# CairoMakie.ylims!(ax, (-0.1, 2.3))

vlines!(ax,[band_edge_vb, band_edge_cb], color = :black, linewidth = 4, linestyle = :dash)
# vlines!(ax,[2.46], color = :blue, linewidth = 4, linestyle = :dash)
# vlines!(ax,[2.32, 2.7], color = :gold, linewidth = 4, linestyle = :dash)
# vlines!(ax,[2.375, 2.53], color = :green, linewidth = 4, linestyle = :dash)
axislegend(labelsize = 45, width = 350, strokewidth = 16)
fig
