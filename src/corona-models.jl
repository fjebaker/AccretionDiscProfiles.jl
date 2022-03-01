
@with_kw struct LampPostModel{T} <: AbstractCoronaModel{T}
    @deftype T
    h = 5.0
    θ = 0.01
    ϕ = 0.0
end

function sample_position(::AbstractMetricParams{T}, model::LampPostModel{T}, N) where {T}
    u = @SVector [T(0.0), model.h, model.θ, model.ϕ]
    fill(u, N)
end

function sample_random_direction(m::AbstractMetricParams{T}, ::LampPostModel{T}, us, N) where {T}
    map(1:N) do index
        ϕ = rand(T) * 2π
        θ = acos(1 - 2*rand(T))
        r, t, p = vector_to_local_sky(m, us[index], θ, ϕ)
        @SVector [T(0.0), r, t, p]
    end
end

function sample_even_direction(m::AbstractMetricParams{T}, ::LampPostModel{T}, us, N) where {T}
    map(1:N) do index
        θ = acos(1 - 2 * (index / N))
        # golden ratio
        ϕ = π * (1 + √5) * index
        r, t, p = vector_to_local_sky(m, us[index], θ, ϕ)
        @SVector [T(0.0), r, t, p]
    end
end

export LampPostModel