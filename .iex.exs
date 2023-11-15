IEx.configure(
  colors: [
    enabled: true,
    eval_result: [ :cyan, :bright ],
    eval_error:  [ :light_red ],
  ],
  default_prompt: [
    "\r\e[0;0;0m",            # white
    "%prefix",                # IEx context
    "\e[38;5;112m(%counter)", # forest green expression count
    "\e[;0;0m>",              # white ">"
    "\e[0m",                  # and reset to default color
  ] 
  |> IO.chardata_to_string    # (1)
)