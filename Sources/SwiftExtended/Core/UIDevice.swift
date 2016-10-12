import UIKit


public struct UIDevice {
  public static func hostBasicInfo() -> HostBasicInfo {
    let HOST_BASIC_INFO_COUNT = MemoryLayout<host_basic_info>.stride/MemoryLayout<integer_t>.stride
    var size = mach_msg_type_number_t(HOST_BASIC_INFO_COUNT)
    let hostInfo = host_basic_info_t.allocate(capacity: 1)
    let _ = hostInfo.withMemoryRebound(to: integer_t.self, capacity: HOST_BASIC_INFO_COUNT) {
      host_info(mach_host_self(), HOST_BASIC_INFO, $0, &size)
    }

    let hostBasicInfo = HostBasicInfo(hostInfo)
    hostInfo.deallocate()
    return hostBasicInfo
  }
}

public struct HostBasicInfo {

  /// Max number of CPUs possible
  public let maxCpus: Int

  /// Number of CPUs now available
  public let availableCpus: Int

  /// Size of memory in bytes, capped at 2 GB
  public let memorySize: UInt32

  /// CPU type
  public let cpuType: CpuType

  /// cpu subtype
  public let cpu_subtype: cpu_subtype_t

  /// cpu threadtype
  public let cpu_threadtype: cpu_threadtype_t

  /// Number of physical CPUs now available
  public let physicalCpus: Int

  /// Max number of physical CPUs possible
  public var physicalCpusMax: Int

  /// Number of logical CPUs now available
  public let logicalCpus: Int

  /// Max number of physical CPUs possible
  public let logicalCpusMax: Int


  /// Actual size of physical memory
  public let actualPhysicalMemorySize: UInt64

  fileprivate init(_ legacyInfoPointer: host_basic_info_t) {
    let legacyInfo = legacyInfoPointer.pointee
    maxCpus = Int(legacyInfo.max_cpus)
    availableCpus = Int(legacyInfo.avail_cpus)
    memorySize = legacyInfo.memory_size
    cpuType = CpuType(legacyCPUType: legacyInfo.cpu_type)
    cpu_subtype = legacyInfo.cpu_subtype
    cpu_threadtype = legacyInfo.cpu_threadtype
    physicalCpus = Int(legacyInfo.physical_cpu)
    physicalCpusMax = Int(legacyInfo.physical_cpu_max)
    actualPhysicalMemorySize = legacyInfo.max_mem
    logicalCpus = Int(legacyInfo.logical_cpu)
    logicalCpusMax = Int(legacyInfo.logical_cpu_max)
  }
}
