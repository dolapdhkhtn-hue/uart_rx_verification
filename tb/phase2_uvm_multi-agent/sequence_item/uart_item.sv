class uart_item extends uvm_sequence_item;
    `uvm_object_utils(uart_item)
    rand logic [7:0] data_rx;
    rand logic       start_bit;
    rand logic       stop_bit;

    function new (string name = "uart_item"); // khoi tao cha
        super.new(name);
    endfunction 

    constraint data_1 {
        data_rx dist {
            8'd0 := 100,
            8'd255 := 100,
            [8'd1:8'd254] := 5
        };
    }

    constraint start {
        start_bit == 1'b0;
    }

    constraint stop {
        stop_bit == 1'b1;
    }
endclass
