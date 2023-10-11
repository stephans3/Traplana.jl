using Traplana
using Documenter

DocMeta.setdocmeta!(Traplana, :DocTestSetup, :(using Traplana); recursive=true)

makedocs(;
    modules=[Traplana],
    authors="Stephan Scholz",
    repo="https://github.com/stephans3/Traplana.jl/blob/{commit}{path}#{line}",
    sitename="Traplana.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://stephans3.github.io/Traplana.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/stephans3/Traplana.jl",
    devbranch="main",
)
