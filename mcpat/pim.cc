#include "pim.h"
#include "basic_components.h"
#include "logic.h"
#include <iostream>

PIM::PIM(ParseXML *XML_interface, InputParameter* ip):
    XML(XML_interface)
{
    executionTime = (1.0 * XML_interface->sys.pim.total_cycles) / (XML_interface->sys.pim.clockRate * 1e6); // Convertir ciclos a segundos
    clockRate = XML_interface->sys.pim.clockRate * 1e6; // Convertir MHz a Hz
    InputParameter local_ip = *ip;
    local_ip.pure_ram = true;
    local_ip.is_cache = false;
    local_ip.assoc = 1;
    local_ip.nbanks = 1;

    // GRF
    local_ip.line_sz = 32; 
    local_ip.cache_sz = 16 * 32;
    local_ip.out_w = 256;
    grf = new ArrayST(&local_ip, "PIM_GRF", Core_device, false, Inorder);

    // CRF
    local_ip.line_sz = 4; 
    local_ip.cache_sz = 32 * 4;
    local_ip.out_w = 32;
    crf = new ArrayST(&local_ip, "PIM_CRF", Core_device, false, Inorder);

    //  SRF
    local_ip.line_sz = 2; 
    local_ip.cache_sz = 16 * 4; //64 bytes, minimum required by CACTI
    local_ip.out_w = 16;
    srf = new ArrayST(&local_ip, "PIM_SRF", Core_device, false, Inorder);

    // FPU
    CoreDynParam dynp;
    memset(&dynp, 0, sizeof(CoreDynParam));
    dynp.clockRate = XML_interface->sys.pim.clockRate * 1e6; // Convertir MHz a Hz
    dynp.executionTime = executionTime;
    dynp.core_ty = Inorder; // Asumimos un pipeline in-order para el PIM
    dynp.num_fpus = 16;
    dynp.num_alus = 0;
    fp_unit = new FunctionalUnit(XML_interface, 0, &local_ip, dynp, FPU);
    // Sumar las áreas de los componentes al área del objeto PIM
    this->area.set_area(grf->local_result.area + crf->local_result.area + 
                    srf->local_result.area + fp_unit->area.get_area());
}

PIM::~PIM() {
    delete grf;
    delete crf;
    delete srf;
    delete fp_unit;
}

void PIM::computeEnergy(bool is_tdp) {
    double pppm_t[4];
    double sckRation = g_tp.sckt_co_eff;

    if (is_tdp) {
        // 1. Resetear potencia pico
        power.reset();

        // 2. Calcular FPU (TDP)
        fp_unit->stats_t.readAc.access = 16; // 16 ALUs activas
        fp_unit->coredynp.FPU_duty_cycle = 1.0;
        fp_unit->computeEnergy(true);
        // En TDP, FunctionalUnit::power ya viene escalado por num_alus internamente
        power = power + fp_unit->power;

        // 4. Acumular todo en el objeto power del PIM usando sobrecarga de '+'
        power = power + grf->local_result.power + crf->local_result.power + srf->local_result.power;

    } else {
        // 1. Resetear potencia de ejecución
        rt_power.reset();

        // 2. Calcular FPU (Runtime - Bypass del hardcoding)
        fp_unit->computeEnergy(false); 
        double pim_fpu_ops = XML->sys.pim.fpu_accesses * 16;
        // Calculamos energía total (Joules)
        cout << "PIM FPU Ops: " << pim_fpu_ops << ", Execution Time: " << executionTime << " s" << endl;
        cout << "Per Access Energy: " << fp_unit->per_access_energy << " J, Base Energy: " << fp_unit->base_energy << " J" << endl;
        cout << "SCK Ratio: " << sckRation << endl;
        fp_unit->rt_power.readOp.dynamic = (fp_unit->per_access_energy * pim_fpu_ops + 
                                            fp_unit->base_energy * executionTime) * sckRation;
        // El leakage en runtime es el mismo que el calculado en el paso base
        fp_unit->rt_power.readOp.leakage = fp_unit->power.readOp.leakage;
        fp_unit->rt_power.readOp.gate_leakage = fp_unit->power.readOp.gate_leakage;
        
        rt_power = rt_power + fp_unit->rt_power;

        // 3. Calcular Registros (Runtime: Usando estadísticas de gem5)
        // Para el GRF (Lecturas y Escrituras)
        set_pppm(pppm_t, XML->sys.pim.grf_reads, 1.0, 1.0, XML->sys.pim.grf_writes);
        grf->rt_power = grf->local_result.power * pppm_t;

        // Para CRF (Solo lecturas)
        set_pppm(pppm_t, XML->sys.pim.crf_reads, 1.0, 1.0, XML->sys.pim.crf_writes);
        crf->rt_power = crf->local_result.power * pppm_t;

        // Para SRF (Solo lecturas)
        set_pppm(pppm_t, XML->sys.pim.srf_reads, 1.0, 1.0, XML->sys.pim.srf_writes);
        srf->rt_power = srf->local_result.power * pppm_t;

        // 4. Acumular todo en el objeto rt_power del PIM
        rt_power = rt_power + grf->rt_power + crf->rt_power + srf->rt_power;
    }

}

void PIM::displayEnergy(uint32_t indent, int plevel, bool is_tdp) {
    std::string indent_str(indent, ' ');
    std::string indent_str_next(indent + 2, ' ');

    std::cout << indent_str << "PIM Accelerator:" << std::endl;


    std::cout << indent_str_next << "Area = " << this->area.get_area() / 1e6 << " mm2" << std::endl;

    std::cout << indent_str_next << "Peak Dynamic = " << power.readOp.dynamic * clockRate << " W" << std::endl;
    std::cout << indent_str_next << "Subthreshold Leakage = " << power.readOp.leakage << " W" << std::endl;
    std::cout << indent_str_next << "Gate Leakage = " << power.readOp.gate_leakage << " W" << std::endl;
    std::cout << indent_str_next << "Runtime Dynamic = " << rt_power.readOp.dynamic / executionTime << " W" << std::endl;
    

    std::cout << indent_str_next << "GRF Area = " << grf->local_result.area / 1e6 << " mm2" << std::endl;
    std::cout << indent_str_next << "CRF Area = " << crf->local_result.area / 1e6 << " mm2" << std::endl;
    std::cout << indent_str_next << "SRF Area = " << srf->local_result.area / 1e6 << " mm2" << std::endl;
    fp_unit->displayEnergy(indent + 4, plevel, is_tdp);
}