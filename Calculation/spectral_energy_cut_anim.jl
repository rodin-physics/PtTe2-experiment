using CairoMakie
using Distributed

proc_number = 4;

if nprocs() < proc_number
        addprocs(proc_number - nprocs())
end

@everywhere include("calc_settings.jl")
xs =  band_edge_vb .- ωs
## Plotting
#To plot simulated dI/dV line cut along with experimental data for charged SV
function spectral_plotter(U3)
        # POTENTIAL = make_shape2(U1, U2, 6, config7)
        POTENTIAL = passivated_hexamer(U_val1, U_val2, U3, U3)
        POTENTIAL2 = make_shape(U_val1, U_val2, 6)
        s = AtomsSystem(μ, T, POTENTIAL)

        dI_dV = @showprogress pmap(x -> spectral_bulk_average(x, [Hexamer.Center, Hexamer.Center + Location(-1,0), Hexamer.Center + Location(0,-1)], s), ωs)

        dI_dV2 = @showprogress pmap(x -> spectral_bulk_average(x, [Hexamer.Center, Hexamer.Center + Location(-1,0), Hexamer.Center + Location(0,-1)], (AtomsSystem(μ, T, POTENTIAL2))), ωs)

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
                # title = "U₁ = $U1, U₂ = $U2",
                title = "U₃ = $U3",
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

        lineplot = lines!(xs, dI_dV, color = :blue, linewidth = 6, label = "PH")
        lineplot = lines!(xs, dI_dV2, color = :gold, linewidth = 6, label = "H")

        CairoMakie.xlims!(ax, (2.0, 3.5))
        CairoMakie.ylims!(ax, (0.0, 2.5))

        vlines!(ax,[band_edge_vb, band_edge_cb], color = :black, linewidth = 4, linestyle = :dash)
        axislegend()

        name = lpad(Int(- U3 * 1000),4, '0')
        save("-$name varying_U3.png", fig)
end

for ii in range(-0.22, -0.01, step = 0.01)
    spectral_plotter(ii)
end
