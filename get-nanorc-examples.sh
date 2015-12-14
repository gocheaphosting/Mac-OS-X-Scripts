git clone https://github.com/tech4david/nano-highlight.git
cd nano-highlight/
make BSDREGEX=1 install
echo "include ~/.nano/syntax/ALL.nanorc" >> ~/.nanorc
