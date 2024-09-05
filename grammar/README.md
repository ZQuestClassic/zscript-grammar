# Grammar

This folder contains the
[Parsing Expression Grammar](https://en.wikipedia.org/wiki/Parsing_expression_grammar)
for the ZScript programming language.

## Build

The grammar is validated and tested using the
[`peg` parser generator](http://piumarta.com/software/peg/)
and any C compiler. Known to work C compilers include:

 * GCC >= 7.4.0

Typing `make` in this folder will create a `build` directory containing the
source files generated from `peg` and two executables, which can both parse ZScript
source code.

* The `parser` executable will parse content from stdin. It exits with the
  status code `1` if the input is not valid ZScript.
* `parser_debug` does the same as `parser` but also prints to stderr which
  rules are taken during parsing.

## Test

The `check_parser.sh` script can be used to check the generated parser against
the zscript compiler. If no arguments are given, it checks the parser against every file
in `grammar/tests`. Otherwise it will use the list of files given as arguments. It outputs the
filenames of the files for which success/failure for the generated parser and the compiler differ.
Note that it does *not* check whether the parse trees are isomorphic or that they fail to parse
with the same error; it only checks that either both fail to parse a file or both succeed.

Note: Set the ZSCRIPT environment variable to the path to your zscript compiler, otherwise it will
use the `zscript` in your `$PATH`.

Example usages:

- `ZSCRIPT=/path/to/zscript ./check_parser.sh` (but just set `ZSCRIPT` in your shell profile)
- `./test.sh` runs `check_parser.sh` on everything in `tests/`
- `./check_parser.sh myfile1.zs myfile2.zs`
- `./check_parser.sh ~/code/zscript-database/**/*.zs`
- `rm -rf build && make && build/parser < tests/kitchen_sink.zs` quick way to validate when editing grammar
