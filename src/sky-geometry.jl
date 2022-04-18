abstract type AbstractSkyDomain end

struct LowerHemisphere <: AbstractSkyDomain end
struct BothHemispheres <: AbstractSkyDomain end

abstract type AbstractDirectionSampler{AbstractSkyDomain} end

struct RandomSampler{D} <: AbstractDirectionSampler{D} 
    RandomSampler(domain::AbstractSkyDomain) = new{domain}()
    RandomSampler(;domain::AbstractSkyDomain=LowerHemisphere()) = new{typeof(domain)}()
end
struct EvenSampler{D} <: AbstractDirectionSampler{D} 
    EvenSampler(domain::AbstractSkyDomain) = new{domain}()
    EvenSampler(;domain::AbstractSkyDomain=LowerHemisphere()) = new{typeof(domain)}()
end
struct WeierstrassSampler{D} <: AbstractDirectionSampler{D}
    resolution::Float64
    WeierstrassSampler(res, domain::AbstractSkyDomain) = new{typeof(domain)}(res)
    WeierstrassSampler(;res=100.0, domain::AbstractSkyDomain=LowerHemisphere()) = WeierstrassSampler(res, domain)
end

sample_azimuth(sm::AbstractDirectionSampler{D}, i) where {D} = error("Not implemented for $(typeof(sm)).")
sample_elevation(sm::AbstractDirectionSampler{D}, i) where {D} = error("Not implemented for $(typeof(sm)).")
sample_angles(sm::AbstractDirectionSampler{D}, i, N) where {D} = (sample_elevation(sm, i/N), sample_azimuth(sm, i))

# even
sample_azimuth(::RandomSampler{D}, i) where {D} = rand(Float64) * 2π
sample_elevation(::RandomSampler{LowerHemisphere}, i) = acos(1 - rand(Float64))
sample_elevation(::RandomSampler{BothHemispheres}, i) = acos(1 - 2*rand(Float64))

# even
sample_azimuth(::EvenSampler{D}, i) where {D} = π * (1 + √5) * i
sample_elevation(::EvenSampler{LowerHemisphere}, i) = acos(1 - i)
sample_elevation(::EvenSampler{BothHemispheres}, i) = acos(1 - 2i)

# uniform
sample_azimuth(::WeierstrassSampler{D}, i) where {D} = π * (1 + √5) * i
sample_elevation(sm::WeierstrassSampler{LowerHemisphere}, i) = π - 2atan(√(sm.resolution/i))
function sample_elevation(sm::WeierstrassSampler{BothHemispheres}, i)
    ϕ = 2atan(√(sm.resolution/i))
    if iseven(i)
        ϕ
    else
        π - ϕ
    end
end
sample_angles(sm::WeierstrassSampler{D}, i, N) where {D} = (sample_elevation(sm, i), sample_azimuth(sm, i))


function convert_angles(a, r, θ, ϕ, θ_obs, ϕ_obs)
    ϕ̃ = ϕ - ϕ_obs
    R = sqrt(r^2 + a^2)
    o1 = r * R * sin(θ) * sin(θ_obs) * cos(ϕ̃) + R^2 * cos(θ) * cos(θ_obs)
    o2 = R * cos(θ) * sin(θ_obs) * cos(ϕ̃) - r * sin(θ) * cos(θ_obs)
    o3 = sin(θ_obs) * sin(ϕ̃) / sin(θ)
    sigma = r^2 + a^2 * cos(θ)^2
    -o1 / sigma, -o2 / sigma, o3 / R
end

function vector_to_local_sky(m::AbstractMetricParams{T}, u, θ, ϕ) where {T}
    error("Not implemented for $(typeof(m))")
end

function vector_to_local_sky(m::BoyerLindquist{T}, u, θ, ϕ) where {T}
    convert_angles(m.a, u[2], u[3], u[4], θ, ϕ)
end

export LowerHemisphere, BothHemispheres, RandomSampler, EvenSampler, WeierstrassSampler