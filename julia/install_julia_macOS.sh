#For macOS 10.9 and newer

#1. Install Julia as you would any other Mac software

#2. Add to PATH so that it can be run from command line (may not be necessary to run from cmd)
rm -f /usr/local/bin/julia
sudo ln -s /Applications/Julia-1.6.app/Contents/Resources/julia/bin/julia /usr/local/bin/julia

#Done, should now be able to run julia from command-line