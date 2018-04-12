package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	private var _player:Player;
	private var playerBullets:FlxTypedGroup<Bullet>;
	
	public var _map:TiledLevel;
	
	override public function create():Void
	{
		_map = new TiledLevel("assets/data/mapTest.tmx", this);
		
		add(_map.backgroundLayer);
		
		add (_map.imagesLayer);
		
		add(_map.foregroundTiles);
		add(_map.BGObjects);
		add(_map.foregroundObjects);
		//add(_grpPickupSpots);
		add(_map.objectsLayer);
		
		playerBullets = new FlxTypedGroup<Bullet>();
		add(playerBullets);
		
		_player = new Player(10, 10, playerBullets);
		add(_player);
		
		
		FlxG.camera.follow(_player);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

}