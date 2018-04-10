package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ninjaMuffin
 */
class Bullet extends FlxSprite 
{
	private var life:Float = 3;
	public var speed:Float;
	public var xdir = Math.cos(Player.mouseRot);
	public var ydir = Math.sin(Player.mouseRot);
	public var damage:Float;
	
	public function new(?X:Float=0, ?Y:Float=0, Speed:Float, Damage:Float) 
	{
		super(X, Y);
		
		makeGraphic(32, 20);
		
		x += xdir * 35;
		y += ydir * 35;
		
		speed = Speed;
		
		velocity.x = xdir * speed;
		velocity.y = ydir * speed;
		
		angle = FlxAngle.asDegrees(Player.mouseRot);
		
		
		//dir = Direction;
		damage = Damage;
		
		//velocity.y = FlxG.random.float( -25, 25);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		/*
		if (dir == FlxObject.LEFT)
		{
			velocity.x = -speed;
		}
		if (dir == FlxObject.RIGHT)
		{
			velocity.x = speed;
		}
		*/
		life -= FlxG.elapsed;
		if (life < 0)
		{
			kill();
		}
		
	}
	
}