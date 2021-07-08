using CairoMakie
using Distributed
proc_number = 4;
if nprocs() < proc_number
        addprocs(proc_number - nprocs())
end
@everywhere include("Calculation/calc_settings.jl")
## Plotting
function spectral_map()
        ## Convert X and Y to Bohr radii. Reshape the arrays
        xs = reduce(vcat, XS)
        ys = reduce(vcat, YS)
        #x and y axis of the spectral map
        X = d1[1] .* xs + d2[1] .* ys
        Y = d1[2] .* xs + d2[2] .* ys

        res = @showprogress pmap((x, y) -> spectral_bulk(ω, Location(x, y), s), XS, YS) #Computation, Get the results
        signal = reduce(vcat, res)
        fig = Figure(resolution = (400, 400))
        ax =
                fig[1, 1] = Axis(
                        fig,
                        xlabel = "x/nm",
                        ylabel = "y/nm",
                        xlabelpadding = 0,
                        ylabelpadding = 0,
                        xlabelsize = 16,
                        ylabelsize = 16,
                        title = "FO map",
                        xticklabelsize = 14,
                        yticklabelsize = 14,
                        aspect = DataAspect(),
                        xticklabelfont = "serif-roman",
                        yticklabelfont = "serif-roman",
                        xlabelfont = "serif-italic",
                        ylabelfont = "serif-italic",
                )

        sc = CairoMakie.scatter!(
                ax,
                X .* a0 / 10,
                Y .* a0 / 10,
                color = signal,
                strokewidth = 0,
                marker = '◼',
                markersize = 40,
                colormap = :oslo,
        )
        clrbar = fig[1,2] = Colorbar(fig, colormap = :oslo)
        clrbar.height = Relative(1.25/2)
        fig
end

@time spectral_map()
