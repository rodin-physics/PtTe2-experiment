using CairoMakie
using Distributed
proc_number = 24;
if nprocs() < proc_number
    addprocs(proc_number - nprocs())
end

@everywhere include("Calculation/calc_settings.jl")

## Plotter function
function plotter_func(energy::Float64)
    us = vec(US)
    vs = vec(VS)

    #x and y axis of the spectral map
    X = refined_d1[1] .* us + refined_d2[1] .* vs
    Y = refined_d1[2] .* us + refined_d2[2] .* vs

    # Actual lattice
    X_latt = d1[1] .* us + d2[1] .* vs
    Y_latt = d1[2] .* us + d2[2] .* vs

    newPOT = filter(x -> x.V == U_val1, POTENTIAL)
    u_LP = map(y -> y.loc.v1, newPOT)
    v_LP = map(y -> y.loc.v2, newPOT)

    X_LP = refined_d1[1] .* u_LP + refined_d2[1] .* v_LP
    Y_LP = refined_d1[2] .* u_LP + refined_d2[2] .* v_LP

    signal = pmap((x, y) -> spectral_bulk(energy, Location(x, y), s), us, vs)

    fig = Figure(resolution = (1800, 1800))
    ax =
        fig[1, 1] = Axis(
            fig,
            xlabel = "x/nm",
            ylabel = "y/nm",
            xlabelpadding = 0,
            ylabelpadding = 0,
            xlabelsize = 50,
            ylabelsize = 50,
            title = "CB model - $energy eV",
            titlefont = "Calculation/LibreBaskerville-Regular.ttf",
            titlesize = 60,
            xticklabelsize = 18,
            yticklabelsize = 18,
            aspect = DataAspect(),
            xticklabelfont = "Calculation/LibreBaskerville-Regular.ttf",
            yticklabelfont = "Calculation/LibreBaskerville-Regular.ttf",
            xlabelfont = "Calculation/LibreBaskerville-Italic.ttf",
            ylabelfont = "Calculation/LibreBaskerville-Italic.ttf",
        )

    sc = CairoMakie.scatter!(
        ax,
        X .* a0 / 10,
        Y .* a0 / 10,
        color = signal,
        strokewidth = 0,
        # marker = '◼',
        marker = :hexagon,
        # markersize = 45,
        markersize = 60,
        colormap = cgrad(:custom_rainbow),
        # colorrange = (0.0, 0.007)
        # colorrange = (color_lim, -color_lim),
    )



    sc = CairoMakie.scatter!(
        ax,
        X_LP .* a0 / 10,
        Y_LP .* a0 / 10,
        marker = :circle,
        markersize = 58,
        # markersize = 10,
        color = :transparent ,
        strokewidth = 6,
        strokecolor = :white
    )

    # sc = CairoMakie.scatter!(
    #     ax,
    #     X_latt .* a0 / 10,
    #     Y_latt .* a0 / 10,
    #     strokewidth = 1.8,
    #     marker = :hexagon,
    #     # strokecolor = RGBA(1.0,1.0,1.0,0.25),
    #     strokecolor = RGBA(0.0,0.0,0.0,0.25),
    #     color = :transparent,
    #     markersize = 180,
    #     strokestyle = :dot
    #     )



    tightlimits!(ax)
    CairoMakie.xlims!(ax, (-2.5, 2.5))
    CairoMakie.ylims!(ax, (-2.5, 2.5))

    if M_scatter
        name = lpad(Int(round((band_edge_vb - energy) * 1000)),4, '0')
        save("Decamer_$name.png", fig)
    else
        name = lpad(Int(round((band_edge_cb + energy) * 1000)),4, '0')
        save("Decamer_$name.png", fig)
    end
    # fig

end


## Series of figures
for ii in range(-0.3, 0.75, step = 0.01)
    plotter_func(ii)
end
