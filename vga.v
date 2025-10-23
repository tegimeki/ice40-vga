// VGA image generator

module vga(clock, button, hsync, vsync, r, g, b);
   input wire clock;
   input wire button;

   output reg hsync;
   output reg vsync;
   output reg [3:0] r;
   output reg [3:0] g;
   output reg [3:0] b;

   reg [11:0]  Frame;
   reg [9:0]   Xpos;
   reg [8:0]   Ypos;
   
   reg         Hpos, Vpos;
   wire        Xmax = (Xpos == 800);
   wire [10:0] Ex = 320;
   wire [10:0] Ey = 240;
   wire [10:0] Dx = Xpos <= Ex ? Ex - Xpos : Xpos - Ex;
   wire [10:0] Dy = Ypos <= Ey ? Ey - Ypos : Ypos - Ey;
   wire [11:0] Dm = (Dx + Dy);
   wire [14:0] D = button ? (Dm << Dm[6:5]) - Frame : (Dm >> Dm[4:3]) - Frame;

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
        Frame <= Frame + 1;
     end

   always @(posedge clock)
     begin
        vsync <= ~Vpos;
        hsync <= ~Hpos;
     end

   always @(posedge clock)
     begin
        r[3:0] <= (vsync|hsync) ? 0 : (D[7:4]);
        g[3:0] <= (vsync|hsync) ? 0 : (D[6:3]);
        b[3:0] <= (vsync|hsync) ? 0 : (D[5:2]);
     end


endmodule
