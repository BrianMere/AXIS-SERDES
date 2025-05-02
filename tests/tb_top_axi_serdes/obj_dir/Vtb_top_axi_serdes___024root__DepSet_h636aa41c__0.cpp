// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_top_axi_serdes.h for the primary calling header

#include "Vtb_top_axi_serdes__pch.h"
#include "Vtb_top_axi_serdes__Syms.h"
#include "Vtb_top_axi_serdes___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_top_axi_serdes___024root___dump_triggers__act(Vtb_top_axi_serdes___024root* vlSelf);
#endif  // VL_DEBUG

void Vtb_top_axi_serdes___024root___eval_triggers__act(Vtb_top_axi_serdes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_top_axi_serdes___024root___eval_triggers__act\n"); );
    Vtb_top_axi_serdes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtb_top_axi_serdes___024root___dump_triggers__act(vlSelf);
    }
#endif
}
