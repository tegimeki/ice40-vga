// VGA image generator

module vga(clock, hsync, vsync, r, g, b);
   input wire clock;
   output reg hsync;
   output reg vsync;
   output reg r;
   output reg g;
   output reg b;

   reg [10:0]  Time;
   reg [9:0]   Xpos;
   reg [8:0]   Ypos;
   reg         Hpos, Vpos;
   wire        Xmax = (Xpos == 800);
   
   always @(posedge clock)
     begin
        if (Xmax)
          Xpos <= 0;
        else
          Xpos <= Xpos + 1;
     end

   always @(posedge clock)
     begin
        if (Xmax)
          Ypos <= Ypos + 1;
     end

   always @(posedge clock)
     begin
        Hpos <= Xpos > 656 && Xpos < 752;
        Vpos <= Ypos >= 490 && Ypos < 492;
     end

   always @(negedge Vpos)
     begin
        Time <= Time + 1;
     end

   assign vsync = ~Hpos;
   assign hsync = ~Vpos;

   assign r = Ypos > 50 && ((Xpos + 120 - Time[9:0]) < Ypos);
   assign g = (((Ypos * 3) / 2) - 200 + Time[9:1]) < Xpos;
   assign b = (((Xpos + Time[8:1]) >> 3) & 1) ^
              (((Ypos - Time[8:2]) >> 3) & 1) & ~r;

endmodule



module top(clock, leds, hsync, vsync, red, green, blue);
   input wire  clock;

   output reg [7:0] leds;
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
     end

   assign leds[0] = div[23];

   vga display(.clock(pclk),
               .hsync(hsync),
               .vsync(vsync),
               .r(red),
               .g(green),
               .b(blue));
    
endmodule
