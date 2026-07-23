class agent_reset extends uvm_agent;
    `uvm_component_utils(agent_reset)

    sequencer_reset seq_reset;
    driver_reset    drv_reset;
  

    function new (string name = "agent_reset", uvm_component parent = null);
            super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(get_is_active() == UVM_ACTIVE) begin
            seq_reset = sequencer_reset::type_id::create("seq_reset", this);
            drv_reset = driver_reset::type_id::create("drv_reset", this);
        end
         
    endfunction

    function void connect_phase(uvm_phase phase);
        if(get_is_active() == UVM_ACTIVE) begin
            drv_reset.seq_item_port.connect(seq_reset.seq_item_export);
        end
    endfunction
endclass