cls
ghdl -a --ieee=synopsys --std=08 *.vhdl
pause
ghdl -e --ieee=synopsys --std=08 alutb --vcd=wave.vcd --stop-time=3000ns
pause
ghdl -r --ieee=synopsys --std=08 alutb --vcd=wave.vcd --stop-time=3000ns
pause
gtkwave wave.vcd