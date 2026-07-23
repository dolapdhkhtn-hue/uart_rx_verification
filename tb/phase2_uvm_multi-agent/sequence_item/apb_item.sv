class apb_item extends uvm_sequence_item;
    `uvm_object_utils(apb_item)

    rand logic [7:0] p_addr;
    rand logic       p_enable;
    rand logic       p_sel_uart;
    rand logic       p_write;

         logic [7:0] p_data_uart;

    function new(string name = "apb_item");
        super.new(name);
    endfunction

    constraint addr {
        p_addr inside {8'd0, 8'd4};
    }
      constraint enable {
        p_enable == 1'b1;
    }
      constraint sel_uart {
        p_sel_uart == 1'b1;
    }
          constraint write {
        p_write == 1'b0;
    }

endclass