import Foundation

public enum CpuType {
  case any
  case vax
  case mc680x0
  case x86
  case i386
  case mc98000
  case hppa
  case arm
  case mc88000
  case sparc
  case i860
  case powerpc

  public init(legacyCPUType: cpu_type_t) {
    switch legacyCPUType {
    case CPU_TYPE_ANY:
      self = .any
    case CPU_TYPE_VAX:
      self = .vax
    case CPU_TYPE_MC680x0:
      self = .mc680x0
    case CPU_TYPE_X86:
      self = .x86
    case CPU_TYPE_I386:
      self = .i386
    case CPU_TYPE_MC98000:
      self = .mc98000
    case CPU_TYPE_HPPA:
      self = .hppa
    case CPU_TYPE_ARM:
      self = .any
    case CPU_TYPE_MC88000:
      self = .mc88000
    case CPU_TYPE_SPARC:
      self = .sparc
    case CPU_TYPE_I860:
      self = .i860
    case CPU_TYPE_POWERPC:
      self = .powerpc
    default:
      self = .any
    }
  }
}
