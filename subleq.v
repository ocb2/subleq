module subleq(clock, address_read, address_write, data);
   input clock;
   output reg [7:0]  address_read;
   output reg [15:0] address_write; // low byte for address, high byte for value
   input [7:0]       data;

   reg [7:0]         p;
   reg [7:0]         q;
   reg [7:0]         destination;
         
   integer           counter = 0;

   always @(posedge clock)
     begin
        #1 assign address_read = counter;
        $display("core: read %h from %h", data, counter);
        #1 assign address_read = data;
        $display("core: read %h from %h (dereference p)", data, counter);
        #1 assign p = data;
           counter = counter + 1;

        #1 assign address_read = counter;
        $display("core: read %h from %h", data, counter);
        #1 assign address_read = data;
        $display("core: read %h from %h (dereference q)", data, counter);
        #1 assign q = data;
           counter = counter + 1;

        #1 assign address_read = counter;
        $display("core: read %h from %h (d)", data, counter);
        #1 destination = data;
           counter = counter + 1;

        $display("core: p - q = ", p - q);
        #1 assign address_write = {q, p - q};
        
        if ((p - q) && 128)
            counter = destination;
        else
            counter = counter + 1;
     end
endmodule
