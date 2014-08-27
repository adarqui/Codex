radius = 100.0
pad = 0.15
shift n = n + (n * pad)
width = 25.0

ring color x y = move (shift x, -y) (outlined ({defaultLine | color <- color , width <- width}) (circle radius))

main =
 collage 1200 1000
  [
   ring blue 0 0,
   ring yellow radius radius,
   ring black (radius*2) 0,
   ring green (radius*3) radius,
   ring red (radius*4) 0
  ]
