// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vtb_top_axi_serdes__pch.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vtb_top_axi_serdes::Vtb_top_axi_serdes(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vtb_top_axi_serdes__Syms(contextp(), _vcname__, this)}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
    contextp()->traceBaseModelCbAdd(
        [this](VerilatedTraceBaseC* tfp, int levels, int options) { traceBaseModel(tfp, levels, options); });
}

Vtb_top_axi_serdes::Vtb_top_axi_serdes(const char* _vcname__)
    : Vtb_top_axi_serdes(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vtb_top_axi_serdes::~Vtb_top_axi_serdes() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vtb_top_axi_serdes___024root___eval_debug_assertions(Vtb_top_axi_serdes___024root* vlSelf);
#endif  // VL_DEBUG
void Vtb_top_axi_serdes___024root___eval_static(Vtb_top_axi_serdes___024root* vlSelf);
void Vtb_top_axi_serdes___024root___eval_initial(Vtb_top_axi_serdes___024root* vlSelf);
void Vtb_top_axi_serdes___024root___eval_settle(Vtb_top_axi_serdes___024root* vlSelf);
void Vtb_top_axi_serdes___024root___eval(Vtb_top_axi_serdes___024root* vlSelf);

void Vtb_top_axi_serdes::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vtb_top_axi_serdes::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vtb_top_axi_serdes___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vtb_top_axi_serdes___024root___eval_static(&(vlSymsp->TOP));
        Vtb_top_axi_serdes___024root___eval_initial(&(vlSymsp->TOP));
        Vtb_top_axi_serdes___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vtb_top_axi_serdes___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vtb_top_axi_serdes::eventsPending() { return false; }

uint64_t Vtb_top_axi_serdes::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vtb_top_axi_serdes::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vtb_top_axi_serdes___024root___eval_final(Vtb_top_axi_serdes___024root* vlSelf);

VL_ATTR_COLD void Vtb_top_axi_serdes::final() {
    Vtb_top_axi_serdes___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vtb_top_axi_serdes::hierName() const { return vlSymsp->name(); }
const char* Vtb_top_axi_serdes::modelName() const { return "Vtb_top_axi_serdes"; }
unsigned Vtb_top_axi_serdes::threads() const { return 1; }
void Vtb_top_axi_serdes::prepareClone() const { contextp()->prepareClone(); }
void Vtb_top_axi_serdes::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vtb_top_axi_serdes::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vtb_top_axi_serdes___024root__trace_decl_types(VerilatedVcd* tracep);

void Vtb_top_axi_serdes___024root__trace_init_top(Vtb_top_axi_serdes___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vtb_top_axi_serdes___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_top_axi_serdes___024root*>(voidSelf);
    Vtb_top_axi_serdes__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->pushPrefix(std::string{vlSymsp->name()}, VerilatedTracePrefixType::SCOPE_MODULE);
    Vtb_top_axi_serdes___024root__trace_decl_types(tracep);
    Vtb_top_axi_serdes___024root__trace_init_top(vlSelf, tracep);
    tracep->popPrefix();
}

VL_ATTR_COLD void Vtb_top_axi_serdes___024root__trace_register(Vtb_top_axi_serdes___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vtb_top_axi_serdes::traceBaseModel(VerilatedTraceBaseC* tfp, int levels, int options) {
    (void)levels; (void)options;
    VerilatedVcdC* const stfp = dynamic_cast<VerilatedVcdC*>(tfp);
    if (VL_UNLIKELY(!stfp)) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vtb_top_axi_serdes::trace()' called on non-VerilatedVcdC object;"
            " use --trace-fst with VerilatedFst object, and --trace with VerilatedVcd object");
    }
    stfp->spTrace()->addModel(this);
    stfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    Vtb_top_axi_serdes___024root__trace_register(&(vlSymsp->TOP), stfp->spTrace());
}
