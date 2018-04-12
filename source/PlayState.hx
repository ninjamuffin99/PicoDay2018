package;

import flixel.FlxG;
import flixel.FlxObject;
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
	private var _camTrack:FlxObject;
	private var testEnemy:Enemy;
	private var playerBullets:FlxTypedGroup<Bullet>;
	private var enemyBullets:FlxTypedGroup<Bullet>;
	
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
		
		enemyBullets = new FlxTypedGroup<Bullet>();
		add(enemyBullets);
		
		_player = new Player(70, 70, playerBullets);
		add(_player);
		
		_camTrack = new FlxObject(0, 0, 1, 1);
		add(_camTrack);
		
		add(_grpEnemies);
		
		_grpEnemies.forEach(bulletSet);
		
		
		FlxG.camera.follow(_camTrack);
		FlxG.camera.followLerp = 0.6;
		
		super.create();
	}
	
	private function bulletSet(e:Enemy):Void
	{
		e.bulletArray = enemyBullets;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		_player.tartgetLook.set(FlxG.mouse.x, FlxG.mouse.y);
		
		
		var dx = _player.x - FlxG.mouse.x;
		var dy = _player.y - FlxG.mouse.y;
		//var length = Math.sqrt(dx * dx + dy * dy);
		dx *= 0.5;
		dy *= 0.5;
		
		_camTrack.x = _player.x - dx;
		_camTrack.y = _player.y - dy;
		
		
		_grpEnemies.forEach(look);
		
		_map.collideWithLevel(_player);
	}
	
	
	private function look(e:Enemy):Void
	{
		if (_map.collidableTileLayers[0].ray(e.getMidpoint(), _player.getMidpoint()))
		{
			e.tartgetLook.set(_player.x, _player.y);
			e.attack();
		}
		
	}

}