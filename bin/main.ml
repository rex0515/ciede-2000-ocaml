open Ciede_2000_ocaml.Ciede2000

let usage_msg = "ciede2000ocaml [-test] <input> <output>"

let is_test = ref false
let input_file = ref ""
let output_file = ref ""

let anon_fun filename =
  if !input_file = "" then
    input_file := filename
  else if !output_file = "" then
    output_file := filename
  else
    raise (Failure (Printf.sprintf "(%s, %s, %s) %s" !input_file !output_file filename "More than 2 anonymous arguments were passed"))

let speclist =[
  ("-test", Arg.Set is_test, "Test the ciede_2000 function");
]

let process in_f out_f=
  let apply a b = a b in
  let uncurry f (a, b) = f a b in

  let load_data fname =
    let ic = open_in fname in
      List.map
        (fun el ->
          List.map (float_of_string) (String.split_on_char ',' el)
        ) (In_channel.input_lines ic)
  in

  let lab_of_nums l a b =
    ColorspaceLAB.{l = l; a = a; b = b}
  in
  let line_of_labs line =
    (
      lab_of_nums (List.nth line 0) (List.nth line 1) (List.nth line 2),
      lab_of_nums (List.nth line 3) (List.nth line 4) (List.nth line 5)
    )
  in

  let data = load_data in_f in

  let parsed = List.map line_of_labs data in
  let results = List.map (uncurry ciede2000) parsed in

  let write_format =
    Printf.sprintf "%.20f,%.20f,%.20f,%.20f,%.20f,%.20f,%.20f%!"
  in

  let prepped = List.map (fun (a, b: (ColorspaceLAB.t * ColorspaceLAB.t)) -> write_format a.l a.a a.b b.l b.a b.b) parsed in
  let result_list = List.map2 apply prepped results in

  let processed = String.concat "\n" result_list in
  let oc = open_out out_f in
  Out_channel.output_string oc processed;
  List.length results

let () = 
  Arg.parse speclist anon_fun usage_msg;
  if (not !is_test) || !input_file = "" || !output_file = "" then
    Arg.usage speclist usage_msg
  else (
    let n_processed = process !input_file !output_file in
    Printf.printf "Processed %i color pairs from, %s.\nResults are written to %s" n_processed !input_file !output_file
  )