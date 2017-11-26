HTTP.HTTPCodes = Enum (
	{
		-- Informational
		Continue                                                            = 100,
		SwitchingProtocols                                                  = 101,
		Processing                                                          = 102,
		
		-- Success
		OK                                                                  = 200,
		Created                                                             = 201,
		Accepted                                                            = 202,
		NonAuthoritativeInformation                                         = 203,
		NoContent                                                           = 204,
		ResetContent                                                        = 205,
		PartialContent                                                      = 206,
		MultiStatus                                                         = 207,
		AlreadyReported                                                     = 208,
		IMUsed                                                              = 226,
		
		-- Redirection
		MultipleChoices                                                     = 300,
		MovedPermanently                                                    = 301,
		Found                                                               = 302,
		SeeOther                                                            = 303,
		NotModified                                                         = 304,
		UseProxy                                                            = 305,
		SwitchProxy                                                         = 306,
		TemporaryRedirect                                                   = 307,
		PermanentRedirect                                                   = 308,
		
		-- Client error
		BadRequest                                                          = 400,
		Unauthorized                                                        = 401,
		PaymentRequired                                                     = 402,
		Forbidden                                                           = 403,
		NotFound                                                            = 404,
		MethodNotAllowed                                                    = 405,
		NotAcceptable                                                       = 406,
		ProxyAuthenticationRequired                                         = 407,
		RequestTimeout                                                      = 408,
		Conflict                                                            = 409,
		Gone                                                                = 410,
		LengthRequired                                                      = 411,
		PreconditionFailed                                                  = 412,
		PayloadTooLarge                                                     = 413,
		URITooLong                                                          = 414,
		UnsupportedMediaType                                                = 415,
		RangeNotSatisfiable                                                 = 416,
		ExpectationFailed                                                   = 417,
		ImATeapot                                                           = 418,
		MisdirectedRequest                                                  = 421,
		UnprocessableEntity                                                 = 422,
		Locked                                                              = 423,
		FailedDependency                                                    = 424,
		UpgradeRequired                                                     = 426,
		PreconditionRequired                                                = 428,
		TooManyRequests                                                     = 429,
		RequestHeaderFieldsTooLarge                                         = 431,
		UnavailableForLegalReasons                                          = 451,
		
		-- Server error
		InternalServerError                                                 = 500,
		NotImplemented                                                      = 501,
		BadGateway                                                          = 502,
		ServiceUnavailable                                                  = 503,
		GatewayTimeout                                                      = 504,
		HTTPVersionNotSupported                                             = 505,
		VariantAlsoNegotiates                                               = 506,
		InsufficientStorage                                                 = 507,
		LoopDetected                                                        = 508,
		NotExtended                                                         = 510,
		NetworkAuthenticationRequired                                       = 511,
		
		Checkpoint                                                          = 103,
		MethodFailure                                                       = 420,
		EnhanceYourCalm                                                     = 420,
		BlockedByWindowsParentalControls                                    = 450,
		InvalidToken                                                        = 498,
		TokenRequired                                                       = 499,
		RequestHasBeenForbiddenByAntivirus                                  = 499,
		BandwidthLimitExceeded                                              = 509,
		
		-- Internet Information Services
		LoginTimeout                                                        = 440,
		RetryWith                                                           = 449,
		Redirect                                                            = 451,
		
		-- nginx
		NoResponse                                                          = 444,
		SSLCertificateError                                                 = 495,
		SSLCertificateRequired                                              = 496,
		HTTPRequestSentToHTTPSPort                                          = 497,
		ClientClosedRequest                                                 = 499,
		
		-- CloudFlare
		UnknownError                                                        = 520,
		WebServerIsDown                                                     = 521,
		ConnectionTimedOut                                                  = 522,
		OriginIsUnreachable                                                 = 523,
		ATimeoutOccurred                                                    = 524,
		SSLHandshakeFailed                                                  = 525,
		InvalidSSLCertificate                                               = 526,
		
		-- Developer errors
		-- Inexcusable
		Meh                                                                 = 701,
		Emacs                                                               = 702,
		Explosion                                                           = 703,
		GotoFail                                                            = 704,
		IWroteTheCodeAndMissedTheNecessaryValidationByAnOversight           = 705,
		
		-- Novelty implementations
		PHP                                                                 = 710,
		ConvenienceStore                                                    = 711,
		NoSQL                                                               = 712,
		Haskell                                                             = 718,
		IAmNotATeapot                                                       = 719,
		
		-- Edge cases
		Unpossible                                                          = 720,
		KnownUnknowns                                                       = 721,
		UnknownUnknowns                                                     = 722,
		Tricky                                                              = 723,
		ThisLineShouldBeUnreachable                                         = 724,
		ItWorksOnMyMachine                                                  = 725,
		ItsAFeatureNotABug                                                  = 726,
		ThirtyTwoBitsIsPlenty                                               = 727,
		
		-- Fucking
		FuckingBower                                                        = 730,
		FuckingRubygems                                                     = 731,
		FuckingUnic💩de                                                      = 732,
		FuckingDeadlocks                                                    = 733,
		FuckingDeferreds                                                    = 734,
		FuckingIE                                                           = 735,
		FuckingRaceConditions                                               = 736,
		FuckThreadsing                                                      = 737,
		FuckingBundler                                                      = 738,
		FuckingWindows                                                      = 739,
		
		-- Meme driven
		ComputerSaysNo                                                      = 740,
		Compiling                                                           = 741,
		AKittenDies                                                         = 742,
		IThoughtIKnewRegularExpressions                                     = 743,
		YUNOWriteIntegrationTests                                           = 744,
		IDontAlwaysTestMyCodeButWhenIDoIDoItInProduction                    = 745,
		MissedBallmerPeak                                                   = 746,
		MotherfuckingSnakesOnTheMotherfuckingPlane                          = 747,
		ConfoundedByPonies                                                  = 748,
		ReservedForChuckNorris                                              = 749,
		
		-- Syntax errors
		DidntBotherToCompileIt                                              = 750,
		SyntaxError                                                         = 753,
		TooManySemicolons                                                   = 754,
		NotEnoughSemicolons                                                 = 755,
		InsufficientlyPolite                                                = 756,
		ExcessivelyPolite                                                   = 757,
		UnexpectedT_PAAMAYIM_NEKUDOTAYIM                                    = 759,
		
		-- Substance-affected developer
		Hungover                                                            = 761,
		Stoned                                                              = 762,
		UnderCaffeinated                                                    = 763,
		OverCaffeinated                                                     = 764,
		Railscamp                                                           = 765,
		Sober                                                               = 766,
		Drunk                                                               = 767,
		AccidentallyTookSleepingPillsInsteadOfMigrainePillsDuringCrunchWeek = 768,
		QuestionableMaturityLevel                                           = 769,
		
		-- Predictable problems
		CachedForTooLong                                                    = 771,
		NotCachedLongEnough                                                 = 772,
		NotCachedAtAll                                                      = 773,
		WhyWasThisCached                                                    = 774,
		OutOfCash                                                           = 775,
		ErrorOnTheException                                                 = 776,
		Coincidence                                                         = 777,
		OffByOneError                                                       = 778,
		OffByTooManyToCountError                                            = 779,
		
		-- Somebody else's problem
		ProjectOwnerNotResponding                                           = 780,
		Operations                                                          = 781,
		QA                                                                  = 782,
		ItWasACustomerRequestHonestly                                       = 783,
		ManagementObviously                                                 = 784,
		TPSCoverSheetNotAttached                                            = 785,
		TryItNow                                                            = 786,
		FurtherFundingRequired                                              = 787,
		DesignersFinalDesignsWerent                                         = 788,
		NotMyDepartment                                                     = 789,
		
		-- Internet crashed
		TheInternetShutDownDueToCopyrightRestrictions                       = 791,
		ClimateChangeDrivenCatastrophicWeatherEvent                         = 792,
		ZombieApocalypse                                                    = 793,
		SomeoneLetPGNearAREPL                                               = 794,
		Heartbleed                                                          = 795,
		ThisIsTheLastPageOfTheInternetGoBack                                = 797,
		EndOfTheWorld                                                       = 799,
	}
)

