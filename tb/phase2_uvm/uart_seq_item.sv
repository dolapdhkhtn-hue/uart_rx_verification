// ============================================================
// SEQUENCE ITEM
// ============================================================
class seq_item extends uvm_sequence_item;

    rand logic [7:0] data;   // byte cần gửi qua UART

    logic [7:0] done_flag_before;   // check 1: phải = 0x00
    logic [7:0] done_flag_after;    // check 2: phải = 0x01
    logic [7:0] rx_data_read;       // check 3: phải = data
    logic [7:0] done_flag_cleared;  // check 4: phải = 0x00

    function new(string name = "seq_item");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(seq_item)
        `uvm_field_int(data,              UVM_ALL_ON)
        `uvm_field_int(done_flag_before,  UVM_ALL_ON)
        `uvm_field_int(done_flag_after,   UVM_ALL_ON)
        `uvm_field_int(rx_data_read,      UVM_ALL_ON)
        `uvm_field_int(done_flag_cleared, UVM_ALL_ON)
    `uvm_object_utils_end

    constraint data_c {
        data dist {
            8'h00         := 200,   // all zeros
            8'hFF         := 200,   // all ones
            8'hAA         := 200,   // 10101010
            8'h55         := 200,   // 01010101
            [8'h01:8'hFE] := 6      // random khác
        };
    }
endclass