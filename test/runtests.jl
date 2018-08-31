using Variography
using GeoStatsDevTools
using GeoStatsImages
using LinearAlgebra
using Plots; gr(size=(600,400))
using VisualRegressionTests
using Test, Pkg

# list of maintainers
maintainers = ["juliohm"]

# environment settings
istravis = "TRAVIS" ∈ keys(ENV)
ismaintainer = "USER" ∈ keys(ENV) && ENV["USER"] ∈ maintainers
datadir = joinpath(@__DIR__,"data")

if ismaintainer
  Pkg.add("Gtk")
  using Gtk
end

# simple data sets
psetdata2D = PointSetData(Dict(:z => [1.,0.,1.]), [25. 50. 75.; 25. 75. 50.])
geodf2D = readgeotable(joinpath(datadir,"samples2D.tsv"), delim='\t', coordnames=[:x,:y])

# empirical variograms
TI = training_image("WalkerLake")[1:20,1:20,1]
xwalker = Float64[i for i=1:20 for j=1:20]
ywalker = Float64[j for i=1:20 for j=1:20]
zwalker = Float64[TI[i,j] for i=1:20 for j=1:20]
γwalker = EmpiricalVariogram(hcat(xwalker,ywalker)', zwalker, maxlag=15.)

# list of tests
testfiles = [
  "empirical_variograms.jl",
  "theoretical_variograms.jl",
  "pairwise.jl",
  "fitting.jl",
  "plotrecipes.jl"
]

@testset "Variography.jl" begin
  for testfile in testfiles
    include(testfile)
  end
end
