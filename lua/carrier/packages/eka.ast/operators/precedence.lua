AST.Precedence = Enum (
	{
		Atomic         = 0x0000,
		
		Unary          = 0x1000,
		
		Arithmetic     = 0x2000,
		Exponentiation = 0x2100,
		
		Multiplication = 0x2200,
		Division       = 0x2200,
		Modulo         = 0x2200,
		
		Addition       = 0x2300,
		Subtraction    = 0x2300,
		
		Bitwise        = 0x3000,
		
		Comparison     = 0x4000,
		Assignment     = 0x5000,
		
		Comma          = 0xF000
	}
)
