if not MMM_M9k_IsBaseInstalled then return end -- Make sure the base is installed!

SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Commissioned"
SWEP.PrintName = "Lynx-47"

SWEP.Slot = 2
SWEP.HoldType = "smg"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/m9kr-commissioned-lynx47/v_smg_p90.mdl"
SWEP.WorldModel = "models/m9kr-commissioned-lynx47/w_smg_mtp.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/m9kr-commissioned-lynx47/mag-out.wav",
		iDelay = 0.30
	},
	{
		sSound = "weapons/m9kr-commissioned-lynx47/mag-in1.wav",
		iDelay = 0.30 + 0.85
	},
	{
		sSound = "weapons/m9kr-commissioned-lynx47/mag-in2.wav",
		iDelay = 0.30 + 0.85 + 0.25
	},
	{
		sSound = "weapons/m9kr-commissioned-lynx47/mag-close.wav",
		iDelay = 0.30 + 0.85 + 0.25 + 0.65
	},
	{
		sSound = "weapons/m9kr-commissioned-lynx47/bolt-release2.wav",
		iDelay = 0.30 + 0.85 + 0.25 + 0.65 + 0.65
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/m9kr-commissioned-lynx47/bolt-back.wav",
		iDelay = 0.10
	},
	{
		sSound = "weapons/m9kr-commissioned-lynx47/bolt-release.wav",
		iDelay = 0.10 + 0.25
	}
}

SWEP.Primary.Sound = "weapons/m9kr-commissioned-lynx47/fire1.wav"

SWEP.Primary.RPM = 800
SWEP.Primary.ClipSize = 48
SWEP.Primary.KickUp = 1.1
SWEP.Primary.KickDown = 1.2
SWEP.Primary.KickHorizontal = 1.25
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 18
SWEP.Primary.Spread = .038
SWEP.Primary.Ammo = "smg1"

SWEP.IronSightsPos = Vector(-3.37,-3,1.2)
SWEP.IronSightsAng = Vector(-0.95,0.1,0)

SWEP.bAr2Tracer = true

SWEP.MuzzleFlashCol = {
	r = 0,
	g = 161,
	b = 255
}


-- Fix world-model position

SWEP.WorldModelScale = Vector(1,1,1)
SWEP.ModelWorldForwardMult = 0
SWEP.ModelWorldRightMult = 1
SWEP.ModelWorldUpMult = 3.75
SWEP.ModelWorldAngForward = 0
SWEP.ModelWorldAngRight = 180
SWEP.ModelWorldAngUp = 180

function SWEP:CreateWorldModel()
	if IsValid(self.WorldEnt) then self.WorldEnt:Remove() end

	self.WorldEnt = ClientsideModel(self.WorldModelStr or self.WorldModel,RENDERGROUP_OPAQUE)
	self.WorldEnt:SetPos(self:GetPos())
	self.WorldEnt:SetAngles(self:GetAngles())
	self.WorldEnt:SetParent(self)
	self.WorldEnt:SetNoDraw(true)

	if self.WorldTexture then
		self.WorldEnt:SetMaterial(self.WorldTexture)
	end

	self.WorldMatrix = Matrix()
	self.WorldMatrix:Scale(self.WorldModelScale)
end

function SWEP:DrawWorldModel()

	if self.DoNotUseWorldModel or not IsValid(self.Owner) then -- Can be used to use the default worldmodel // Weapon is dropped
		self:DrawModel()

		return true
	end


	if not IsValid(self.WorldEnt) then
		self:CreateWorldModel()

		return -- Prevent error in the same tick
	end


	self.CachedWorldBone = self.CachedWorldBone or self.Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- This is faster than looking it up every frame!
	if not self.CachedWorldBone then return end -- Thanks to wrefgtzweve on GitHub for finding this.


	local vPos, aAng = self.Owner:GetBonePosition(self.CachedWorldBone)

	self.WorldEnt:SetPos(vPos + aAng:Forward() * self.ModelWorldForwardMult + aAng:Right() * self.ModelWorldRightMult + aAng:Up() * self.ModelWorldUpMult)

	aAng:RotateAroundAxis(aAng:Forward(),self.ModelWorldAngForward)
	aAng:RotateAroundAxis(aAng:Right(),self.ModelWorldAngRight)
	aAng:RotateAroundAxis(aAng:Up(),self.ModelWorldAngUp)

	self.WorldEnt:SetAngles(aAng)
	self.WorldEnt:EnableMatrix("RenderMultiply",self.WorldMatrix)
	self.WorldEnt:DrawModel()
end