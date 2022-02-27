
function convert_angles(r, theta, phi, obstheta, obsphi)
    PHI = phi-obsphi
    R = sqrt(r^2 + 1.0^2)
    o1 = r * R * sin(theta) * sin(obstheta) * cos(PHI) + R^2 * cos(theta) * cos(obstheta)
    o2 = R * cos(theta) * sin(obstheta) * cos(PHI) - r * sin(theta) * cos(obstheta)
    o3 = sin(obstheta) * sin(PHI) / sin(theta)
    sigma = r^2 + 1.0^2 * cos(theta)^2
    -o1 / sigma, -o2 / sigma, o3 / R
end



function vector_to_local_sky(m::AbstractMetricParams{T}, u, θ, ϕ)
    error("Not implemented for $(typeof(m))")
end

function vector_to_local_sky(m::BoyerLindquist{T}, u, θ, ϕ)
    convert_angles(u[2], u[3], u[4], θ, ϕ)
end