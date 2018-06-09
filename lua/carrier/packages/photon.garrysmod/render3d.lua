local self = {}
Render3d = Class (self, Photon.IRender3d)

local cam_PushModelMatrix = cam.PushModelMatrix
local cam_PopModelMatrix  = cam.PopModelMatrix

local VMatrix_SetField = debug.getregistry ().VMatrix.SetField

local Cat_Matrix4x4d_Clone          = Cat.Matrix4x4d.Clone
local Cat_Matrix4x4d_MatrixMultiply = Cat.Matrix4x4d.MatrixMultiply

function self:ctor (graphicsContext)
	self.GraphicsContext = graphicsContext
	
	self.RenderTarget = nil
	self.RenderTargetStack = {}
	
	self.ModelMatrixStack = { Cat.Matrix4x4d.Identity () }
	self.ModelMatrixStackCount = 1
end

-- IRender3d
function self:GetGraphicsContext ()
	return self.GraphicsContext
end

function self:GetRender2d ()
	return self.GraphicsContext:GetRender2d ()
end

-- Render targets
function self:PushRenderTarget (renderTarget)
	self.RenderTarget = renderTarget
	self.RenderTargetStack [#self.RenderTargetStack + 1] = renderTarget
	if #self.RenderTargetStack == 1 then
		render.OverrideAlphaWriteEnable (true, true)
		render.OverrideBlendFunc (true, BLEND_SRC_ALPHA, BLEND_ONE_MINUS_SRC_ALPHA, BLEND_ONE, BLEND_ONE)
		surface.DisableClipping (true)
	end
	
	render.PushRenderTarget (renderTarget:GetHandle ())
end

function self:PopRenderTarget ()
	render.PopRenderTarget ()
	
	self.RenderTargetStack [#self.RenderTargetStack] = nil
	self.RenderTarget = self.RenderTargetStack [#self.RenderTargetStack]
	
	if #self.RenderTargetStack == 0 then
		render.OverrideAlphaWriteEnable (false)
		render.OverrideBlendFunc (false)
		surface.DisableClipping (false)
	end
end

function self:WithRenderTarget (renderTarget, f)
	self:PushRenderTarget (renderTarget)
	local success, err = xpcall (f, debug.traceback)
	self:PopRenderTarget ()
	
	if not success then
		ErrorNoHalt (err)
	end
end

function self:ClearRenderTarget ()
	if self.RenderTarget:HasDepthStencilBuffer () then
		render.ClearDepth ()
	end
	
	render.Clear (0, 0, 0, 0)
end

-- Transforms
local affineVMatrix = Matrix ()
function self:PushModelMatrix (matrix4x4d)
	self.ModelMatrixStackCount = self.ModelMatrixStackCount + 1
	if #self.ModelMatrixStack < self.ModelMatrixStackCount then
		self.ModelMatrixStack [#self.ModelMatrixStack + 1] = Cat.Matrix4x4d ()
	end
	
	Cat_Matrix4x4d_Clone (matrix4x4d, self.ModelMatrixStack [self.ModelMatrixStackCount])
	
	self:Matrix4x4dToVMatrixAffine (self.ModelMatrixStack [self.ModelMatrixStackCount], affineVMatrix)
	cam_PushModelMatrix (affineVMatrix)
end

function self:PushModelMatrixMultiplyLeft (matrix4x4d)
	self.ModelMatrixStackCount = self.ModelMatrixStackCount + 1
	if #self.ModelMatrixStack < self.ModelMatrixStackCount then
		self.ModelMatrixStack [#self.ModelMatrixStack + 1] = Cat.Matrix4x4d ()
	end
	
	Cat_Matrix4x4d_MatrixMultiply (matrix4x4d, self.ModelMatrixStack [self.ModelMatrixStackCount - 1], self.ModelMatrixStack [self.ModelMatrixStackCount])
	
	self:Matrix4x4dToVMatrixAffine (self.ModelMatrixStack [self.ModelMatrixStackCount], affineVMatrix)
	cam_PushModelMatrix (affineVMatrix)
end

function self:PushModelMatrixMultiplyRight (matrix4x4d)
	self.ModelMatrixStackCount = self.ModelMatrixStackCount + 1
	if #self.ModelMatrixStack < self.ModelMatrixStackCount then
		self.ModelMatrixStack [#self.ModelMatrixStack + 1] = Cat.Matrix4x4d ()
	end
	
	Cat_Matrix4x4d_MatrixMultiply (self.ModelMatrixStack [self.ModelMatrixStackCount - 1], matrix4x4d, self.ModelMatrixStack [self.ModelMatrixStackCount])
	
	self:Matrix4x4dToVMatrixAffine (self.ModelMatrixStack [self.ModelMatrixStackCount], affineVMatrix)
	cam_PushModelMatrix (affineVMatrix)
end

function self:PopModelMatrix ()
	self.ModelMatrixStackCount = self.ModelMatrixStackCount - 1
	cam_PopModelMatrix ()
end

function self:WithModelMatrix (matrix4x4d, f)
	self:PushModelMatrix (matrix4x4d)
	local success, err = xpcall (f, debug.traceback)
	self:PopModelMatrix ()
	
	if not success then
		ErrorNoHalt (err)
	end
end

function self:WithModelMatrixMultiplyLeft (matrix4x4d, f)
	self:PushModelMatrixMultiplyLeft (matrix4x4d)
	local success, err = xpcall (f, debug.traceback)
	self:PopModelMatrix ()
	
	if not success then
		ErrorNoHalt (err)
	end
end

function self:WithModelMatrixMultiplyRight (matrix4x4d, f)
	self:PushModelMatrixMultiplyRight (matrix4x4d)
	local success, err = xpcall (f, debug.traceback)
	self:PopModelMatrix ()
	
	if not success then
		ErrorNoHalt (err)
	end
end

-- Render3d
function self:Matrix4x4dToVMatrixAffine (matrix4x4d, out)
	local out = out or Matrix ()
	VMatrix_SetField (out, 1, 1, matrix4x4d [0]) VMatrix_SetField (out, 1, 2, matrix4x4d [1]) VMatrix_SetField (out, 1, 3, matrix4x4d [ 2]) VMatrix_SetField (out, 1, 4, matrix4x4d [ 3])
	VMatrix_SetField (out, 2, 1, matrix4x4d [4]) VMatrix_SetField (out, 2, 2, matrix4x4d [5]) VMatrix_SetField (out, 2, 3, matrix4x4d [ 6]) VMatrix_SetField (out, 2, 4, matrix4x4d [ 7])
	VMatrix_SetField (out, 3, 1, matrix4x4d [8]) VMatrix_SetField (out, 3, 2, matrix4x4d [9]) VMatrix_SetField (out, 3, 3, matrix4x4d [10]) VMatrix_SetField (out, 3, 4, matrix4x4d [11])
	return out
end

function self:Matrix4x4dToVMatrix (matrix4x4d, out)
	local out = out or Matrix ()
	VMatrix_SetField (out, 1, 1, matrix4x4d [ 0]) VMatrix_SetField (out, 1, 2, matrix4x4d [ 1]) VMatrix_SetField (out, 1, 3, matrix4x4d [ 2]) VMatrix_SetField (out, 1, 4, matrix4x4d [ 3])
	VMatrix_SetField (out, 2, 1, matrix4x4d [ 4]) VMatrix_SetField (out, 2, 2, matrix4x4d [ 5]) VMatrix_SetField (out, 2, 3, matrix4x4d [ 6]) VMatrix_SetField (out, 2, 4, matrix4x4d [ 7])
	VMatrix_SetField (out, 3, 1, matrix4x4d [ 8]) VMatrix_SetField (out, 3, 2, matrix4x4d [ 9]) VMatrix_SetField (out, 3, 3, matrix4x4d [10]) VMatrix_SetField (out, 3, 4, matrix4x4d [11])
	VMatrix_SetField (out, 4, 1, matrix4x4d [12]) VMatrix_SetField (out, 4, 2, matrix4x4d [13]) VMatrix_SetField (out, 4, 3, matrix4x4d [14]) VMatrix_SetField (out, 4, 4, matrix4x4d [15])
	return out
end

function self:PushModelMatrixCorrection (matrix4x4d)
	self.ModelMatrixStackCount = self.ModelMatrixStackCount + 1
	if #self.ModelMatrixStack < self.ModelMatrixStackCount then
		self.ModelMatrixStack [#self.ModelMatrixStack + 1] = Cat.Matrix4x4d ()
	end
	
	Cat_Matrix4x4d_Clone (matrix4x4d, self.ModelMatrixStack [self.ModelMatrixStackCount])
end

function self:PopModelMatrixCorrection ()
	self.ModelMatrixStackCount = self.ModelMatrixStackCount - 1
end

function self:WithModelMatrixCorrection (matrix4x4d, f)
	self:PushModelMatrixCorrection (matrix4x4d)
	local success, err = xpcall (f, debug.traceback)
	self:PopModelMatrixCorrection ()
	
	if not success then
		ErrorNoHalt (err)
	end
end
