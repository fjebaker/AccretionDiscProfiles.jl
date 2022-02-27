
@with_kw struct LampPostModel{T} <: AbstractCoronaModel{T}
    @deftype T
    h = 5.0
    θ = 0.01
    ϕ = 0.0
end

function sample_position(::AbstractMetricParams{T}, model::LampPostModel{T}, us, N) where {T}
    u = @SVector [T(0.0), model.h, model.θ, model.ϕ]
    fill(u, n_samples)
end

function sample_even_direction(m::AbstractMetricParams{T}, ::LampPostModel{T}, us, N) where {T}
    map(range(N)) do index
        # uniform angle
        i = index / N
        ϕ = i * 2π
        θ = acos(1 - 2i)
        r, t, p = vector_to_local_sky(m, @view(us[i]), θ, ϕ)
        @SVector [T(0.0), r, t, p]
    end
end