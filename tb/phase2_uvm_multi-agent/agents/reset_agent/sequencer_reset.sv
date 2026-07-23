class sequencer_reset extends uvm_sequencer #(reset_item);
    `uvm_component_utils(sequencer_reset)

    function new(string name = "sequencer_reset", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass
