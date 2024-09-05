find tests \( -name '*.zh' -o -name '*.zs' \) -exec sh -c 'echo === {} ; build/parser < {}' \;
