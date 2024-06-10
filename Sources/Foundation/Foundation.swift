#if hasFeature(Embedded)
@_extern(c)
public func __malloc(_ size: Int) -> UnsafeMutableRawPointer
@_extern(c)
public func __free(_ buffer: UnsafeMutableRawPointer)
#endif
