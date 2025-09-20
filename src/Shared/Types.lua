export type Weapon = {
	Item: string,
	Type: string,
	Price: number,
	Durability: number,
	Level: number,
	Damage: number,
	Speed: number,
	Rarity: number,
}

export type Equipment = {
	Model: Model?,
	Data: Weapon?,
	RigidConstraint: RigidConstraint?,
	Motor6D: Motor6D?,
}

return true
