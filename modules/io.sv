// File: io.sv
// Author: Tommy Sætre
// Description: N-bit I/O module facilitating an active low reset and a polling/handshake input for halting program execution.
// Last revision: 22/04/24

module io #(parameter N = 8) (
    input logic clk, n_reset, handshake, write_out,
    input logic [N-1:0] in, cpu_out,
    output logic [N-1:0] cpu_in, out,
    output logic halt_program
);
    enum {
        poll_read_1,
        read_1,
        post_read_1,
        poll_read_2,
        read_2,
        post_read_2,
        poll_write_1,
        write_1,
        poll_write_2,
        write_2
    } current_state, next_state;

    logic [N-1:0] next_out;

    always_ff @(posedge clk, negedge n_reset) begin
        if (!n_reset) begin
            current_state <= poll_read_1;
            out <= 0;
        end
        else begin
            current_state <= next_state;
            out <= next_out;
        end
    end

    always_comb begin
        next_state = current_state;
        cpu_in = 0;
        next_out = 0;
        halt_program = 1;

        unique case (current_state)
            poll_read_1 :
                if (handshake) next_state = read_1;
            read_1 : begin
                cpu_in = in;
                halt_program = 0;
                next_state = post_read_1;
            end
            post_read_1 :
                if (!handshake) next_state = poll_read_2;
            poll_read_2 :
                if (handshake) next_state = read_2;
            read_2 : begin
                cpu_in = in;
                halt_program = 0;
                next_state = post_read_2;
            end
            post_read_2 :
                if (!handshake) next_state = poll_write_1;
            poll_write_1 : begin
                halt_program = 0;
                if (write_out) begin
                    next_out = cpu_out;
                    next_state = write_1;
                end
            end
            write_1 : begin
                next_out = out;
                if (handshake) next_state = poll_write_2;
            end
            poll_write_2 : begin
                halt_program = 0;
                if (write_out) begin
                    next_out = cpu_out;
                    next_state = write_2;
                end
            end
            write_2 : begin
                next_out = out;
                if (!handshake) begin
                    next_state = poll_read_1;
                    halt_program = 0;
                end
            end
            default:
                $error("Unexpected state");
        endcase
    end

endmodule