class reset_item extends uvm_sequence_item;
    `uvm_object_utils(reset_item)

    rand logic reset_n; 

    function new (string name = "reset_item");
       super.new(name);
    endfunction

    constraint reset {
        reset_n  == 1'b0;
    }


endclass