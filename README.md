# ZScript

ZScript is the scripting language for ZQuest Classic. The ZScript compiler is implemented [here](https://github.com/ZQuestClassic/ZQuestClassic/tree/main/src/parser). The parser uses flex/bison and the codegen (to ZASM, the bytecode that runs in the game engine) is C++.

This repo has two things:

* `grammar/` contains a PEG ([Parsing expression grammar](https://en.wikipedia.org/wiki/Parsing_expression_grammar)) for ZScript, along with scripts to validate the PEG grammar with the real compiler.
* `zig/` contains a barely-baked reimplementation of the ZScript compiler in Zig. Currently it's barely more than a lexer.
