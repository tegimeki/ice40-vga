# VGA image generator build

OUT = bin

$(OUT)/top.bin: $(OUT)/top.asc
	icepack $< $@

$(OUT)/top.asc: $(OUT)/top.json top.pcf
	nextpnr-ice40 --hx8k --package cb132 --pcf top.pcf --asc $@ --json $<

$(OUT)/top.json: top.v $(OUT)/pll.v
	yosys '-p synth_ice40 -top top -json $(OUT)/top.json' $^

$(OUT)/pll.v: $(OUT)
	icepll -i 100 -o 25.125 -f $@ -m

$(OUT):
	mkdir -p $@

flash: $(OUT)/top.bin
	iceprog $<

clean:
	@rm -rf $(OUT)
