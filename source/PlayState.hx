package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	private var _player:FlxSprite;
	private var _playerSpeed:Float = 900;
	
	
	override public function create():Void
	{
		_player = new FlxSprite(10, 10).makeGraphic(64, 64);
		_player.drag.x = 500;
		_player.drag.y = 500;
		_player.maxVelocity.x = _player.maxVelocity.y = 150;
		add(_player);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

}