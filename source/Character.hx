package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ninjaMuffin
 */
class Character extends FlxSprite
{
	public var followSpeed:Int = 150;
	public var _playerSpeed:Float = 2700;
	private var _playerDrag:Float = 900;
	private var playerMaxVel:Float = 350;
	private var curRads:Float = 0;
	public var accuracy:Float = 1;
	

	public var tartgetLook:FlxPoint = FlxPoint.get();
	public var firerate:Int = 0;
	private var curFirtime:Int = 0;
	public var canFire:Bool = false;
	public var isDead:Bool = false;
	
	public var bulletArray:FlxTypedGroup<Bullet>;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
		
		health = 10;
		
		makeGraphic(64, 28);
		
		width = 40;
		height = 40;
		offset.x = 12;
		offset.y = -6;
		
		drag.x = _playerDrag;
		drag.y = _playerDrag;
		maxVelocity.x = maxVelocity.y = playerMaxVel;
		
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		rotation();
		firingHandling();
		
		if (health <= 0 && !isDead)
		{
			FlxG.camera.shake(0.02, 0.02);
			isDead = true;
		}
	}
	
	private function firingHandling():Void
	{
		if (!canFire)
		{
			curFirtime += 1;
		}
		
		if (curFirtime >= firerate)
		{
			canFire = true;
			curFirtime = 0;
		}
	}

	private function rotation():Void
	{
		var rads:Float = Math.atan2(tartgetLook.y - this.y, tartgetLook.x - this.x);
		curRads = rads;
		
		var degs = FlxAngle.asDegrees(rads);
		//FlxG.watch.addQuick("Degs/Angle", degs);
		angle = degs + 90;
	}

	public function attack(bullType:String):Void
	{
		if (canFire)
		{
			var newBullet = new Bullet(getMidpoint().x, getMidpoint().y, 1000, 60, curRads);
			newBullet.accuracy = accuracy;
			newBullet.bType = bullType;
			bulletArray.add(newBullet);
			canFire = false;
		}
		
	}

}