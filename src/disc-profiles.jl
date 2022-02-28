

function __renderprofile(
    m::AbstractMetricParams{T},
    model::AbstractCoronaModel{T},
    d::AbstractAccretionGeometry{T}
    N, 
    time_domain;
    kwargs...
) where {T}
    # TODO
    error("Not implemented for $(typeof(d)).")
end


function __renderprofile(
    m::AbstractMetricParams{T},
    model::AbstractCoronaModel{T},
    d::GeometricThinDisc{T}
    N, 
    time_domain;
    kwargs...
) where {T}
    # TODO
    error("Not implemented for $(typeof(d)).")
end