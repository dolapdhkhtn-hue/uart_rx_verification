

class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    
    env env_1;

    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_1 = env::type_id::create("env_1", this);
    endfunction

    task run_phase(uvm_phase phase);
        uart_apb_virtual_sequence vseq;
        phase.raise_objection(this);
        `uvm_info(get_type_name(), "Start of testcase", UVM_LOW)

        vseq = uart_apb_virtual_sequence::type_id::create("vseq");
        vseq.start(env_1.vseqr);

        `uvm_info(get_type_name(), "End of testcase", UVM_LOW)
        phase.drop_objection(this);
    endtask
endclass