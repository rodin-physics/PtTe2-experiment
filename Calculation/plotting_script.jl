using CairoMakie
using DelimitedFiles
include("calc_settings.jl")

xs_vb = reshape(readdlm("xs_vb.dat"), nPts)
xs_cb = reshape(readdlm("xs_cb.dat"), nPts)

trimer_vb = reshape(readdlm("Trimer_VB.dat"), nPts)
trimer_cb = reshape(readdlm("Trimer_CB.dat"), nPts)

hexamer_vb = reshape(readdlm("Hexamer_VB.dat"), nPts)
hexamer_cb = reshape(readdlm("Hexamer_CB.dat"), nPts)

decamer_vb = reshape(readdlm("Decamer_VB.dat"), nPts)
decamer_cb = reshape(readdlm("Decamer_CB.dat"), nPts)


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
#
# lineplot = lines!(xs_vb, trimer_vb, color = :blue, linewidth = 6, label = "Trimer")
lineplot = lines!(xs_cb, trimer_cb, color = :blue, linewidth = 6, label = "Trimer")
#
# lineplot = lines!(xs_vb, hexamer_vb, color = :gold, linewidth = 6, label = "Hexamer")
lineplot = lines!(xs_cb, hexamer_cb, color = :gold, linewidth = 6, label = "Hexamer")
#
# lineplot = lines!(xs_vb, decamer_vb, color = :green, linewidth = 6, label = "Decamer")
lineplot = lines!(xs_cb, decamer_cb, color = :green, linewidth = 6, label = "Decamer")
#
CairoMakie.xlims!(ax, (minimum(xs_vb), maximum(xs_vb)))
CairoMakie.ylims!(ax, (-0.1, 2.3))

vlines!(ax,[band_edge_vb, band_edge_cb], color = :black, linewidth = 4, linestyle = :dash)

axislegend(labelsize = 45, width = 350, strokewidth = 16)
fig
