module AccretionDiscProfiles

using Parameters

import StaticArrays: @SVector

# this should be an optional dependency
# as should CarterBoyerLindquist
using ComputedGeodesicEquations

import GeodesicBase: AbstractMetricParams
import GeodesicTracer: tracegeodesics
import AccretionGeometry: AbstractAccretionGeometry, tracegeodesics


abstract type AbstractCoronaModel{T} end

sample_position(m::AbstractMetricParams{T}, model::AbstractCoronaModel{T}, N) where {T} = error("Not implemented for $(typeof(model)).")

function sample_random_direction(m::AbstractMetricParams{T}, model::AbstractCoronaModel{T}, us, N) where {T}
    map(1:N) do index
        ϕ = rand(T) * 2π
        θ = acos(1 - 2*rand(T))
        r, t, p = vector_to_local_sky(m, us[index], θ, ϕ)
        @SVector [T(0.0), r, t, p]
    end
end

function sample_even_direction(m::AbstractMetricParams{T}, model::AbstractCoronaModel{T}, us, N) where {T}
    map(1:N) do index
        θ = acos(1 - 2 * (index / N))
        # golden ratio
        ϕ = π * (1 + √5) * index
        r, t, p = vector_to_local_sky(m, us[index], θ, ϕ)
        @SVector [T(0.0), r, t, p]
    end
end

@inline function sample_velocity(m::AbstractMetricParams{T}, model::AbstractCoronaModel{T}, us, N; sampler) where {T}
    if sampler == :random
        sample_random_direction(m, model, us, N)
    elseif sampler == :even
        sample_even_direction(m, model, us, N)
    else
        error("Unknown sampling method $(sampler)")
    end
end

function tracegeodesics(
    m::AbstractMetricParams{T},
    model::AbstractCoronaModel{T},
    time_domain::Tuple{T,T};
    n_samples=1024,
    sampler=:even,
    kwargs...
) where {T}
    us = sample_position(m, model, n_samples)
    vs = sample_velocity(m, model, us, n_samples; sampler=sampler)
    tracegeodesics(m, us, vs, time_domain; kwargs...)
end


function tracegeodesics(
    m::AbstractMetricParams{T},
    model::AbstractCoronaModel{T},
    time_domain::Tuple{T,T},
    d::AbstractAccretionGeometry{T},
    ;
    n_samples=1024,
    sampler=:even,
    kwargs...
) where {T}
    us = sample_position(m, model, n_samples)
    vs = sample_velocity(m, model, us, n_samples; sampler=sampler)
    tracegeodesics(m, us, vs, time_domain, d; kwargs...)
end


function renderprofile(
    m::AbstractMetricParams{T},
    model::AbstractCoronaModel{T},
    max_time::T,
    d::AbstractAccretionGeometry{T}
    ;
    n_samples=2048,
    sampler=:even,
    kwargs...
) where {T}
    __renderprofile(m, model, d, n_samples, (0.0, max_time); kwargs...)
end


include("sky-geometry.jl")
include("corona-models.jl")

export AbstractCoronaModel, tracegeodesics, renderprofile

end # module
