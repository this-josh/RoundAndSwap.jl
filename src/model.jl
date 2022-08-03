
using JuMP

function successful(model::Model)
    acceptable_status = [OPTIMAL, LOCALLY_SOLVED, ALMOST_OPTIMAL, ALMOST_LOCALLY_SOLVED]
    return (termination_status(model) in acceptable_status) ? true : false
end

function fixed_variables(model::Model)
    return [var for var in values(model.obj_dict) if is_fixed(var)]
end

function unfix!(variable::VariableRef)
    try
        unfix(variable)
    catch e
        if !is_fixed(variable)
            @info  "$variable is not fixed"
        else
            throw(error(e))
        end
    end
	set_lower_bound(variable, 0)
	set_upper_bound(variable, 1)
end

function unfix!(swapper::Swappable)
    for var in swapper.consider_swapping
        unfix!(var)
    end
end
