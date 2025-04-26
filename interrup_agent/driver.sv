class irq_driver extends uvm_driver #(irq_seq_item);

    virtual irq_agent_if vif;

    `uvm_component_utils(irq_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual irq_agent_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface must be set for driver")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            irq_seq_item req;

            seq_item_port.get_next_item(req);

            vif.irq_i <= req.irq_i;

            #1ns; // optional delay

            seq_item_port.item_done();
        end
    endtask

endclass
