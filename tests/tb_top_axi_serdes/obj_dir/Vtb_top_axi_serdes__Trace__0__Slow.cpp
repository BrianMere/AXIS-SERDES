// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtb_top_axi_serdes__Syms.h"


VL_ATTR_COLD void Vtb_top_axi_serdes___024root__trace_init_top(Vtb_top_axi_serdes___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_top_axi_serdes___024root__trace_init_top\n"); );
    Vtb_top_axi_serdes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    // Empty
}

VL_ATTR_COLD void Vtb_top_axi_serdes___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtb_top_axi_serdes___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vtb_top_axi_serdes___024root__trace_register(Vtb_top_axi_serdes___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_top_axi_serdes___024root__trace_register\n"); );
    Vtb_top_axi_serdes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    tracep->addConstCb(&Vtb_top_axi_serdes___024root__trace_const_0, 0U, vlSelf);
    tracep->addCleanupCb(&Vtb_top_axi_serdes___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vtb_top_axi_serdes___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_top_axi_serdes___024root__trace_const_0\n"); );
    // Init
    Vtb_top_axi_serdes___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_top_axi_serdes___024root*>(voidSelf);
    Vtb_top_axi_serdes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
}
