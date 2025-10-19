// VGA image generator

module vga(clock, hsync, vsync, r, g, b);
   input wire clock;
   output reg hsync;
   output reg vsync;
   output reg r;
   output reg g;
   output reg b;

   reg [11:0]  Time;
   reg [9:0]   Xpos;
   reg [8:0]   Ypos;
   reg [9:0]   Xfwd;
   reg [8:0]   Yfwd;
   reg [9:0]   Xrev;
   reg [8:0]   Yrev;
   
   reg         Hpos, Vpos;
   wire        Xmax = (Xpos == 800);
   
   always @(posedge clock)
     begin
        if (Xmax)
          begin
             Xpos <= 0;
             Ypos <= Ypos + 1;
          end
        else
          Xpos <= Xpos + 1;
     end

   always @(posedge clock)
     begin
        Hpos <= ~(Xpos > 656 && Xpos < 752);
        Vpos <= ~(Ypos >= 490 && Ypos < 492);
     end

   always @(negedge Vpos)
     begin
        Time <= Time + 1;
     end

   always @(posedge clock)
     begin
        Xfwd <= (Xpos + Time);
        Yfwd <= (Ypos + Time);
        Xrev <= (Xpos - Time);
        Yrev <= (Ypos - Time);

        vsync <= ~Vpos;
        hsync <= ~Hpos;
     end

   always @(posedge clock)
     begin
        r <= (Yfwd < 128 || Yfwd > 256) ^ (Xrev < 128 || Xrev > 256);
   
        g <= Xfwd[3] ^ Yfwd[3];
   
        b <= (Yrev[6] ^ Xrev[6]) | g;
     end


endmodule
