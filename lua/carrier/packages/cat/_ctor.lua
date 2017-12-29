-- PACKAGE Cat

Cat = {}

Error = require ("Pylon.Error")

Table = require ("Pylon.Table")

require ("Pylon.OOP").Initialize (_ENV)

BigInteger = require ("Pylon.BigInteger")

include ("unpackedcomplex.lua")
include ("unpackedquaternion.lua")
include ("complex.lua")
include ("quaternion.lua")

Cat.Rings = {}
include ("rings/iring.lua")
include ("rings/reals.lua")
include ("rings/complex.lua")
include ("rings/gf2.lua")
include ("rings/modularring.lua")
Cat.Rings.UInt8  = Cat.Rings.ModularRing (256)
Cat.Rings.UInt16 = Cat.Rings.ModularRing (65536)
Cat.Rings.UInt32 = Cat.Rings.ModularRing (4294967296)
include ("rings/uint64.lua")

Cat.LinearAlgebra = {}
include ("linearalgebra/realmatrix.lua")
include ("linearalgebra/genericmatrix.lua")
include ("linearalgebra/complexmatrix.lua")
include ("linearalgebra/gf2matrix.lua")

include ("linearalgebra/unpackedvector2d.lua")
include ("linearalgebra/unpackedvector3d.lua")
include ("linearalgebra/unpackedmatrix2x2d.lua")
include ("linearalgebra/vector2d.lua")
include ("linearalgebra/vector3d.lua")
include ("linearalgebra/matrix2x2d.lua")
include ("linearalgebra/matrix3x3d.lua")
include ("linearalgebra/matrix4x4d.lua")

Cat.LinearAlgebra.RealMatrix = Cat.LinearAlgebra.Matrix
Cat.Matrix = Cat.LinearAlgebra.Matrix

Cat.UnpackedVector2d   = Cat.LinearAlgebra.UnpackedVector2d
Cat.UnpackedVector3d   = Cat.LinearAlgebra.UnpackedVector3d
Cat.UnpackedMatrix2x2d = Cat.LinearAlgebra.UnpackedMatrix2x2d
Cat.Vector2d           = Cat.LinearAlgebra.Vector2d
Cat.Vector3d           = Cat.LinearAlgebra.Vector3d
Cat.Matrix2x2d         = Cat.LinearAlgebra.Matrix2x2d
Cat.Matrix3x3d         = Cat.LinearAlgebra.Matrix3x3d
Cat.Matrix4x4d         = Cat.LinearAlgebra.Matrix4x4d

Cat.Geometry = {}
include ("geometry/unpackedlinearbezier2d.lua")
include ("geometry/unpackedlinearbezier3d.lua")
include ("geometry/unpackedquadraticbezier2d.lua")
include ("geometry/unpackedquadraticbezier3d.lua")
include ("geometry/unpackedcubicbezier2d.lua")
include ("geometry/unpackedcubicbezier3d.lua")
include ("geometry/linearbezier2d.lua")
include ("geometry/linearbezier3d.lua")
include ("geometry/quadraticbezier2d.lua")
include ("geometry/quadraticbezier3d.lua")
include ("geometry/cubicbezier2d.lua")
include ("geometry/cubicbezier3d.lua")
return Cat
