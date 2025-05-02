// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtb_top_axi_serdes__Syms.h"


void Vtb_top_axi_serdes___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_top_axi_serdes___024root__trace_cleanup\n"); );
    // Init
    Vtb_top_axi_serdes___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_top_axi_serdes___024root*>(voidSelf);
    Vtb_top_axi_serdes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VlUnpacked<CData/*0:0*/, 1> __Vm_traceActivity;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        __Vm_traceActivity[__Vi0] = 0;
    }
    // Body
    vlSymsp->__Vm_activity = false;
    __Vm_traceActivity[0U] = 0U;
}
