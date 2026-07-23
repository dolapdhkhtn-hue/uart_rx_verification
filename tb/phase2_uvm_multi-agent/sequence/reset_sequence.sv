class reset_sequence extends uvm_sequence #(reset_item);
    `uvm_object_utils(reset_sequence)

    function new(string name = "reset_sequence");
    super.new(name);
    endfunction

    task body();
    reset_item item;

    item = reset_item::type_id::create("item");

    start_item(item);
    if (!item.randomize())
      `uvm_error("RESET_SEQ", "Randomize failed")
    finish_item(item);

    endtask


endclass