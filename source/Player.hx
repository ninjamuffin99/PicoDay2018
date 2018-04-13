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
class Player extends Character 
{
	public static var mouseRot:Float;
	public var playerMovePosition:FlxPoint = new FlxPoint();
	private var moveTime:Int = 0;

	public function new(?X:Float=0, ?Y:Float=0, playerBulletArray:FlxTypedGroup<Bullet>) 
	{
		super(X, Y);
		
		bulletArray = playerBulletArray;
		playerMaxVel = 450;
		_playerSpeed = 3500;
		_playerDrag = 1450;
		
		maxVelocity.set(playerMaxVel, playerMaxVel);
		drag.set(_playerDrag, _playerDrag);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (moveTime <= 12)
		{
			moveTime = 0;
			playerMovePosition = getPosition();
		}
		else
		{
			moveTime += 1;
		}
		
		controls();
		mouseRot = curRads;
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
			attack("Player");
		}
	}

}