local HTTPCodeMessages = {}

-- Informational
HTTPCodeMessages [100] = "Continue"
HTTPCodeMessages [101] = "Switching Protocols"
HTTPCodeMessages [102] = "Processing"

-- Success
HTTPCodeMessages [200] = "OK"
HTTPCodeMessages [201] = "Created"
HTTPCodeMessages [202] = "Accepted"
HTTPCodeMessages [203] = "Non-Authoritative Information"
HTTPCodeMessages [204] = "No Content"
HTTPCodeMessages [205] = "Reset Content"
HTTPCodeMessages [206] = "Partial Content"
HTTPCodeMessages [207] = "Multi-Status"
HTTPCodeMessages [208] = "Already Reported"
HTTPCodeMessages [226] = "IM Used"

-- Redirection
HTTPCodeMessages [300] = "Multiple Choices"
HTTPCodeMessages [301] = "Moved Permanently"
HTTPCodeMessages [302] = "Found"
HTTPCodeMessages [303] = "See Other"
HTTPCodeMessages [304] = "Not Modified"
HTTPCodeMessages [305] = "Use Proxy"
HTTPCodeMessages [306] = "Switch Proxy"
HTTPCodeMessages [307] = "Temporary Redirect"
HTTPCodeMessages [308] = "Permanent Redirect"

