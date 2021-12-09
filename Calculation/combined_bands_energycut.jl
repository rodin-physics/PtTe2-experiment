using CairoMakie
using DelimitedFiles
include("calc_settings.jl")

scaling_cb = 1.0
scaling_vb = 0.3

xs_vb = reshape(readdlm("xs_vb.dat"), nPts)
xs_cb = reshape(readdlm("xs_cb.dat"), nPts)

trimer_vb = reshape(readdlm("Trimer_VB.dat"), nPts)
trimer_cb = reshape(readdlm("Trimer_CB.dat"), nPts)
trimer_total = (scaling_cb .* trimer_cb) .+ (scaling_vb .* reverse(trimer_vb))

hexamer_vb = reshape(readdlm("Hexamer_VB.dat"), nPts)
hexamer_cb = reshape(readdlm("Hexamer_CB.dat"), nPts)
hexamer_total = (scaling_cb .* hexamer_cb) .+ (scaling_vb .* reverse(hexamer_vb))

decamer_vb = reshape(readdlm("Decamer_VB.dat"), nPts)
decamer_cb = reshape(readdlm("Decamer_CB.dat"), nPts)
decamer_total = (scaling_cb .* decamer_cb) .+ (scaling_vb .* reverse(decamer_vb))


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
        title = "Total Signal",
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
band!(ax, band_edge_vb:0.05:band_edge_cb, -0.1, 2.5, color = :lightgrey)

lineplot1 = lines!(xs_vb, trimer_vb, color = RGBA(0, 0, 1, 0.4), linewidth = 6, label = "Trimer", linestyle = :dashdot)
lineplot = lines!(xs_cb, trimer_cb, color = RGBA(0, 0, 1, 0.4), linewidth = 6, linestyle = :dot)

lineplot = lines!(xs_cb, trimer_total, color = :blue, linewidth = 6, linestyle = :solid)

#
lineplot2 = lines!(xs_vb, hexamer_vb, color = RGBA(1, 0.84, 0, 0.4), linewidth = 6, label = "Hexamer", linestyle = :dashdot)
lineplot = lines!(xs_cb, hexamer_cb, color =  RGBA(1, 0.84, 0, 0.4), linewidth = 6, linestyle = :dot)

lineplot = lines!(xs_cb, hexamer_total, color = :gold, linewidth = 6, linestyle = :solid)
#
lineplot3 = lines!(xs_vb, decamer_vb, color = RGBA(0, 0.5, 0, 0.4), linewidth = 6, label = "Decamer", linestyle = :dashdot)
lineplot = lines!(xs_cb, decamer_cb, color = RGBA(0, 0.5, 0, 0.4), linewidth = 6, linestyle = :dot)

lineplot = lines!(xs_cb, decamer_total, color = :green, linewidth = 6, linestyle = :solid)
#
CairoMakie.xlims!(ax, (2.0, 3.5))
CairoMakie.ylims!(ax, (-0.1, 2.5))

# vlines!(ax,[band_edge_vb, band_edge_cb], color = :black, linewidth = 4, linestyle = :dash)


elem_1 = [LineElement(color = :blue, linestyle = nothing, linewidth = 5)]
elem_2 = [LineElement(color = :gold, linestyle = nothing, linewidth = 5)]
elem_3 = [LineElement(color = :green, linestyle = nothing, linewidth = 5)]

elem_4 = [LineElement(color = :black, linestyle = :dashdot, linewidth = 5)]
elem_5 = [LineElement(color = :black, linestyle = :dot, linewidth = 5)]
elem_6 = [LineElement(color = :black, linestyle = :solid, linewidth = 5)]


axislegend(ax, [elem_1, elem_2, elem_3, elem_4, elem_5, elem_6],
["Trimer", "Hexamer", "Decamer", "Valence Band", "Conduction Band", "Total Signal"], labelsize = 30, patchsize = (65, 65), rowgap = 10, labelfont = "Calculation/LibreBaskerville-Regular.ttf")
fig
