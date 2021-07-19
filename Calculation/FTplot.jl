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
                xlabel = "qx",
                ylabel = "qy",
                xlabelpadding = 0,
                ylabelpadding = 0,
                xlabelsize = 12,
                ylabelsize = 12,
                xticklabelsize = 12,
                yticklabelsize = 12,
                title = "FT - $ω eV",
                titlefont = "LibreBaskerville-Regular.ttf",
                titlesize = 12,
                aspect = AxisAspect(1),
                xticklabelfont = "LibreBaskerville-Regular.ttf",
                yticklabelfont = "LibreBaskerville-Regular.ttf",
                xlabelfont = "LibreBaskerville-Italic.ttf",
                ylabelfont = "LibreBaskerville-Italic.ttf",
        )

hm2 = heatmap!(qx, qy, abs.(FT_res),
                colormap = :oslo,
                colorrange = (0,15))
Colorbar(fig2[1, 2], hm2, width =40)
fig2
# save("FT_amplitude.pdf", fig2)
