if not MMM_M9k_IsBaseInstalled then return end -- Make sure the base is installed!

SWEP.Base = "bobs_scoped_base"
SWEP.Category = "M9kR: Commissioned"
SWEP.PrintName = "SCAR-175"

SWEP.DynamicLightScale = 1 -- Set to Default

SWEP.Slot = 2
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/m9kr-commissioned-scar175/v_rif_aug.mdl"
SWEP.WorldModel = "models/m9kr-commissioned-scar175/w_rif_aug.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/m9kr-commissioned-scar175/cloth.wav",
		iDelay = 0.00
	},
	{
		sSound = "weapons/m9kr-commissioned-scar175/magout.wav",
		iDelay = 0.00 + 0.35
	},
	{
		sSound = "weapons/m9kr-commissioned-scar175/magin.wav",
		iDelay = 0.00 + 0.35 + 1.45
	},
	{
		sSound = "weapons/m9kr-commissioned-scar175/boltpull.wav",
		iDelay = 0.00 + 0.35 + 1.45 + 0.65
	},
	{
		sSound = "weapons/m9kr-commissioned-scar175/deploy.wav",
		iDelay = 0.00 + 0.35 + 1.45 + 0.65 + 0.65
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/m9kr-commissioned-scar175/deploy.wav",
		iDelay = 0.00
	},
	{
		sSound = "weapons/m9kr-commissioned-scar175/boltpull.wav",
		iDelay = 0.00 + 0.15
	}
}

SWEP.Primary.Sound = "weapons/m9kr-commissioned-scar175/fire1.wav"

SWEP.Primary.RPM = 600
SWEP.Primary.ClipSize = 30
SWEP.Primary.KickUp = 1.4
SWEP.Primary.KickDown = 1.5
SWEP.Primary.KickHorizontal = 1.35
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 34
SWEP.Primary.Spread = .034
SWEP.Primary.Ammo = "ar2"

SWEP.Primary.SpreadBefore = SWEP.Primary.Spread

SWEP.ScopeType = "gdcw_acog"
SWEP.ScopeStages = 1
SWEP.ScopeScale = 0.5
SWEP.ReticleScale = 0.6


-- Fix world-model position

SWEP.WorldModelScale = Vector(1,1,1)
SWEP.ModelWorldForwardMult = -1
SWEP.ModelWorldRightMult = 1
SWEP.ModelWorldUpMult = -0.5
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