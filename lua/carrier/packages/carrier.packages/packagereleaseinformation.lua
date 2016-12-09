local self = {}
Packages.PackageReleaseInformation = Class (self, ICloneable, ISerializable)

function Packages.PackageReleaseInformation.FromTable (t, out)
	out = out or Packages.PackageReleaseInformation ()
	
	return out:FromTable (t)
end

self.Id               = Property (nil, "UInt64")

self.VersionTimestamp = Property (nil, "UInt64")
self.VersionName      = Property (nil, "StringN8",  true)

self.FileName         = Property (nil, "StringN16", true)
self.FileSize         = Property (nil, "UInt64?",   true)

self.DownloadUrl      = Property (nil, "StringN16", true)

function self:ctor ()
end

function self:FromTable (source)
	self.Id               = source.id
	
	self.VersionTimestamp = source.versionTimestamp
	self.VersionName      = source.versionName
	
	self.FileName         = source.fileName
	self.FileSize         = source.fileSize
	
	self.DownloadUrl      = source.downloadUrl
	
	return self
end
