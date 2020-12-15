using FLoops
using StaticArrays, StatsBase, Combinatorics


function birthday_problem_floop(t, ncores )

v = 0
  @floop ThreadedEx(basesize=t÷ncores) for _ in 1:t
       months =  @SVector [rand(1:12) for i in 1:20]
       counts =  @SVector [sum(months.==i) for i=1:12]
       success = sum(counts.==2) == 4  &&  sum(counts.==3)==4
       @reduce(v += success)           
  end
        
return v/t

end

 birthday_problem_floop(10_000_000,4)