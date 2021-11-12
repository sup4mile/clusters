#IMPORTANT
#NOT WORKING YET, PLEASE LOOK OVER AND RUN COMMANDS MANUALLY

#For Linux

#1. Downloads recent version (Nov 2021) of Julia to working directory
wget https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.3-linux-x86_64.tar.gz
tar zxvf julia-1.6.3-linux-x86_64.tar.gz

#2. Removes current Julia
sudo apt remove julia

#THIS ONE IS ESPECIALLY DANGEROUS, PLEASE CONSULT THE INTERNET IF UNSURE
#3. Add PATH/TO/julia/bin to $PATH so that running Julia uses that one
#echo "PATH=$PATH:/usr/bin/julia/bin" >> ~/.bashrc