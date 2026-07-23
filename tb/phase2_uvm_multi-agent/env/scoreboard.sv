`uvm_analysis_imp_decl(_uart)
`uvm_analysis_imp_decl(_apb)

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    uart_item item_uart[$];
    apb_item  item_apb[$];

    uvm_analysis_imp_uart #(uart_item, scoreboard) uart_item_collect_export;
    uvm_analysis_imp_apb  #(apb_item,  scoreboard) apb_item_collect_export;

    function new(string name = "scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uart_item_collect_export = new("uart_item_collect_export", this);
        apb_item_collect_export  = new("apb_item_collect_export",  this);
    endfunction

    function void write_uart(uart_item req);
        item_uart.push_back(req);
    endfunction

    function void write_apb(apb_item req);
        if ((req.p_addr == 8'd4) && (req.p_write == 1'b0)) begin
            item_apb.push_back(req);
        end
    endfunction

    task run_phase(uvm_phase phase);
        uart_item uart_sb_item;
        apb_item  apb_sb_item;

        forever begin
            wait(item_uart.size() > 0 && item_apb.size() > 0);
            uart_sb_item = item_uart.pop_front();
            apb_sb_item  = item_apb.pop_front();

            if(uart_sb_item.data_rx == apb_sb_item.p_data_uart)
                `uvm_info(get_type_name(), "PASS: data match", UVM_LOW)
            else
                `uvm_error(get_type_name(), $sformatf("FAIL: expected=%0h actual=%0h",
                    uart_sb_item.data_rx, apb_sb_item.p_data_uart))
        end
    endtask

endclass