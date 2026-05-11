#ifndef PIM_H_
#define PIM_H_

#include "XML_Parse.h"
#include "logic.h"
#include "array.h"

class PIM : public Component {
public:
    PIM(ParseXML *XML_interface,InputParameter* interface_ip_);
    void computeEnergy(bool is_tdp=true);
    void displayEnergy(uint32_t indent = 0,int plevel = 100, bool is_tdp=true);
    ~PIM();
    double executionTime;
    double clockRate;
    ParseXML *XML;
    ArrayST * crf;          // 32 x 32b (Instrucciones)
    ArrayST * grf;          // 16 x 256b (Datos vectoriales)
    ArrayST * srf;          // 16 x 16b (Datos escalares)
    FunctionalUnit * fp_unit;   // 16 lanes FP16 (MUL/ADD)
};

#endif /* PIM_H_ */