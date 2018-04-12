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
		
		//SHOUTOUT TO MIKE, AND ALSO BOMTOONS
		var dx = _player.x - FlxG.mouse.x;
		var dy = _player.y - FlxG.mouse.y;
		//var length = Math.sqrt(dx * dx + dy * dy);
		var camOffset = 0.4;
		dx *= camOffset;
		dy *= camOffset;
		
		if (FlxG.keys.pressed.SHIFT)
		{
			var shiftChange = 1.35;
			dx *= shiftChange;
			dy *= shiftChange;
		}
		
		_camTrack.x = _player.x - dx;
		_camTrack.y = _player.y - dy;
		
		
		_grpEnemies.forEachAlive(look);
		
		_map.collideWithLevel(_player);
		
		enemyBullets.forEachAlive(checkBulletOverlap);
		playerBullets.forEachAlive(checkBulletOverlap);
	}
	
	private function checkBulletOverlap(b:Bullet):Void
	{
		/*
		for (i in 0..._map.collidableTileLayers.length)
		{
			var tilemap = _map.collidableTileLayers[i];
			
			
			if (FlxG.overlap(b, tilemap))
			{
				b.kill();
			}
		}
		*/
		
		if (FlxG.overlap(b, _player) && b.bType == "Enemy")
		{
			b.kill();
			_player.health -= FlxG.random.float(0.5, 1.5);
		}
		
		
		for (i in 0..._grpEnemies.members.length)
		{
			var enemy = _grpEnemies.members[i];
			
			if (FlxG.overlap(b, enemy) && b.bType == "Player")
			{
				b.kill();
				enemy.health -= FlxG.random.float(0.5, 1.5);
			}
		}
		
	}
	
	
	private function look(e:Enemy):Void
	{
		if (_map.collidableTileLayers[0].ray(e.getMidpoint(), _player.getMidpoint()))
		{
			e.tartgetLook.set(_player.x, _player.y);
			e.attack("Enemy");
		}
	}
}