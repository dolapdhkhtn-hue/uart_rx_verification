class uart_apb_virtual_sequence extends uvm_sequence;  // virtual sequence
  `uvm_object_utils(uart_apb_virtual_sequence)
  `uvm_declare_p_sequencer(virtual_sequencer)

  int unsigned num_transactions = 10;

  function new(string name = "uart_apb_virtual_sequence");
    super.new(name);
  endfunction

  task body();
    reset_sequence   reset_seq;
    uart_sequence    uart_seq;
    apb_sequence     apb_seq;

    //Reset hệ thống
    reset_seq = reset_sequence::type_id::create("reset_seq");
    reset_seq.start(p_sequencer.reset_seqr);

    // Lặp gửi data qua UART rồi đọc lại qua APB
    repeat (num_transactions) begin
      uart_seq = uart_sequence::type_id::create("uart_seq");
      if (!uart_seq.randomize())
        `uvm_error("VSEQ", "Randomize failed")

      uart_seq.start(p_sequencer.uart_seqr);

      apb_seq = apb_sequence::type_id::create("apb_read_seq");
      apb_seq.start(p_sequencer.apb_seqr);
    end
  endtask
endclass