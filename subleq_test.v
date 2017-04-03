module subleq_test;
    reg         clock;
    wire [7:0]  read;
    wire [15:0] write;
    reg  [7:0]  data;

    subleq subleq(clock, read, write, data);

    reg  [7:0]  memory [0:255];

    integer counter = 0;
    integer go = 0;
    reg [23:0] state;

    always #1 clock = !clock;

    initial
        begin
            $readmemh("/home/ocb/src/subleq/memory", memory);

            clock = 0;
            state = 0;

            $display("test: started test!");
        end

    always @(posedge clock)
        begin
            data = memory[read];
            memory[write[7:0]] = write[15:8];
            state = {read, write};

            $display("test: read %h from %h, wrote %h to %h", memory[read], read, $signed(write[15:8]), write[7:0]);
        end

    // machine never halts, so we just specify how many cycles we want up front
    always #45
        begin
            $display("test: final contents of memory:");

            repeat (12)
                begin
                    $display("c: %h, m: %h", counter, memory[counter]);
                    counter = counter + 1;
                end

            $finish;
        end
endmodule