IO = {}

IO.Error = CakeStrap.LoadPackage ("Knotcake.Error")
IO.OOP   = CakeStrap.LoadPackage ("Knotcake.OOP")
IO.OOP.Initialize (IO)
IO.BitConverter = CakeStrap.LoadPackage ("Knotcake.BitConverter")

include ("ibasestream.lua")
include ("iinstream.lua")
include ("ioutstream.lua")

include ("endianness.lua")
include ("istreamreader.lua")
include ("istreamwriter.lua")

include ("streamreader.lua")
include ("streamwriter.lua")

include ("bufferedstreamreader.lua")
include ("bufferedstreamwriter.lua")

include ("stringinstream.lua")
include ("stringoutstream.lua")

return IO
