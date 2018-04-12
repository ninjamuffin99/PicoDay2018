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
	private var testEnemy:Enemy;
	private var playerBullets:FlxTypedGroup<Bullet>;
	
	public var _map:TiledLevel;
	
	public var _grpEnemies:FlxTypedGroup<Enemy>;
	
	override public function create():Void
	{
		_grpEnemies = new FlxTypedGroup<Enemy>();
		
		_map = new TiledLevel("assets/data/mapTest.tmx", this);
		
		add(_map.backgroundLayer);
		add (_map.imagesLayer);
		add(_map.foregroundTiles);
		add(_map.BGObjects);
		add(_map.foregroundObjects);
		add(_map.objectsLayer);
		
		playerBullets = new FlxTypedGroup<Bullet>();
		add(playerBullets);
		
		_player = new Player(70, 70, playerBullets);
		add(_player);
		
		add(_grpEnemies);
		
		
		FlxG.camera.follow(_player);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		_player.tartgetLook.set(FlxG.mouse.x, FlxG.mouse.y);
		
		_grpEnemies.forEach(look);
		
		_map.collideWithLevel(_player);
	}
	
	private function look(e:Enemy):Void
	{
		e.tartgetLook.set(_player.x, _player.y);
	}

}