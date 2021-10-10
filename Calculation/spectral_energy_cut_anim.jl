using CairoMakie
using Distributed

proc_number = 4;

if nprocs() < proc_number
        addprocs(proc_number - nprocs())
end

@everywhere include("/Users/harshitramahalingam/Documents/CA2DM/PtTe2-experiment/Calculation/calc_settings.jl")

## Plotting
#To plot simulated dI/dV line cut along with experimental data for charged SV
function spectral_plotter(U1, U2)
        POTENTIAL = make_shape2(U1, U2, 6, config7)
        s = AtomsSystem(μ, T, POTENTIAL)

        dI_dV = @showprogress pmap(x -> spectral_bulk(x, Location(1,1), s), ωs)

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
                title = "U₁ = $U1, U₂ = $U2",
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

        lineplot = lines!(ωs, dI_dV, color = :blue, linewidth = 6, label = "Center")

        CairoMakie.xlims!(ax, (-0.7, 0.01))
        CairoMakie.ylims!(ax, (0.0, 1.0))

        vlines!(ax,[-0.57])

        name = lpad(Int(- U1 * 1000),4, '0')
        save("-$name varying_U1.png", fig)
end

for ii in range(-0.35, -0.02, step = 0.01)
    spectral_plotter(ii, U_val2)
end
