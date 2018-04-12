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
class Player extends FlxSprite 
{
	public static var mouseRot:Float;
	
	private var bulletArray:FlxTypedGroup<Bullet>;
	
	private var _playerSpeed:Float = 2700;
	private var _playerDrag:Float = 900;
	private var playerMaxVel:Float = 350;

	public function new(?X:Float=0, ?Y:Float=0, playerBulletArray:FlxTypedGroup<Bullet>) 
	{
		super(X, Y);
		
		makeGraphic(64, 28);
		
		drag.x = _playerDrag;
		drag.y = _playerDrag;
		maxVelocity.x = maxVelocity.y = playerMaxVel;
		
		bulletArray = playerBulletArray;
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		controls();
		rotation();
	}
	
	private function controls():Void
	{
		mouseControl();
		
		var _left:Bool = FlxG.keys.anyPressed(["A", "LEFT"]);
		var _right:Bool = FlxG.keys.anyPressed(["D", "RIGHT"]);
		var _down:Bool = FlxG.keys.anyPressed(["S", "DOWN"]);
		var _up:Bool = FlxG.keys.anyPressed(["W", "UP"]);
		
		if (_left && _right)
		{
			_left = _right = false;
		}
		
		if (_up && _down)
		{
			_up = _down = false;
		}
		
		if (_left || _right || _up || _down)
		{
			var mA:Float = 0;
			if (_up)
			{
				acceleration.y = -_playerSpeed;
			}
			else if (_down)
			{
				acceleration.y = _playerSpeed;
			}
			else
				acceleration.y = 0;
			
			if (_left)
				acceleration.x = -_playerSpeed;
			else if (_right)
				acceleration.x = _playerSpeed;
			else
				acceleration.x = 0;
			
			//acceleration.set(_playerSpeed, 0);
			//acceleration.rotate(FlxPoint.weak(0, 0), mA);
		}
		else
		{
			acceleration.x = acceleration.y = 0;
		}
	}
	
	private function mouseControl():Void
	{
		var mClicked:Bool = FlxG.mouse.justPressed;
		
		if (mClicked)
		{
			attack();
		}
	}
	
	private function attack():Void
	{
		var newBullet = new Bullet(this.x, this.y, 1600, 60);
		bulletArray.add(newBullet);
	}
	
	private function rotation():Void
	{
		var rads:Float = Math.atan2(FlxG.mouse.y - this.y, FlxG.mouse.x - this.x);
		mouseRot = rads;
		
		var degs = FlxAngle.asDegrees(rads);
		//FlxG.watch.addQuick("Degs/Angle", degs);
		angle = degs + 90;
	}
}