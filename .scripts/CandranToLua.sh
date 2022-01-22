#!/bin/bash
### Compile *.can files to *.lua files and format them


canc -t "lua52" --indentation "	" models/free-market.can -D DEBUG true -o models/free-market-debug.lua
canc -t "lua52" --indentation "	" models/free-market.can -o models/free-market.lua
