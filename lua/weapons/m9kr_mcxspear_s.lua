if not MMM_M9k_IsBaseInstalled then return end -- Make sure the base is installed!

SWEP.Base = "bobs_gun_base"
SWEP.Category = "M9kR: Commissioned"
SWEP.PrintName = "SIG MCX Spear S"

SWEP.Slot = 2
SWEP.HoldType = "ar2"
SWEP.Spawnable = true

SWEP.ViewModelFOV = 80
SWEP.ViewModel = "models/m9kr-commissioned-mcxspear/v_rif_m4a1.mdl"
SWEP.WorldModel = "models/m9kr-commissioned-mcxspear/w_rif_m4a1_silencer.mdl"

SWEP.tReloadDynamic = {
	{
		sSound = "weapons/m9kr-commissioned-mcxspear/reloadstart.wav",
		iDelay = 0.00
	},
	{
		sSound = "weapons/m9kr-commissioned-mcxspear/magout.wav",
		iDelay = 0.00 + 0.65
	},
	{
		sSound = "weapons/m9kr-commissioned-mcxspear/magin.wav",
		iDelay = 0.00 + 0.65 + 0.75
	},
	{
		sSound = "weapons/m9kr-commissioned-mcxspear/boltrelease.wav",
		iDelay = 0.00 + 0.65 + 0.75 + 0.60
	}
}

SWEP.tDrawSoundSequence = {
	{
		sSound = "weapons/m9kr-commissioned-mcxspear/deploy.wav",
		iDelay = 0.00
	},
	{
		sSound = "weapons/m9kr-commissioned-mcxspear/deploymagin.wav",
		iDelay = 0.00 + 0.45
	},
	{
		sSound = "weapons/m9kr-commissioned-mcxspear/deployend.wav",
		iDelay = 0.00 + 0.45 + 0.25
	}
}

SWEP.Primary.Sound = "weapons/m9kr-commissioned-mcxspear/fire_s1.wav"
SWEP.Primary.SoundVolume = 65 -- Silenced!

SWEP.Primary.RPM = 700
SWEP.Primary.ClipSize = 40
SWEP.Primary.KickUp = 1
SWEP.Primary.KickDown = 1.8
SWEP.Primary.KickHorizontal = 1.2
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 25
SWEP.Primary.Spread = .03
SWEP.Primary.Ammo = "ar2"

SWEP.IronSightsPos = Vector(6.9,0,1.2)
SWEP.IronSightsAng = Vector(0,0.5,-0.75)


SWEP.iIdleAnim = ACT_VM_IDLE_SILENCED
SWEP.iDeployAnim = ACT_VM_DRAW_SILENCED
SWEP.iPrimaryAnim = ACT_VM_PRIMARYATTACK_SILENCED
SWEP.iReloadAnim = ACT_VM_RELOAD_SILENCED


-- Fix world-model position

SWEP.WorldModelScale = Vector(1,1,1)
SWEP.ModelWorldForwardMult = -0.5
SWEP.ModelWorldRightMult = 1
SWEP.ModelWorldUpMult = 0
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