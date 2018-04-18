package;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;

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
		playerMaxVel = 480;
		_playerSpeed = 4000;
		_playerDrag = 2310;
		maxHealth = 4.5;
		
		maxVelocity.set(playerMaxVel, playerMaxVel);
		drag.set(_playerDrag, _playerDrag);
		
		loadGraphic("assets/images/picoSheet.png", true, 64, 28);
		animation.add("idle", [0, 1, 2], 12);
		animation.add("walk", [3, 4, 5, 6, 5, 4], 12);
		animation.play("idle");
		setGraphicSize(Std.int(width * 1.5));
		
		resizeHitbox();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (velocity.x != 0 || velocity.y != 0)
		{
			animation.play("walk");
		}
		else
		{
			animation.play("idle");
		}
		
		FlxG.watch.addQuick("rads: ", curRads);
		
		if (health > maxHealth)
		{
			health = maxHealth;
		}
		
		if (health < maxHealth && (velocity.x != 0 || velocity.y != 0))
		{
			health += 0.13 * FlxG.elapsed;
		}
		
		
		if (moveTime <= 15)
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
			FlxG.camera.shake(0.01, 0.08);
			attack("Player");
		}
	}

}