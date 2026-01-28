/**
 * @file
 * PIMInterface declaration
 */

#ifndef __PIM_INTERFACE_HH__
#define __PIM_INTERFACE_HH__
#include <vector>

#include "mem/dram_interface.hh"
#include "params/PIMInterface.hh"

namespace gem5
{
namespace memory
{

class PIMInterface : public DRAMInterface
{
  private:
    enum PIMInstructionType
    {
        NOP = 0,
        JUMP,
        EXIT,
        MOV,
        ADD,
        MUL,
        MAD,
        MAC
    };

    class PIMInstruction
    {
      private:
        PIMInstructionType type;
    };

    /*
     * Number of registers in the accelerator
     */
    const uint8_t crf_entries;
    const uint8_t grf_entries;
    const uint8_t srf_entries;
    /*
     * Accelerator registers
     */
    std::vector<PIMInstruction> crf;        // instruction register file
    std::vector<std::vector<uint16_t>> grf; // vector register file
    std::vector<uint16_t> srf;              // scalar register file
    /*
     * State variables
     */
    bool pim_mode;         // PIM mode enabled/disabled
    bool single_bank_mode; // single bank mode enabled/disabled
  public:
    PIMInterface(const PIMInterfaceParams &_p);
};

} // namespace memory
} // namespace gem5
