local self = {}
Photon.IRender3d = Interface (self)

function self:ctor ()
end

function self:GetGraphicsContext ()
	Error ("IRender3d:GetGraphicsContext : Not implemented.")
end

function self:GetRender2d ()
	Error ("IRender3d:GetRender2d : Not implemented.")
end

-- Render targets
function self:PushRenderTarget (renderTarget)
	Error ("IRender3d:PushRenderTarget : Not implemented.")
end

function self:PopRenderTarget ()
	Error ("IRender3d:PopRenderTarget : Not implemented.")
end

function self:WithRenderTarget (renderTarget, f)
	Error ("IRender3d:WithRenderTarget : Not implemented.")
end

function self:ClearRenderTarget ()
	Error ("IRender3d:ClearRenderTarget : Not implemented.")
end

-- Transforms
function self:PushModelMatrix (matrix4x4d)
	Error ("IRender3d:PushModelMatrix : Not implemented.")
end

function self:PushModelMatrixMultiplyLeft (matrix4x4d)
	Error ("IRender3d:PushModelMatrixMultiplyLeft : Not implemented.")
end

function self:PushModelMatrixMultiplyRight (matrix4x4d)
	Error ("IRender3d:PushModelMatrixMultiplyRight : Not implemented.")
end

function self:PopModelMatrix ()
	Error ("IRender3d:PopModelMatrix : Not implemented.")
end

function self:WithModelMatrix (matrix4x4d, f)
	Error ("IRender3d:WithModelMatrix : Not implemented.")
end

function self:WithModelMatrixMultiplyLeft (matrix4x4d, f)
	Error ("IRender3d:WithModelMatrixMultiplyLeft : Not implemented.")
end

function self:WithModelMatrixMultiplyRight (matrix4x4d, f)
	Error ("IRender3d:WithModelMatrixMultiplyRight : Not implemented.")
end
