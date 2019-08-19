
# SYSTEM INFO:
julia> versioninfo()
Julia Version 1.1.0
Commit 80516ca202 (2019-01-21 21:24 UTC)
Platform Info:
  OS: Windows (x86_64-w64-mingw32)
  CPU: Intel(R) Core(TM) i7-6600U CPU @ 2.60GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.1 (ORCJIT, skylake)

# colored bar chart:
bar(rand(10); fillcolor = 1:10)

# to update package AND Toml
] free <package>
] update <package>


# CREATING CODE FROM A STRING
"""
The built-in function Meta.parse takes a string and
transforms it into an expression. This expression
can be evaluated in Julia with the function Core.eval.
For example:
"""
julia> expr = Meta.parse("1+2*3")
:(1 + 2 * 3)
julia> eval(expr)
7
julia> expr = Meta.parse("sqrt(π)")
:(sqrt(π))
julia> eval(expr)
1.7724538509055159


# MULTICORE PARALLEL example, 1=head, 0=tail
# How many cores do we have>
Sys.CPU_THREADS

using Distributed
heads = @distributed (+) for i=1:200000000
  Int(floor(rand()+0.5))
end
print(heads,"\n")

# Calling a c lib function
#using Distributed already called
#t1=ccall((:clock, "libc"), UInt32,())
@time heads = @distributed (+) for i=1:200000000
  Int(floor(rand()+0.5))
end
print(heads,"\n")
#t2=ccall((:clock, "libc"), UInt32,())
#print((t2-t1)/1000000.," seconds\n")
# Don't need the C clock function since Julia has a
# @time macro and other timing operations.

# UNICODE characters in strings and formulas
s="abπ∑ef\n"
print(s)
ß=2π/3

function Σ(x)  # yes, function names can use UTF-8 chars
    s=0
    for i=1:length(x)
        s+=x[i]
    end
    return s
end

x=1:100
println(Σ(x))

x=[1.0 2; 3 4]
println(Σ(x))
# the base function sum() does nearly the same thing so
# could have written Σ()=sum()

# With LaTeXStrings you can use
L"y = 0.19^{+1.10}_{-1.05}"

# FWIW, you can definitely use latexstrings in IJulia with no TeX installation
# I think it uses MathJax (https://www.mathjax.org/).

# plotting unicode with GR (not working?)
ENV["GKS_ENCODING"] = "utf-8"

# OS UTILITIES & COMMANDS using run() and read()
pwd()
run(`echo hello`)  # note (`) is a backtick`
files=String(read(`ls`))
files=split(files,"\n")
println(files)

# COMPlEX floating-point numbers
x=2.1+3.2im

# SWAP TWO NUMBERS: Don't need swap macro
a,b=b,a

# checking approx. equality function:
isapprox(3.0, 3.01, rtol=0.1)

# COMPARISON OPERATORS
a = 2
b = 3
c = 3
@show(a < c && b < c)  # then and operator
@show(a < c || b < c)  # the or operator
@show(a != b) ; # not equal

# DICE ROLLS
rand(1:5) # Create a DISCRETE RANDOM DRAW from 1-5

# argmin function:
A = [3 5 2 1 6]
min_loc = argmin(A)
A[min_loc]

## FILTERING: A few ways to filter a variable:
a = [1,2,3,5,1,6]

#Higher-order filtering

z = filter(x -> x > 4, a)
@show(z)

# This calls the filter function with the predicate x -> x > 4 (see Anonymous functions in the Julia manual).
#  Broadcasting and indexing

z2 = a[Bool[a[i] > 4 for i = 1:length(a)]]
@show(z2)

# This performs a broadcasting comparision between the 
# elements of a and 4, then uses the resulting array of 
# booleans to index a. 

# It can be written more compactly using a broadcasting 
# operator:

z3 = a[a .> 4]
@show(z3)


## METAPROGRAMMING machinery exposed to the user in Julia
# eval(), Expr(), parse(), Symbol(), typeof(), Regex()

