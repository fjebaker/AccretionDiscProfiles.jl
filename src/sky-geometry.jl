
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