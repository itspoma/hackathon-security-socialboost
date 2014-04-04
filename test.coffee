square = (x) -> x * x
cube   = (x) -> square(x) * x

fill = (container, liquid = "coffee") ->
  "Filling the #{container} with #{liquid}..."

song = ["do", "re", "mi", "fa", "so"]

singers = {Jagger: "Rock", Elvis: "Roll"}

kids =
  brother:
    name: "Max"
    age:  11
  sister:
    name: "Ida"
    age:  9

a = 1

func = (x) -> x * 2

console.log func(a)