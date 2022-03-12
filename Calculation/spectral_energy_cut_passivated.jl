using CairoMakie
using Distributed
proc_number = 4;
if nprocs() < proc_number
    addprocs(proc_number - nprocs())
end

@everywhere include("calc_settings.jl")

hex_locs = vcat(Hexamer.Center, neighbors(Hexamer.Center))

# System definitions
s_p1 = AtomsSystem(μ, T, passivated_hexamer(U_val1, U_val2, U_val3, U_val4, 1))
s_p2 = AtomsSystem(μ, T, passivated_hexamer(U_val1, U_val2, U_val3, U_val4, 2))
s_p3 = AtomsSystem(μ, T, passivated_hexamer(U_val1, U_val2, U_val3, U_val4, 3))

## Calculation
# dI_dV1 = @showprogress pmap(x -> spectral_bulk_average(x, hex_locs, s_hexamer), ωs)
#
# dI_dV2 = @showprogress pmap(x -> spectral_bulk_average(x, hex_locs, s_p1), ωs)
#
# dI_dV3 = @showprogress pmap(x -> spectral_bulk_average(x, hex_locs, s_p2), ωs)
#
# dI_dV4 = @showprogress pmap(x -> spectral_bulk_average(x, hex_locs, s_p3), ωs)

xs =  band_edge_cb .+ ωs

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
        title = "U₃ = $U_val3, U₄ = $U_val4",
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

lineplot = lines!(xs, dI_dV1, color = :orange, linewidth = 6, label = "Hex")
lineplot = lines!(xs, dI_dV2, color = :darkorange2, linewidth = 6, label = "PH-1")
lineplot = lines!(xs, dI_dV3, color = :orangered2, linewidth = 6, label = "PH-2")
lineplot = lines!(xs, dI_dV4, color = :orangered4, linewidth = 6, label = "PH-3")

CairoMakie.xlims!(ax, (2.0, 3.5))
# CairoMakie.ylims!(ax, (-0.1, 2.4))

vlines!(ax,[band_edge_vb, band_edge_cb], color = :black, linewidth = 4, linestyle = :dash)
# vlines!(ax,[3.2, 3.22], color = :blue, linewidth = 4, linestyle = :dash)
# vlines!(ax,[2.46], color = :blue, linewidth = 4, linestyle = :dash)
# vlines!(ax,[2.32, 2.7], color = :gold, linewidth = 4, linestyle = :dash)
# vlines!(ax,[2.375, 2.53], color = :green, linewidth = 4, linestyle = :dash)
axislegend(labelsize = 45, width = 240, strokewidth = 16, position = :lt)
fig
