#lang reader "assembly-reader.rkt"

move br 10
move cr 1
move dr 1

while
print cr
store 100 cr
add cr dr
load dr 100
wendy