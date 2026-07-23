class sequencer_apb extends uvm_sequencer #(apb_item);
    `uvm_component_utils(sequencer_apb)

    function new (string name = "sequencer_apb", uvm_component parent = null);
            super.new(name,parent);
    endfunction

    function void build_phase (uvm_phase phase);
            super.build_phase(phase);
    endfunction
endclass

class sequencer_reset extends uvm_sequencer #(reset_item);
    `uvm_component_utils(sequencer_reset)

    function new(string name = "sequencer_reset", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass