class irq_agent extends uvm_agent;

    irq_driver    driver;
    irq_monitor   monitor;
    irq_sequencer sequencer;

    `uvm_component_utils(irq_agent)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (is_active == UVM_ACTIVE) begin
            sequencer = irq_sequencer::type_id::create("sequencer", this);
            driver    = irq_driver::type_id::create("driver", this);
        end

        monitor = irq_monitor::type_id::create("monitor", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if (is_active == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction

endclass