-- Client error
HTTPCodeMessages [400] = "Bad Request"
HTTPCodeMessages [401] = "Unauthorized"
HTTPCodeMessages [402] = "Payment Required"
HTTPCodeMessages [403] = "Forbidden"
HTTPCodeMessages [404] = "Not Found"
HTTPCodeMessages [405] = "Method Not Allowed"
HTTPCodeMessages [406] = "Not Acceptable"
HTTPCodeMessages [407] = "Proxy Authentication Required"
HTTPCodeMessages [408] = "Request Timeout"
HTTPCodeMessages [409] = "Conflict"
HTTPCodeMessages [410] = "Gone"
HTTPCodeMessages [411] = "Length Required"
HTTPCodeMessages [412] = "Precondition Failed"
HTTPCodeMessages [413] = "Payload Too Large"
HTTPCodeMessages [414] = "URI Too Long"
HTTPCodeMessages [415] = "Unsupported Media Type"
HTTPCodeMessages [416] = "Range Not Satisfiable"
HTTPCodeMessages [417] = "Expectation Failed"
HTTPCodeMessages [418] = "I'm a teapot"
HTTPCodeMessages [421] = "Misdirected Request"
HTTPCodeMessages [422] = "Unprocessable Entity"
HTTPCodeMessages [423] = "Locked"
HTTPCodeMessages [424] = "Failed Dependency"
HTTPCodeMessages [426] = "Upgrade Required"
HTTPCodeMessages [428] = "Precondition Required"
HTTPCodeMessages [429] = "Too Many Requests"
HTTPCodeMessages [431] = "Request Header Fields Too Large"
HTTPCodeMessages [451] = "Unavailable For Legal Reasons"

-- Server error
HTTPCodeMessages [500] = "Internal Server Error"
HTTPCodeMessages [501] = "Not Implemented"
HTTPCodeMessages [502] = "Bad Gateway"
HTTPCodeMessages [503] = "Service Unavailable"
HTTPCodeMessages [504] = "Gateway Timeout"
HTTPCodeMessages [505] = "HTTP Version Not Supported"
HTTPCodeMessages [506] = "Variant Also Negotiates"
HTTPCodeMessages [507] = "Insufficient Storage"
HTTPCodeMessages [508] = "Loop Detected"
HTTPCodeMessages [510] = "Not Extended"
HTTPCodeMessages [511] = "Network Authentication Required"

HTTPCodeMessages [103] = "Checkpoint"
-- HTTPCodeMessages [420] = "Method Failure"
HTTPCodeMessages [420] = "Enhance Your Calm"
HTTPCodeMessages [450] = "Blocked by Windows Parental Controls"
HTTPCodeMessages [498] = "Invalid Token"
-- HTTPCodeMessages [499] = "Token Required"
-- HTTPCodeMessages [499] = "Request has been forbidden by antivirus"
HTTPCodeMessages [509] = "Bandwidth Limit Exceeded"

-- Internet Information Services
HTTPCodeMessages [440] = "Login Timeout"
HTTPCodeMessages [449] = "Retry With"
-- HTTPCodeMessages [451] = "Redirect"

-- nginx
HTTPCodeMessages [444] = "No Response"
HTTPCodeMessages [495] = "SSL Certificate Error"
HTTPCodeMessages [496] = "SSL Certificate Required"
HTTPCodeMessages [497] = "HTTP Request Sent to HTTPS Port"
HTTPCodeMessages [499] = "Client Closed Request"

-- CloudFlare
HTTPCodeMessages [520] = "Unknown Error"
HTTPCodeMessages [521] = "Web Server Is Down"
HTTPCodeMessages [522] = "Connection Timed Out"
HTTPCodeMessages [523] = "Origin Is Unreachable"
HTTPCodeMessages [524] = "A Timeout Occurred"
HTTPCodeMessages [525] = "SSL Handshake Failed"
HTTPCodeMessages [526] = "Invalid SSL Certificate"

-- Developer errors
-- Inexcusable
HTTPCodeMessages [701] = "Meh"
HTTPCodeMessages [702] = "Emacs"
HTTPCodeMessages [703] = "Explosion"
HTTPCodeMessages [704] = "Goto Fail"
HTTPCodeMessages [705] = "I wrote the code and missed the necessary validation by an oversight"

-- Novelty implementations
HTTPCodeMessages [710] = "PHP"
HTTPCodeMessages [711] = "Convenience Store"
HTTPCodeMessages [712] = "NoSQL"
HTTPCodeMessages [718] = "Haskell"
HTTPCodeMessages [719] = "I am not a teapot"

