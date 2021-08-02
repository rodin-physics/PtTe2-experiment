using CairoMakie
using Distributed
proc_number = 4;
if nprocs() < proc_number
    addprocs(proc_number - nprocs())
end
# CairoMakie.activate!(type = "png")
@everywhere include("/Users/harshitramahalingam/Documents/CA2DM/PtTe2-experiment/Calculation/calc_settings.jl")

## Plotter function
function plotter_func(energy::Float64)
    xs = reduce(vcat, XS)
    ys = reduce(vcat, YS)
    #x and y axis of the spectral map
    X = d1[1] .* xs + d2[1] .* ys
    Y = d1[2] .* xs + d2[2] .* ys
    #Computation, Get the results
    res = @showprogress pmap((x, y) -> spectral_bulk(energy, Location(x, y), s), XS, YS)
    signal = reduce(vcat, res)
    final_signal = signal .- signal[1]

    x_positions2 = map(y -> y.loc.v1, POTENTIAL)
    y_positions2 = map(y -> y.loc.v2, POTENTIAL)

    X_LP = d1[1] .* x_positions2 + d2[1] .* y_positions2
    Y_LP = d1[2] .* x_positions2 + d2[2] .* y_positions2

    check_pos = all(>=(0), final_signal)

    if check_pos
        println("Findmax")
        color_lim = -findmax(final_signal)[1]
    else
        println("Findmin")
        color_lim = findmin(final_signal)[1]
    end

    fig = Figure(resolution = (1800, 1800))
    ax =
        fig[1, 1] = Axis(
            fig,
            xlabel = "x/nm",
            ylabel = "y/nm",
            xlabelpadding = 0,
            ylabelpadding = 0,
            xlabelsize = 30,
            ylabelsize = 30,
            title = "FO map at $energy eV",
            titlefont = "LibreBaskerville-Regular.ttf",
            titlesize = 40,
            xticklabelsize = 20,
            yticklabelsize = 20,
            aspect = DataAspect(),
            xticklabelfont = "LibreBaskerville-Regular.ttf",
            yticklabelfont = "LibreBaskerville-Regular.ttf",
            xlabelfont = "LibreBaskerville-Italic.ttf",
            ylabelfont = "LibreBaskerville-Italic.ttf",
        )


    sc = CairoMakie.scatter!(
        ax,
        X .* a0 / 10,
        Y .* a0 / 10,
        color = final_signal,
        strokewidth = 0,
        # marker = '◼',
        marker = :hexagon,
        # markersize = 7.1,
        markersize = 44,
        colormap = :bwr,
        colorrange = (color_lim, -color_lim),
    )

    sc = CairoMakie.scatter!(
        ax,
        X_LP .* a0 / 10,
        Y_LP .* a0 / 10,
        marker = :x,
        # markersize = 5,
        markersize = 34,
        color = :black ,
        strokewidth = 0.4,
    )
    name = lpad(Int(energy * 1000),4, '0')

    tightlimits!(ax)
    CairoMakie.xlims!(ax, [-10, 10])
    CairoMakie.ylims!(ax, [-10, 10])
    save("$name map.png", fig)
    # fig

end


## Series of figures
for ii in range(0.0, 0.45, step = 0.005)
    plotter_func(ii)
end
