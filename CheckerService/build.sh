ghc --version
ghc src/Main.hs -o CheckerService -isrc -O2 -fdiagnostics-color=always -Wdeprecations # -Wall
read -p "Press any key to continue"