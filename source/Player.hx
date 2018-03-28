package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ninjaMuffin
 */
class Player extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		drag.x = 500;
		drag.y = 500;
		maxVelocity.x = _player.maxVelocity.y = 150;
		
	}
	
	private function controls():Void
	{
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
				mA = -90;
				if (_left)
					mA -= 45;
				else if (_right)
					mA += 45;
			}
			else if (_down)
			{
				mA = 90;
				if (_left)
					mA += 45;
				else if (_right)
					mA -= 45;
			}
			else if (_left)
				mA = 180;
			else if (_right)
				mA = 0;
			
			_player.acceleration.set(_playerSpeed, 0);
			_player.acceleration.rotate(FlxPoint.weak(0, 0), mA);
		}
		else
		{
			_player.acceleration.x = _player.acceleration.y = 0;
		}
	}
	
}