-- Edge cases
HTTPCodeMessages [720] = "Unpossible"
HTTPCodeMessages [721] = "Known Unknowns"
HTTPCodeMessages [722] = "Unknown Unknowns"
HTTPCodeMessages [723] = "Tricky"
HTTPCodeMessages [724] = "This line should be unreachable"
HTTPCodeMessages [725] = "It works on my machine"
HTTPCodeMessages [726] = "It's a feature, not a bug"
HTTPCodeMessages [727] = "32 bits is plenty"

-- Fucking
HTTPCodeMessages [730] = "Fucking Bower"
HTTPCodeMessages [731] = "Fucking Rubygems"
HTTPCodeMessages [732] = "Fucking Unic💩de"
HTTPCodeMessages [733] = "Fucking Deadlocks"
HTTPCodeMessages [734] = "Fucking Deferreds"
HTTPCodeMessages [735] = "Fucking IE"
HTTPCodeMessages [736] = "Fucking Race Conditions"
HTTPCodeMessages [737] = "FuckThreadsing"
HTTPCodeMessages [738] = "Fucking Bundler"
HTTPCodeMessages [739] = "Fucking Windows"

-- Meme driven
HTTPCodeMessages [740] = "Computer says no"
HTTPCodeMessages [741] = "Compiling"
HTTPCodeMessages [742] = "A kitten dies"
HTTPCodeMessages [743] = "I thought I knew regular expressions"
HTTPCodeMessages [744] = "Y U NO write integration tests?"
HTTPCodeMessages [745] = "I don't always test my code, but when I do I do it in production"
HTTPCodeMessages [746] = "Missed Ballmer Peak"
HTTPCodeMessages [747] = "Motherfucking Snakes on the Motherfucking Plane"
HTTPCodeMessages [748] = "Confounded by Ponies"
HTTPCodeMessages [749] = "Reserved for Chuck Norris"

-- Syntax errors
HTTPCodeMessages [750] = "Didn't bother to compile it"
HTTPCodeMessages [753] = "Syntax Error"
HTTPCodeMessages [754] = "Too many semi-colons"
HTTPCodeMessages [755] = "Not enough semi-colons"
HTTPCodeMessages [756] = "Insufficiently polite"
HTTPCodeMessages [757] = "Excessively polite"
HTTPCodeMessages [759] = "Unexpected T_PAAMAYIM_NEKUDOTAYIM"

-- Substance-affected developer
HTTPCodeMessages [761] = "Hungover"
HTTPCodeMessages [762] = "Stoned"
HTTPCodeMessages [763] = "Under-Caffeinated"
HTTPCodeMessages [764] = "Over-Caffeinated"
HTTPCodeMessages [765] = "Railscamp"
HTTPCodeMessages [766] = "Sober"
HTTPCodeMessages [767] = "Drunk"
HTTPCodeMessages [768] = "Accidentally Took Sleeping Pills Instead Of Migraine Pills During Crunch Week"
HTTPCodeMessages [769] = "Questionable Maturity Level"

-- Predictable problems
HTTPCodeMessages [771] = "Cached for too long"
HTTPCodeMessages [772] = "Not cached long enough"
HTTPCodeMessages [773] = "Not cached at all"
HTTPCodeMessages [774] = "Why was this cached?"
HTTPCodeMessages [775] = "Out of cash"
HTTPCodeMessages [776] = "Error on the Exception"
HTTPCodeMessages [777] = "Coincidence"
HTTPCodeMessages [778] = "Off By One Error"
HTTPCodeMessages [779] = "Off By Too Many To Count Error"

-- Somebody else's problem
HTTPCodeMessages [780] = "Project owner not responding"
HTTPCodeMessages [781] = "Operations"
HTTPCodeMessages [782] = "QA"
HTTPCodeMessages [783] = "It was a customer request, honestly"
HTTPCodeMessages [784] = "Management, obviously"
HTTPCodeMessages [785] = "TPS Cover Sheet not attached"
HTTPCodeMessages [786] = "Try it now"
HTTPCodeMessages [787] = "Further Funding Required"
HTTPCodeMessages [788] = "Designer's final designs weren't"
HTTPCodeMessages [789] = "Not my department"

-- Internet crashed
HTTPCodeMessages [791] = "The Internet shut down due to copyright restrictions"
HTTPCodeMessages [792] = "Climate change driven catastrophic weather event"
HTTPCodeMessages [793] = "Zombie Apocalypse"
HTTPCodeMessages [794] = "Someone let PG near a REPL"
HTTPCodeMessages [795] = "#heartbleed"
HTTPCodeMessages [797] = "This is the last page of the Internet. Go back"
HTTPCodeMessages [799] = "End of the world"

function HTTP.HTTPCodes.ToMessage (code)
	return HTTPCodeMessages [code]
end
