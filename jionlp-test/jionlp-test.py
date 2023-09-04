import jionlp as jio

text = '我就在家里'
res = jio.parse_location(text, town_village=True)
print(res)
