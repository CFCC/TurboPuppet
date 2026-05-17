#
# Drivers for Minisforum AtomMan devices.
#
class profiles::driver::atomman (
  String $driver_root = $profiles::driver::base::driver_root,
) inherits profiles::driver::base {
  include profiles::driver::gpu::nvidia
}
