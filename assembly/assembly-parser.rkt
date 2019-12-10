#lang brag

assembly-program : (assembly-op)*
assembly-op      : "move" assembly-reg assembly-reg | "move" assembly-reg INTEGER | 
                    "load" assembly-reg INTEGER | "store" INTEGER assembly-reg | 
                    "add" assembly-reg assembly-reg | "sub" assembly-reg assembly-reg |
                    "inc" assembly-reg | "dec" assembly-reg |
                    "print" assembly-reg | "print" assembly-hidden-reg 
assembly-reg     : "br" | "cr" | "dr"
assembly-hidden-reg     : "br" | "cr" | "dr"
