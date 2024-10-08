localparam WIDTH = 4;

module tb_add_1 (
    `ifdef VERILATOR
        input logic clk
    `endif
    );

logic in;
logic n_rst;
logic out;

`ifndef VERILATOR
    logic clk; 
`endif

logic [WIDTH-1:0]value;

add_1 UUT (
    .in(in),
    .clk(clk),
    .reset(n_rst),
    .out(out)
);

`ifndef VERILATOR
initial begin
    clk = 1;
    forever begin
        #20 clk = ~clk;
    end
end
`endif

initial begin
    // initialize all the signals
    init_signals;

    // apply reset sequence
    reset_seq;

    // apply inputs
    repeat(16)begin 
        value = value + 1;
        apply_inputs(value[0]);
        apply_inputs(value[1]);
        apply_inputs(value[2]);
        apply_inputs(value[3]);
        reset_seq;
    end

    repeat(1)@(posedge clk);
    $finish;
end

// initialize the signals
task init_signals;
    begin
        in = 0; value = 0; n_rst = 1;
        @(posedge clk);
    end
endtask

// reset sequence
task reset_seq;
    begin
        n_rst = 0;
        @(posedge clk) n_rst = 1; 
    end
endtask

// apply inputs
task apply_inputs(input value_in);
    in = value_in;
    @(posedge clk);
endtask

endmodule