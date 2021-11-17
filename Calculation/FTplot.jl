using CairoMakie
using DelimitedFiles


QX = readdlm("QX.dat")
QY = readdlm("QY.dat")
FT_real = readdlm("FT_real.dat")
FT_imag = readdlm("FT_imag.dat")

FT_res = FT_real + 1im .* FT_imag

# fig = CairoMakie.Figure(resolution = (1800, 1800))
# ax =
#         fig[1, 1] = Axis(
#                 fig,
#                 xlabel = "qx",
#                 ylabel = "qy",
#                 xlabelpadding = 0,
#                 ylabelpadding = 0,
#                 xlabelsize = 12,
#                 ylabelsize = 12,
#                 xticklabelsize = 12,
#                 yticklabelsize = 12,
#                 aspect = AxisAspect(1),
#                 xticklabelfont = "serif-roman",
#                 yticklabelfont = "serif-roman",
#                 xlabelfont = "serif-italic",
#                 ylabelfont = "serif-italic",
#         )
#
# hm = heatmap!(qx, qy, angle.(FT_res), colormap = :oslo)
# Colorbar(fig[1, 2], hm, width = 40)
# fig
# save("FT_phase.pdf", fig)

fig2 = CairoMakie.Figure(resolution = (1800, 1800))
ax2 =
        fig2[1, 1] = Axis(
                fig2,
                xlabel = "kx",
                ylabel = "ky",
                xlabelpadding = 0,
                ylabelpadding = 0,
                xlabelsize = 40,
                ylabelsize = 40,
                xticklabelsize = 40,
                yticklabelsize = 40,
                title = "FT at $ω eV",
                titlefont = "Calculation/LibreBaskerville-Regular.ttf",
                titlesize = 40,
                aspect = AxisAspect(1),
                xticklabelfont = "Calculation/LibreBaskerville-Regular.ttf",
                yticklabelfont = "Calculation/LibreBaskerville-Regular.ttf",
                xlabelfont = "Calculation/LibreBaskerville-Italic.ttf",
                ylabelfont = "Calculation/LibreBaskerville-Italic.ttf",
        )

hm2 = heatmap!(qx, qy, abs.(FT_res),
                colormap = cgrad(:FT_scheme),
                colorrange = (0,40))

# scatter!([qx_max,-qx_max, qx_max,-qx_max],[qx_max,-qx_max, -qx_max,qx_max], markersize = 18)

# scatter!([0.0], [0.0], marker = :hexagon, markersize = 556, color = :transparent, markerstyle = :dashdot, strokewidth = 2, strokecolor = :white)

# scatter!([0.0], [0.0], marker = :hexagon, markersize = 850, color = :transparent, markerstyle = :dashdot, strokewidth = 2, strokecolor = :white)

scatter!(
    ax2,
    X_reci,
    Y_reci,
    strokewidth = 6,
    marker = :circle,
    strokecolor = RGBA(1.0,1.0,1.0,0.25),
    # strokecolor = RGBA(0.0,0.0,0.0,0.25),
    color = :white,
    markersize = 20,
    strokestyle = :dot,
    # rotations = 11,
    )

# vlines!(ax2, [qx_min, qx_max], color = :white, linewidth = 2)
# hlines!(ax2, [qx_min, qx_max], color = :white, linewidth = 2)
# Color bar(fig2[1, 2], hm2, width =40)

tightlimits!(ax2)
xlims!(ax2, (qx_min, qx_max))
ylims!(ax2, (qx_min, qx_max))
fig2
# save("FT_amplitude.pdf", fig2)
