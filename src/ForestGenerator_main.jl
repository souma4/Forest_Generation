# This script is a main script for generating a forest of trees.
include("ForestGenerator.jl")

function main(λ, area, exclusionRadius, α, β, relationship)
    # Generate a forest of trees
    # λ: the rate of the Poisson process
    # area: the area of the forest
    # exclusionRadius: the minimum distance between trees
    # α: the shape parameter of the Weibull distribution
    # β: the scale parameter of the Weibull distribution
    # relationship: the relationship between tree height and diameter
    # return: a list of trees
    
    # Generate the number of trees
    trees = ForestGenerator.generateTrees(λ, area)
    
    # Generate the positions of trees
    positions = ForestGenerator.treePositions(trees, area, exclusionRadius)
    
    # Generate the diameters of trees
    diameters = ForestGenerator.treeDiameters(trees, α, β)
    
    # Generate the heights of trees
    heights = ForestGenerator.treeHeights(diameters, relationship)
    
    return (positions, diameters, heights)
end

