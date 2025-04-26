class irq_monitor extends uvm_monitor;

    virtual irq_agent_if vif;

    uvm_analysis_port #(irq_seq_item) ap;

    `uvm_component_utils(irq_monitor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        ap = new("ap", this);

        if (!uvm_config_db#(virtual irq_agent_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface must be set for monitor")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);

            if (vif.irq_ack_o) begin
                irq_seq_item trans;
                trans = irq_seq_item::type_id::create("trans");

                trans.irq_ack_o = vif.irq_ack_o;
                trans.irq_id_o  = vif.irq_id_o;

                ap.write(trans);
            end
        end
    endtask

endclass
