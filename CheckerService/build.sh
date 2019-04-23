ghc --version
ghc src/Main.hs -o CheckerService.app -isrc -O2 -fdiagnostics-color=always -Wdeprecations # -Wall
