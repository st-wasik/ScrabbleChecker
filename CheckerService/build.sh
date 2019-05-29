ghc --version
ghc src/Main.hs -o CheckerService -isrc -O2 -fdiagnostics-color=always -Wdeprecations # -Wall
sleep 5
#read -p "Press any key to continue"