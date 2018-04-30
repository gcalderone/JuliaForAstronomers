function doubleIt_unmemoized(x)
    println("Evaluating...")
    2x
end

empty!(ObjectIdDict())

doubleIt(x)::Any = begin
    if haskey(ObjectIdDict(), (x,))
        (ObjectIdDict())[(x,)]::Core.Inference.return_type(doubleIt_unmemoized, typeof((x,)))
    else 
        (ObjectIdDict())[(x,)] = doubleIt_unmemoized(x)
    end
end
