# The CIEDE2000 (ΔE00) Color Difference Formula
[Read more about the formula.](https://github.com/michel-leonard/ciede2000-color-matching/tree/main)

## Usage
1. Clone the repository
2. Install and setup [dune](https://dune.readthedocs.io/en/latest/quick-start.html)
3. Run the project using `$ dune exec ciede-2000-ocaml`

> [!Note]
> `$ dune exec ciede-2000-ocaml` will only display a help message.
> 
> To test the function itself, use `$ dune exec ciede-2000-ocaml -- -test <input_file> <output_file>`.
> Input file is a csv file with 6 (or optionally 7) columns and it can be generated using [this](https://michel-leonard.github.io/ciede2000-color-matching/#generate).
> Output file can be validated using [this](https://michel-leonard.github.io/ciede2000-color-matching/#validate).
