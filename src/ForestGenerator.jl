module ForestGenerator
export rPois, generateTrees, treePositions, rWeibull, treeDiameters, treeHeights
# This script is a module that contains all functions for generating a forest of trees.
using Random
using Distributions
function rPois(λ::Union{Int64, Float64})
    # Generate a random number from a Poisson distribution
    # λ: the rate of the Poisson process
    # return: a random number from a Poisson distribution
    return Random.rand(Distributions.Poisson(λ))
end


# The function rPois generates a random number from a Poisson distribution with the rate λ.
function generateTrees(λ::Union{Int64, Float64},  area::Tuple{Union{Int64, Float64}, Union{Int64, Float64}})
    # Generate a forest of trees
    # λ: the rate of the Poisson process
    # area: the area of the forest
    # return: a list of trees

    trees = rPois(λ*area[1]*area[2])
    return trees
end

function treePositions(trees::Int64, area::Tuple{Union{Int64, Float64}, Union{Int64, Float64}}, exclusionRadius::Union{Int64, Float64})
    # Generate the positions of trees in the forest
    # trees: the number of trees
    # area: the area of the forest
    # return: a list of tree positions

    x = rand(Uniform(0, area[1]), trees)
    y = rand(Uniform(0, area[2]), trees)

    #compute the distance between trees and make new coordinates if too close
    #additionally, check if new coordinates are too close or not, if not, repeat the process
    #have a breaking condition if the process is repeated too many times (500)
    breaking = 0
    for i in 1:trees
        for j in 1:trees
            if i != j
                distance = sqrt((x[i] - x[j])^2 + (y[i] - y[j])^2)
                while (breaking < 500) & (distance < exclusionRadius)  
                    x[i] = rand(Uniform(0, area[1]))
                    y[i] = rand(Uniform(0, area[2]))
                    distance = sqrt((x[i] - x[j])^2 + (y[i] - y[j])^2)
                    breaking += 1
                end
                if breaking == 500
                    println("Breaking condition reached, reduce lambda, trying to generate too many trees")
                    break
                end
            end
        end
    end
    breaking = 0
    return (x, y)
end

function rWeibull(α::Union{Int64, Float64}, β::Union{Int64, Float64}, n::Int64)
    # Generate a random number from a Weibull distribution
    # α: the shape parameter
    # β: the scale parameter
    # return: a random number from a Weibull distribution
    return rand(Weibull(α, β), n)
end

function treeDiameters(trees::Int64, α::Union{Int64, Float64}, β::Union{Int64, Float64})
    # Generate the diameters of trees in the forest
    # return: a list of tree diameters
    diameters = rWeibull(α, β, trees)
    return diameters
end

function treeHeights(diameters::Vector{Float64}, relationship::Function)
    # Generate the heights of trees in the forest
    # return: a list of tree heights
    heights = relationship.(diameters)
    return heights

end

end