#lang brag

bf-program : (bf-op | bf-loop)*
bf-op      : "fwd" | "rwd" | "fwd" INTEGER | "rwd" INTEGER | "inc" | "inc" INTEGER | "dec" | "dec" INTEGER | "write" | "read"
bf-loop    : "begin" (bf-op | bf-loop)* "end"
