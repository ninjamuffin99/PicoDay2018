package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxVelocity;
import flixel.text.FlxText;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	public var _player:Player;
	public var player_start:FlxObject;
	private var _camTrack:FlxObject;
	private var testEnemy:Enemy;
	private var playerBullets:FlxTypedGroup<Bullet>;
	private var enemyBullets:FlxTypedGroup<Bullet>;
	private var _dialogueListener:DialogueListener;
	
	private var speedTimer:Float = 0;
	private var txtTimer:FlxText;
	
	public var _map:TiledLevel;
	
	public var _grpEffects:FlxTypedGroup<FlxSprite>;
	public var _grpEnemies:FlxTypedGroup<Enemy>;
	public var _grpLockers:FlxTypedGroup<Locker>;
	public var _grpCollidableObjects:FlxTypedGroup<FlxBasic>;
	public var _grpDialogues:FlxTypedGroup<DialogueTrigger>;
	
	public var txtHealth:FlxText;
	
	
	override public function create():Void
	{
		FlxG.mouse.load("assets/images/cursor.png", 1.7, 6, 6);
		/*
		#if flash
			FlxG.sound.playMusic("assets/music/234111_Pico_factory.mp3");
		#else
			FlxG.sound.playMusic("assets/music/234111_Pico_factory.ogg");
		#end
		*/
		
		initObjects();
		
		
		FlxG.camera.follow(_camTrack);
		FlxG.camera.followLerp = 0.6;
		
		initHUD();
		
		FlxG.worldBounds.set(_map.width, _map.height);
		
		super.create();
	}
	
	private function initObjects():Void
	{
		_grpEffects = new FlxTypedGroup<FlxSprite>();
		_grpEnemies = new FlxTypedGroup<Enemy>();
		_grpLockers = new FlxTypedGroup<Locker>();
		_grpCollidableObjects = new FlxTypedGroup<FlxBasic>();
		_grpDialogues = new FlxTypedGroup<DialogueTrigger>();
		
		_map = new TiledLevel("assets/data/level1.tmx", this);
		
		add(_map.backgroundLayer);
		add (_map.imagesLayer);
		//the _map.foregroundLayer is added later so that it's above the enemies and shit
		add(_map.BGObjects);
		add(_map.foregroundObjects);
		add(_map.objectsLayer);
		
		playerBullets = new FlxTypedGroup<Bullet>();
		enemyBullets = new FlxTypedGroup<Bullet>();
		
		
		_camTrack = new FlxObject(0, 0, 1, 1);
		add(_camTrack);
		
		add(_grpEffects);
		add(_grpEnemies);
		add(_grpCollidableObjects);
		_grpCollidableObjects.add(_grpLockers);
		add(_grpDialogues);
		
		_player = new Player(player_start.x, player_start.y, playerBullets);
		_player.accuracy = 0.5;
		add(_player);
		
		add(playerBullets);
		add(enemyBullets);
		
		add(_map.foregroundTiles);
		
		
		_grpEnemies.forEach(bulletSet);
	}
	
	private function initHUD():Void
	{
		_dialogueListener = new DialogueListener(0, 0);
		_dialogueListener.scrollFactor.set();
		add(_dialogueListener);
		
		
		txtHealth = new FlxText(10, 10, 0, "", 32);
		txtHealth.scrollFactor.set(0, 0);
		add(txtHealth);
		
		txtTimer = new FlxText(0, 10, 0, "", 32);
		txtTimer.scrollFactor.set(0, 0);
		txtTimer.screenCenter(X);
		add(txtTimer);
	}
	
	private function bulletSet(e:Enemy):Void
	{
		e.bulletArray = enemyBullets;
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.overlap(_player, _grpDialogues))
		{
			if (!_dialogueListener.runningText)
			{
				_dialogueListener.newDialogue();
			}	
		}
		
		if (FlxG.keys.justPressed.E)
		{
			if (_dialogueListener.runningText)
			{
				_dialogueListener.endDialogue();
			}
		}
		
		//THEsd
		enemyBullets.forEachAlive(checkBulletOverlap);
		playerBullets.forEachAlive(checkBulletOverlap);
		
		super.update(elapsed);
		
		speedTimer += FlxG.elapsed;
		txtTimer.text = "Time: " + FlxMath.roundDecimal(speedTimer, 2);
		
		
		txtHealth.text = Std.string(FlxMath.roundDecimal(_player.health, 2));
		
		if (!_player.alive)
		{
			FlxG.resetState();
		}
		FlxG.collide(_grpCollidableObjects, enemyBullets);
		FlxG.collide(_grpCollidableObjects, playerBullets);
		FlxG.collide(_player, _grpCollidableObjects);
		
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
		_map.collideWithLevel(_grpEnemies);
	}
	
	private function checkBulletOverlap(b:Bullet):Void
	{
		if (_map.collideWithLevel(b))
		{
			var impact:BulletStuff = new BulletStuff(b.x, b.y, "impact");
			impact.angle = b.angle;
			_grpEffects.add(impact);
			
			b.kill();
		}
		
		if (FlxG.overlap(b, _player) && b.bType == "Enemy")
		{
			var impact:BulletStuff = new BulletStuff(b.x, b.y, "impact");
			impact.angle = b.angle;
			_grpEffects.add(impact);
			
			b.kill();
			_player.hurt(FlxG.random.float(0.5, 1.5));
		}
		
		for (i in 0..._grpEnemies.members.length)
		{
			var enemy = _grpEnemies.members[i];
			
			if (FlxG.overlap(b, enemy) && b.bType == "Player" && !enemy.isDead)
			{
				var healthAdd = FlxG.random.float(0.45, 0.85);
				FlxG.log.add(healthAdd);
				_player.health += healthAdd;
				enemy.health -= 1;
				enemy.shot(b.velocity.x, b.velocity.y);
				b.kill();
			}
		}
		
		var lockerResistance:Float = 0.9;
		switch(b.wasTouching)
		{
			case FlxObject.UP:
				b.velocity.y += b.speed * lockerResistance;
				b.angle += 180;
			case FlxObject.DOWN:
				b.velocity.y -= b.speed * lockerResistance;
				b.angle += 180;
			case FlxObject.LEFT:
				b.velocity.x += b.speed * lockerResistance;
				b.angle += 180;
			case FlxObject.RIGHT:
				b.velocity.x -= b.speed * lockerResistance;
				b.angle += 180;
		}
	}
	
	private function look(e:Enemy):Void
	{
		if (_map.collidableTileLayers[0].ray(e.getMidpoint(), _player.getMidpoint()) && FlxMath.isDistanceWithin(e, _player, 460) && !e.isDead)
		{
			e.seesPlayer = true;
			e.tartgetLook.set(_player.playerMovePosition.x, _player.playerMovePosition.y);
			if (e.reactionTime <= 0)
			{
				e.attack("Enemy");
				FlxVelocity.moveTowardsPoint(e, _player.getPosition(), e.followSpeed);
			}
			else
			{
				e.reactionTime -= FlxG.elapsed;
			}
		}
		else
		{
			e.seesPlayer = false;
			e.reactionTime = 0.3;
		}
	}
}