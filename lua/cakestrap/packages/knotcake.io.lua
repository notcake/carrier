IO = {}

IO.Error = CakeStrap.LoadPackage ("Knotcake.Error")
IO.OOP   = CakeStrap.LoadPackage ("Knotcake.OOP")
IO.OOP.Initialize (IO)
IO.BitConverter = CakeStrap.LoadPackage ("Knotcake.BitConverter")

include ("knotcake.io/ibasestream.lua")
include ("knotcake.io/iinstream.lua")
include ("knotcake.io/ioutstream.lua")

include ("knotcake.io/endianness.lua")
include ("knotcake.io/istreamreader.lua")
include ("knotcake.io/istreamwriter.lua")

include ("knotcake.io/streamreader.lua")
include ("knotcake.io/streamwriter.lua")

include ("knotcake.io/bufferedstreamreader.lua")

include ("knotcake.io/stringinstream.lua")

return IO
