#test script of ForestGenerator_main.jl
include(joinpath(@__DIR__, "src", "ForestGenerator_main.jl"))
using Gadfly
using Cairo
using DataFrames
# Test the main function
λ = 0.01
area = (100, 100)
exclusionRadius = 5
α = 6
β = 33
relationship(x) = 2.5 * x +  25.9
positions, diameters, heights = main(λ, area, exclusionRadius, α, β, relationship)

df = DataFrame(x=positions[1], y=positions[2], diameter=diameters/2*2.54/100, height=heights)

# calculate Trees per hectare
trees_per_hectare = size(df)[1]

# calculmate Quadratic mean diameter
qmd = sqrt(sum(df.diameter .* 100 .^2)/trees_per_hectare)

# calculate Basal area
ba = sum(df.diameter  .^2 * pi / 4)

# calculate SDI (Stand Density Index)
sdi = trees_per_hectare*2.471 * (qmd/2.54 / 10)^-1.605


# Plot the forest
p = plot(df, x=:x, y=:y, size=:diameter, Geom.point,
Theme(default_color = colorant"brown", discrete_highlight_color = x -> "black",
highlight_width = 0.5mm),
 Scale.x_continuous(minvalue=0, maxvalue=area[1]), Scale.y_continuous(minvalue=0, maxvalue=area[2]),
  Scale.size_identity, Guide.xlabel("x"), Guide.ylabel("y"))
draw(PDF("tests/forest.pdf", 20inch, 20inch), p)

# plot the histogram of tree diameters
p = plot(df, x=:diameter, Geom.histogram(bincount=15),
Theme(default_color = colorant"brown", discrete_highlight_color = x -> "black",
highlight_width = 0.5mm),
Guide.xlabel("Diameter"), Guide.ylabel("Frequency"))
draw(PDF("tests/diameter.pdf", 6inch, 6inch), p)

# plot the histogram of tree heights
p = plot(df, x=:height, Geom.histogram(bincount=15),
Theme(default_color = colorant"brown", discrete_highlight_color = x -> "black",
highlight_width = 0.5mm),
Guide.xlabel("Height"), Guide.ylabel("Frequency"))
draw(PDF("tests/height.pdf", 6inch, 6inch), p)

