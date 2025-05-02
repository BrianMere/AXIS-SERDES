// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_top_axi_serdes.h for the primary calling header

#include "Vtb_top_axi_serdes__pch.h"
#include "Vtb_top_axi_serdes___024root.h"

VL_ATTR_COLD void Vtb_top_axi_serdes___024root___eval_static(Vtb_top_axi_serdes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_top_axi_serdes___024root___eval_static\n"); );
    Vtb_top_axi_serdes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vtb_top_axi_serdes___024root___eval_initial__TOP(Vtb_top_axi_serdes___024root* vlSelf);

VL_ATTR_COLD void Vtb_top_axi_serdes___024root___eval_initial(Vtb_top_axi_serdes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_top_axi_serdes___024root___eval_initial\n"); );
    Vtb_top_axi_serdes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vtb_top_axi_serdes___024root___eval_initial__TOP(vlSelf);
}

VL_ATTR_COLD void Vtb_top_axi_serdes___024root___eval_initial__TOP(Vtb_top_axi_serdes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_top_axi_serdes___024root___eval_initial__TOP\n"); );
    Vtb_top_axi_serdes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    VL_FINISH_MT("tb_top_axi_serdes.sv", 5, "");
}

VL_ATTR_COLD void Vtb_top_axi_serdes___024root___eval_final(Vtb_top_axi_serdes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_top_axi_serdes___024root___eval_final\n"); );
    Vtb_top_axi_serdes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vtb_top_axi_serdes___024root___eval_settle(Vtb_top_axi_serdes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_top_axi_serdes___024root___eval_settle\n"); );
    Vtb_top_axi_serdes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_top_axi_serdes___024root___dump_triggers__act(Vtb_top_axi_serdes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_top_axi_serdes___024root___dump_triggers__act\n"); );
    Vtb_top_axi_serdes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_top_axi_serdes___024root___dump_triggers__nba(Vtb_top_axi_serdes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_top_axi_serdes___024root___dump_triggers__nba\n"); );
    Vtb_top_axi_serdes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtb_top_axi_serdes___024root___ctor_var_reset(Vtb_top_axi_serdes___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_top_axi_serdes___024root___ctor_var_reset\n"); );
    Vtb_top_axi_serdes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}
