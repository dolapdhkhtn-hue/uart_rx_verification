// ============================================================
// SCOREBOARD
// ============================================================
class scoreboard extends uvm_scoreboard;
    uvm_analysis_imp #(seq_item, scoreboard) item_collect_export;
    seq_item item_q[$];

    // Coverage
    seq_item cov_item;
    covergroup data_cg;
        cp_data: coverpoint cov_item.rx_data_read {
            bins zero  = {8'h00};
            bins max   = {8'hFF};
            bins alt1  = {8'hAA};
            bins alt2  = {8'h55};
            bins others = default;
        }
    endgroup

    `uvm_component_utils(scoreboard)

    function new(string name = "scoreboard", uvm_component parent = null);
        super.new(name, parent);
        item_collect_export = new("item_collect_export", this);
        data_cg = new();
        $display("scoreboard new");
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        $display("scoreboard build_phase");
    endfunction

    function void write(seq_item req);
        item_q.push_back(req);
    endfunction

    task run_phase(uvm_phase phase);
        seq_item sb_item;
        $display("scoreboard run_phase");
        forever begin
            wait(item_q.size > 0);
            sb_item = item_q.pop_front();

            $display("---------------------------------------------------------");
            $display("SCOREBOARD CHECK | rx_data=0x%02X", sb_item.rx_data_read);

            // CHECK 1: done_flag trước khi gửi = 0x00
            if (sb_item.done_flag_before == 8'h00)
                `uvm_info("SCB",
                    $sformatf("[PASS] CHECK1 Initial State   : done_flag_before = 0x%02X (expect 0x00)", sb_item.done_flag_before),
                    UVM_LOW)
            else
                `uvm_error("SCB",
                    $sformatf("[FAIL] CHECK1 Initial State   : done_flag_before = 0x%02X (expect 0x00)", sb_item.done_flag_before))

            // CHECK 2: done_flag sau khi nhận = 0x01
            if (sb_item.done_flag_after == 8'h01)
                `uvm_info("SCB",
                    $sformatf("[PASS] CHECK2 Done Flag       : done_flag_after  = 0x%02X (expect 0x01)", sb_item.done_flag_after),
                    UVM_LOW)
            else
                `uvm_error("SCB",
                    $sformatf("[FAIL] CHECK2 Done Flag       : done_flag_after  = 0x%02X (expect 0x01)", sb_item.done_flag_after))

            // CHECK 3: data nhận = data gửi

            if (sb_item.done_flag_after == 8'h01)
                `uvm_info("SCB",
                    $sformatf("[PASS] CHECK3 Data Valid      : rx_data_read     = 0x%02X (done_flag=1 → data hợp lệ)", sb_item.rx_data_read),
                    UVM_LOW)
            else
                `uvm_error("SCB",
                    $sformatf("[FAIL] CHECK3 Data Valid      : rx_data_read     = 0x%02X nhưng done_flag chưa lên 1", sb_item.rx_data_read))

            // CHECK 4: done_flag về 0 sau khi CPU đọc RX_DATA
            if (sb_item.done_flag_cleared == 8'h00)
                `uvm_info("SCB",
                    $sformatf("[PASS] CHECK4 Flag Cleared    : done_flag_cleared= 0x%02X (expect 0x00)", sb_item.done_flag_cleared),
                    UVM_LOW)
            else
                `uvm_error("SCB",
                    $sformatf("[FAIL] CHECK4 Flag Cleared    : done_flag_cleared= 0x%02X (expect 0x00)", sb_item.done_flag_cleared))

            // Sample coverage
            cov_item = sb_item;
            data_cg.sample();

            $display("---------------------------------------------------------");
        end
    endtask

    function void report_phase(uvm_phase phase);
        $display("============================================");
        $display("  COVERAGE: %.2f%%", data_cg.get_coverage());
        $display("============================================");
    endfunction
endclass
