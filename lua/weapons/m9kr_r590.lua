if not MMM_M9k_IsBaseInstalled then return end -- Make sure the base is installed!

SWEP.Base = "bobs_shotty_base"
SWEP.Category = "M9kR: Commissioned"
SWEP.PrintName = "Remington 590"

SWEP.Spawnable = true

SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/m9kr-commissioned-r590/v_shot_xm1014.mdl"
SWEP.WorldModel = "models/m9kr-commissioned-r590/w_shot_xm1014.mdl"

SWEP.ReloadSound = "weapons/m9kr-commissioned-r590/shell_insert.wav"

SWEP.DrawSound = "weapons/m9kr-commissioned-r590/deploy.wav"

SWEP.Primary.Sound = "weapons/m9kr-commissioned-r590/fire.wav"

SWEP.Primary.RPM = 240
SWEP.Primary.ClipSize = 8
SWEP.Primary.KickUp = 4
SWEP.Primary.KickDown = 2
SWEP.Primary.KickHorizontal = 10
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 40
SWEP.Primary.Damage = 3
SWEP.Primary.Spread = .17
SWEP.Primary.Ammo = "buckshot"

SWEP.IronSightsPos = Vector(-1.72,0,0.55)
SWEP.IronSightsAng = Vector(0.55,0,0)


-- Fix world-model position

SWEP.WorldModelScale = Vector(1,1,1)
SWEP.ModelWorldForwardMult = 2.5
SWEP.ModelWorldRightMult = 0
SWEP.ModelWorldUpMult = 1
SWEP.ModelWorldAngForward = 0
SWEP.ModelWorldAngRight = 170
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


-- These are required for firstperson

sound.Add({
	name = "r590.insert",
	channel = CHAN_ITEM,
	volume = 1.0,
	sound = "weapons/m9kr-commissioned-r590/shell_insert.wav"
})