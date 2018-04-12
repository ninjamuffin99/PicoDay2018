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
	private var _playerSpeed:Float = 2700;
	private var _playerDrag:Float = 900;
	private var playerMaxVel:Float = 350;
	private var curRads:Float = 0;

	public var tartgetLook:FlxPoint = FlxPoint.get();

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
		
		if (health <= 0)
		{
			kill();
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
		var newBullet = new Bullet(this.x, this.y, 1200, 60, curRads);
		newBullet.bType = bullType;
		bulletArray.add(newBullet);
	}

}