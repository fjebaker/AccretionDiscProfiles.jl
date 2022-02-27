module AccretionDiscProfiles

using Parameters

import StaticArrays: @SVector

# this should be an optional dependency
# as should CarterBoyerLindquist
using ComputedGeodesicEquations

import GeodesicBase: AbstractMetricParams
import GeodesicTracer: tracegeodesics
import AccretionGeometry


abstract type AbstractCoronaModel{T} end

sample_position(m::AbstractMetricParams{T}, model::AbstractCoronaModel{T}, N) where {T} = error("Not implemented for $(typeof(model)).")
sample_random_direction(m::AbstractMetricParams{T}, model::AbstractCoronaModel{T}, us, N) where {T} = error("Not implemented for $(typeof(model)).") 
sample_even_direction(m::AbstractMetricParams{T}, model::AbstractCoronaModel{T}, us, N) where {T} = error("Not implemented for $(typeof(model)).") 

function tracegeodesics(
    m::AbstractMetricParams{T},
    model::AbstractCoronaModel{T},
    time_domain::Tuple{T,T};
    n_samples=1024,
    kwargs...
) where {T}
    us = sample_position(m, model, n_samples)
    vs = sample_random_direction(m, model, n_samples, us)
    tracegeodesics(m, us, vs, time_domain; kwargs...)
end

function renderprofile(
    m::AbstractMetricParams{T},
    model::AbstractCoronaModel{T},
    max_time::T;
    N=2048,
    kwargs...
)

end

include("sky-geometry.jl")
include("corona-models.jl")

export AbstractCoronaModel, tracegeodesics, renderprofile


end # module
