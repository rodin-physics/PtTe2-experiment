using CairoMakie
using Distributed
proc_number = 4;
if nprocs() < proc_number
    addprocs(proc_number - nprocs())
end

@everywhere include("Calculation/calc_settings.jl")

## Definitions and Calculation
# Convert X and Y to Bohr radii. Reshape the arrays
us = vec(US)
vs = vec(VS)
# x and y axis of the spectral map in Bohr radii
X = refined_d1[1] .* us + refined_d2[1] .* vs
Y = refined_d1[2] .* us + refined_d2[2] .* vs
#
# signal = @showprogress pmap((u, v) -> spectral_bulk(ω, Location(u, v), s), us, vs)
#
# ## Calculation
signal_mod = signal .- signal[1]
FT_res = @showprogress pmap((qx, qy) -> FT_component(qx, qy, signal_mod, X, Y), QX, QY)

upper = maximum(abs.(FT_res))
# writedlm("QX.dat", QX)
# writedlm("QY.dat", QY)
# writedlm("FT_real.dat", real.(FT_res))
# writedlm("FT_imag.dat", imag.(FT_res))


X_reci = r_d1[1] .* us + r_d2[1] .* vs
Y_reci = r_d1[2] .* us + r_d2[2] .* vs

X_reci2 = r_d1[1] .* (us./2) + r_d2[1] .* (vs./2)
Y_reci2 = r_d1[2] .* (us./2) + r_d2[2] .* (vs./2)

fig = CairoMakie.Figure(resolution=(1800, 1800))
ax =
        fig[1, 1] = Axis(
                fig,
                xlabel="kx",
                ylabel="ky",
                xlabelpadding=0,
                ylabelpadding=0,
                xlabelsize=40,
                ylabelsize=40,
                xticklabelsize=40,
                yticklabelsize=40,
                title="FT at $ω eV",
                titlefont="Calculation/LibreBaskerville-Regular.ttf",
                titlesize=40,
                aspect=AxisAspect(1),
                xticklabelfont="Calculation/LibreBaskerville-Regular.ttf",
                yticklabelfont="Calculation/LibreBaskerville-Regular.ttf",
                xlabelfont="Calculation/LibreBaskerville-Italic.ttf",
                ylabelfont="Calculation/LibreBaskerville-Italic.ttf",
        )

hm2 = heatmap!(QX[:,1], QY[1,:], abs.(FT_res),
                colormap=cgrad(:FT_scheme),
                # colorrange=(0,40)
                )

scatter!(
    ax,
    X_reci,
    Y_reci,
    strokewidth=1.8,
    marker=:circle,
    # strokecolor = RGBA(1.0,1.0,1.0,0.25),
    strokecolor=RGBA(0.0, 0.0, 0.0, 0.25),
    color=:white,
    markersize=20,
    strokestyle=:dot,
    )

scatter!(
        ax,
        X_reci2,
        Y_reci2,
        strokewidth=1.8,
        marker=:x,
        strokecolor = RGBA(1.0,1.0,1.0,0.25),
        # strokecolor=RGBA(0.0, 0.0, 0.0, 0.25),
        color=:white,
        markersize=25,
        )

tightlimits!(ax)
xlims!(ax, (qx_min, qx_max))
ylims!(ax, (qx_min, qx_max))
fig