# always check what Julia has to offer before rolling
# your own functions, macros and extensions.


# GETTING USER RESPONSE TO TEXT
println("Who are you?")
s=readline()
println("Hello $s and Hello World!")

# Works much better in a function
# as a function:
function whoru()
	println("Who are you?")
	s=readline()
	println("Hello $s and Hello World!")
end


# USE OF DICTIONARY example
# Bad name dictionary can be as big as one wants
# and severity of baddness can be designated by the number
badnames=Dict("Dope" => 1, "Knothead" => 1,"Stupid" => 1)
# The bot wants a name
println("Please give me a name for I have none.")
name=readline()
# Is it a bad name or a good name
n=get(badnames,name,0)
if n==0
    println("$name is nice, I will take it." )
else
    println("I think that's not a very nice name.")
    name="Sky"  #could use a random name selector here
    println("I chose the name $name for myself.")
    println("$name is a strong name and I like it.")
end

# PLOTTING A BAR GRAPH of a dictionary
c = Dict(1 => 7, 2 => 5, 3 => 2, 4 => 14, 5 => 22)
@show(cx = collect(keys(c)));
@show(cy = collect(values(c)));
plot(cx, cy, st=:bar, bar_width=0.3, label="",size=(300,200), color=1:5)

# with string keys
cs = Dict("awful" => 7, "bad" => 5, "so so" => 2, "good" => 14, "great" => 22)
@show(cx = collect(keys(cs)));
@show(cy = collect(values(cs)));
plot(cx, cy, st=:bar, bar_width=0.3, label="",size=(300,200),color = 1:5)

# SORTPERM to order an array
# define dictionary c with numbers as above
c = Dict(1 => 7, 2 => 5, 3 => 2, 4 => 14, 5 => 22)
cx = collect(keys(c)));
cy = collect(values(c));
@show(zz = [cx cy])
@show(z = zz[sortperm(zz[:, 1]), :])  # sort the array zz by column 1
# BAR PLOT of the dictionary
plot(z[:,1], z[:,2], st=:bar, bar_width=0.3, label="", color = 1:5, title= "strings", 
			xticks = (z[:,1],["awful", "bad", "so so", "good", "great"]), size = (300,200))

# STRING TO FLOAT CONVERSION
st=readline();       #Arg STDIN assumed if left out
t=parse(Float32,st)  #string to Float32 conversion

# SPLITTING/FORMATTING PRINT statement
depthu = 10; tu = 2
println("depth $depthu meters \nsound time $tu seconds")

# GLM and DATAFRAMES
# GLM Generalized Linear Model
#Pkg.add("Gadfly")
#using Gadfly
#Pkg.add("DataFrames")
#Pkg.add("GLM")

# Gadfly is similar to ggplot - based on the "grammar of graphics"
using Gadfly
using DataFrames, GLM

## COMPREHENSIONS
[f(x) for i in 1:n]

# Some alternatives for bigger, multiline "comprehension":
# You can use map
map(1:n) do x
    blah
    blah
    blah
    f(x)
end

# You can use begin end expression
[   begin
               y = x + 1
               y^2
           end
           for x = 1 : 5 ]
5-element Array{Int64,1}:
  4
  9
 16
 25
 36


data=DataFrame(x=[0.9,2.0,3.0],y=[2.0,4.0,6.5])
ols=glm(@formula(y ~ x), data, Normal(), IdentityLink())
c=coef(ols)
#  y=c[1]+c[2]*x
#  y=-0.0370091 + 2.13746*x
plot(data,x=:x,y=:y,Geom.point,intercept=[c[1]],slope=[c[2]],Geom.abline(color="red",style=:dash))


using GLM, DataFrames
data = DataFrame(x1=[0.9,2.0,3.0,3.9],x2=[0.291,0.210,0.105,0.021],y=[2.0,4.0,6.5,7.9])
reg = glm(@formula(y ~ x1 + x2), data, Normal(), IdentityLink())
@show(coef(reg))
stderror(reg)
predict(reg)



