package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
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
	private var angleOffset:Float = 0;
	public var accuracy:Float = 1;
	public var bType:String = "";
	
	public var damage:Float;
	
	public function new(?X:Float=0, ?Y:Float=0, Speed:Float, Damage:Float, bullAngle:Float) 
	{
		super(X, Y);
		
		loadGraphic("assets/images/bulletSheet.png", true, 32, 20);
		animation.add("play", [0, 1], 24);
		animation.play("play");
		/*
		setGraphicSize(Std.int(width * 1.3));
		updateHitbox();
		*/
		width = 10;
		height = 10;
		offset.y = 5;
		offset.x = 11;
		
		angleOffset = FlxAngle.asRadians(FlxG.random.float( -4, 4) * accuracy + FlxAngle.asDegrees(bullAngle));
		
		var xdir = Math.cos(angleOffset);
		var ydir = Math.sin(angleOffset);
		
		x += xdir * 35;
		y += ydir * 35;
		
		speed = Speed;
		
		velocity.x = xdir * speed;
		velocity.y = ydir * speed;
		
		angle = FlxAngle.asDegrees(angleOffset);
		
		
		
		//dir = Direction;
		damage = Damage;
		
		//velocity.y = FlxG.random.float( -25, 25);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		var rads:Float = Math.atan2(velocity.y, velocity.x);
		//curRads = rads;
		
		var degs = FlxAngle.asDegrees(rads);
		//FlxG.watch.addQuick("Degs/Angle", degs);
		angle = degs;
		
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