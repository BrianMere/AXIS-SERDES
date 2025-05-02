// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vtb_top_axi_serdes__pch.h"
#include "Vtb_top_axi_serdes.h"
#include "Vtb_top_axi_serdes___024root.h"

// FUNCTIONS
Vtb_top_axi_serdes__Syms::~Vtb_top_axi_serdes__Syms()
{
}

Vtb_top_axi_serdes__Syms::Vtb_top_axi_serdes__Syms(VerilatedContext* contextp, const char* namep, Vtb_top_axi_serdes* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
{
        // Check resources
        Verilated::stackCheck(11);
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-9);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
}
