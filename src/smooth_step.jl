"""
    cos_step(t;p=1, center=true)

Cosine-based step function

```math
f(t) = (1-\\cos(\\pi~p~t))
```

- Time `t \\in [0,1]`
- Parameter `p` sets steepness. Choose `p=1` or `p>1`.

If `p>1` then the step function is centered to have `f(0.5)=0.5`.
To avoid this choose `center=false`.

# Examples

```
julia> cos_step(0.5)
0.5

julia> cos_step(0.4;p=2)
0.2061073738537635

julia> cos_step(0.4;p=2, center=false)
0.9045084971874737
```
"""
function cos_step(t;p=1, center=true)
    if center
        t = t - (p-1)/2p
        if t < 0
            return 0
        elseif t > 1/p
            return 1
        else
            return _cos_step(t,p=p)
        end
    else
        return t<1/p ? _cos_step(t;p=p)  : 1
    end
end

function _cos_step(t;p)
    return (1-cospi(p*t))/2
end



"""
    cos_step_der(t,n :: Integer;p=1, center=true)

Derivatives of cosine-based step function.

- Number of derivatives `n`, must be an `Integer`. 

# Examples

```
julia> cos_step_der(0.1,3;p=2, center=false)
3-element Vector{Float64}:
1.8465818304904567
15.96935537647813
-72.90012864472101
```
"""
function cos_step_der(t,n :: Integer;p=1, center=true)
    if center
        t = t - (p-1)/2p
        return (0 <= t <= 1/p) ? _cos_step_der(t,n;p=p)  : zeros(n)
    else
        return t<(1/p) ? _cos_step_der(t,n;p=p) : zeros(n)
    end
end

function _cos_step_der(t,n::Int64; p)
    return map(m-> (-1)^(m+1)*(p*π)^m * cospi(p*t-m/2)/2, 1:n)
end



"""
    tanh_step(t;p=5)

Tanh-based step function

```math
f(t) = (1 + \\tanh(p~(t - 0.5)))/2
```

- Time `t \\in [0,1]`
- Parameter `p` sets steepness.

Initial and terminal value `f(0)=0` and `f(1)=1` are approached, and can not be reached exactly.
To reach `f(1)>0.99` choose parameter `p>4.6`.  

# Examples

```
julia> tanh_step(0.5)
0.5

julia> tanh_step(0.4;p=10)
0.11920292202211757
```
"""
function tanh_step(t;p=5)
    return (1+tanh(p*(t-0.5)))/2
end


#=
    Eulerian number / Eulerian triangle
    see also: https://en.wikipedia.org/wiki/Eulerian_number
=#
"""
    eulerian_triangle(n::Int64, k::Int64)

    Computes the Eulerian number of the Eulerian triangle.

    See also: https://en.wikipedia.org/wiki/Eulerian_number
"""
function eulerian_triangle(n::Int64, k::Int64)
    igrid = 0 : 1 : k
    a_int(i) = (-1)^(i) * big(binomial(n+1,i))*(big(k+1-i))^n
    return mapreduce( i -> a_int(i), +, igrid)
end


#=
Compute n-th order derivative of tanh(a*t)
- time t
- constant parameter a
- order of differentiation n
=#




function _tanh_step_der(t,n::Integer;p)

    τ = p*(t-0.5)
    c1 = 2^(n+1) * exp(2τ) / (1 + exp(2τ))^(n+1)

    kgrid = 0:1:n-1
    c2 = mapreduce(k-> (-1)^k * eulerian_triangle(n,k)*exp(2k*τ),+,kgrid)

    return p^n * c1*c2/2
end 




"""
    tanh_step_der(t,n :: Integer;p=1)

Derivatives of tanh-based step function.

- Number of derivatives `n`, must be an `Integer`. 

# Examples

```
julia> tanh_step_der(0.1,3;p=10)
3-element Vector{BigFloat}:
 0.00670475341512948540267924357749507180415093898773193359375
 0.1340051307052893501270622106185563061489978404668007613377242087398415800597595
 2.676506919848872478504524070795339666523688433093212247964472721213141447181446
```
"""
function tanh_step_der(t,n::Integer;p=5)
    return map(m-> _tanh_step_der(t,m;p=p), 1:n)
end 




function smooth_poly(t, c_fun :: Vector{<: Real})
    n = length(c_fun)
    return mapreduce(k-> c_fun[k]*t^(2n-k),+,1:n) / sum(c_fun)
end


function smooth_poly_grad(t, c_fun :: Vector{<: Real}, c_grad :: Matrix{<: Real})
    n = length(c_fun)
    c_sum = sum(c_fun)

    f_grad = zeros(typeof(t),n)
    idx=1
    for row in eachrow(c_grad)
        f_grad[idx] = mapreduce(k -> row[k]*t^(2n-k-idx),+,1:n) / c_sum
        idx += 1;
    end
    return f_grad;
end




#=
    f(t) = (t² - t)^n_ord
=#
function poly_coefficients(n_ord :: Integer)

    T = typeof(n_ord)
    c_fun = zeros(Rational{T}, n_ord+1) # Coefficients of original function
    c_grad = zeros(T,n_ord+1, n_ord+1)  # Coefficients of derivatives
    for n in range(0,n_ord)
        c_fun[n+1] = (-1)^n * binomial(n_ord,n)//(2n_ord-n+1)
        for i in range(0,n_ord)
            c_grad[i+1,n+1] =  (-1)^n * binomial(n_ord,n) * factorial(2n_ord-n)//factorial(2n_ord-n-i)
        end

    end

    return c_fun, c_grad
end
