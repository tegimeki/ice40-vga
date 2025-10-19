// VGA display

module top(clock, led0, hsync, vsync, red, green, blue);
   input wire  clock;

   output reg  led0;
   output reg       hsync;
   output reg       vsync;
   output reg       red;
   output reg       green;
   output reg       blue;

   reg [23:0]       div = 0;

   wire             pclk;
   wire             locked;

   pll pclk_pll (.clock_in(clock), .clock_out(pclk), .locked(locked));

   always @(posedge pclk)
     begin
        div <= div + 1;
        led0 <= div[23];
     end

   vga display(.clock(pclk),
               .hsync(hsync),
               .vsync(vsync),
               .r(red),
               .g(green),
               .b(blue));
    
endmodule
