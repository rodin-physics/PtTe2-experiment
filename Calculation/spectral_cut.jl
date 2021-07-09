using CairoMakie
using Distributed
using Distributions

proc_number = 4;

if nprocs() < proc_number
        addprocs(proc_number - nprocs())
end

@everywhere include("Calculation/calc_settings.jl")
# x-axis of dI/dV line plot in Bohr radii
X = d1[1] .* xs
## Plotting
#To plot simulated dI/dV line cut along with experimental data for charged SV
function spectral_cut()
        res = @showprogress pmap(x -> spectral_bulk(ω, Location(x, 0), s, xs)) #Computation, Get the results
        fig = Figure(resolution = (800, 300))
        ax = fig[1, 1] = Axis(
                fig,
                xlabel = "x/nm",
                ylabel = "Spectral function(A(x))",
                title = "Spectral cut",
                xlabelpadding = 0,
                ylabelpadding = 0,
                xlabelsize = 16,
                ylabelsize = 16,
                xticklabelsize = 14,
                yticklabelsize = 14,
                titlesize = 18,
                xticklabelfont = "serif-roman",
                yticklabelfont = "serif-roman",
                xlabelfont = "serif-italic",
                ylabelfont = "serif-roman",
        )
        qft_data = lines!(X_charged * a0 / 10, res, label = "A single local potential, ω = 0.60eV")
        axislegend()
        fig
end

@time spectral_cut()
