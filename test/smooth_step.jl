#=
Requirements:
1. f(0) ≈ 0 & f(1) ≈ 1
2. f'(0) ≈ 0 & f'(0) ≈ 0

Optional:
f^(n)(0) ≈ 0 & f^(n)(0) ≈ 0 with n>1
=#


@testset "cos_step" begin
    for ps in 1:10
        @test cos_step(0;p=ps) == 0
        @test cos_step(1/2;p=ps) ≈ 0.5
        @test cos_step(1;p=ps) == 1

        @test cos_step(0;p=ps, center=false) == 0
        @test cos_step(1/(2ps);p=ps, center=false) == 0.5
        @test cos_step(1/ps;p=ps, center=false) == 1
    end
end 

@testset "cos_step_der" begin
    for ps in 1:10
        @test cos_step_der(0,1;p=ps)[1] == 0
        @test cos_step_der(1/2,1;p=ps)[1] ≈ ps*π/2
        @test cos_step_der(1,1;p=ps)[1] == 0

        @test cos_step_der(0,1;p=ps, center=false)[1] == 0
        @test cos_step_der(1/(2ps),1;p=ps, center=false)[1] == ps*π/2 
        @test cos_step_der(1/ps,1;p=ps, center=false)[1] == 0
    end
end 

@testset "tanh_step" begin
    for ps in 5:10
        @test tanh_step(0;p=ps) ≈ 0 atol=0.01
        @test tanh_step(1/2;p=ps) ≈ 0.5  atol=0.01
        @test tanh_step(1;p=ps) ≈ 1  atol=0.01
    end
end 


@testset "tanh_step" begin
    tanh_der_param(x,p) = p*(1 - tanh(p*(x-0.5))^2)/2

    for ps in 5:10
        @test tanh_step_der(0,1;p=ps)[1]   ≈ tanh_der_param(0,ps) atol=1e-5  # ≈ 0
        @test tanh_step_der(1/2,1;p=ps)[1] == ps/2 
        @test tanh_step_der(1,1;p=ps)[1]   ≈ tanh_der_param(1,ps) atol=1e-5 # ≈ 0
    end
end 


@testset "unit test" begin
    # Write your tests here.

end