package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxVelocity;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import com.newgrounds.*;
import com.newgrounds.components.*;


class LevelBaseState extends FlxState
{
	public var _player:Player;
	public var player_start:FlxObject;
	private var _camTrack:FlxObject;
	private var testEnemy:Enemy;
	private var playerBullets:FlxTypedGroup<Bullet>;
	private var enemyBullets:FlxTypedGroup<Bullet>;
	private var _dialogueListener:DialogueListener;
	public var levelExit:FlxObject;
	
	private var speedTimer:Float = 0;
	private var txtTimer:FlxText;
	
	public var _map:TiledLevel;
	
	public var _grpEffects:FlxTypedGroup<FlxSprite>;
	public var _grpEnemies:FlxTypedGroup<Enemy>;
	public var _grpLockers:FlxTypedGroup<Locker>;
	public var _grpCollidableObjects:FlxTypedGroup<FlxBasic>;
	public var _grpDialogues:FlxTypedGroup<DialogueTrigger>;
	
	private var _grpHUDShit:FlxGroup;
	
	public var txtHealth:FlxText;
	private var txtEnemies:FlxText;
	public var numEnemies:Int = 0;
	public var totalEnemeis:Int = 0;
	
	public var levelsArray:Array<String> =
	[
		"assets/data/level1.tmx",
		"assets/data/level2.tmx",
		"assets/data/level3.tmx",
		"assets/data/level4.tmx",
		"assets/data/level5.tmx"
	];
	
	private var musicArray:Array<String> = 
	[
		"assets/music/234111_Pico_factory.mp3",
		"assets/music/483275_Picos-Flub.mp3",
		"assets/music/531991_Underground-Pico-Beat.mp3",
		"assets/music/683334_Generic-Pico-Day-Content.mp3",
		"assets/music/683382_Hurting.mp3",
		"assets/music/683411_Pico-Day-Funk.mp3",
		"assets/music/683479_StarGunner.mp3",
		"assets/music/742027_God-Uzi.mp3",
		"assets/music/742237_Neverending-Nightmare-8.mp3",
		"assets/music/804226_Enter-Pico.mp3"
	];
	
	public var enemiesArray:Array<FlxTypedGroup<Enemy>> = [];
	
	public var curLevel:Int = 0;
	
	
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
		
		if (FlxG.sound.music.playing)
		{
			var musicic = FlxG.random.getObject(musicArray);
			FlxG.log.add(musicic);
			FlxG.sound.playMusic(musicic, 0, false);
			FlxG.sound.music.fadeIn(4, 0, 0.45);
		}
		
		
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
		
		enemiesArray.push(_grpEnemies);
		
		_map = new TiledLevel(levelsArray[curLevel], this);
		
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
	
	private function reloadMap(direction:Int = FlxObject.UP):Void
	{
		
		FlxG.log.add("new level");
		totalEnemeis = 0;
		numEnemies = 0;
		
		remove(_map.backgroundLayer);
		remove(_map.imagesLayer);
		remove(_map.BGObjects);
		remove(_map.foregroundObjects);
		remove(_map.objectsLayer);
		remove(_map.foregroundTiles);
		
		remove(_grpHUDShit);
		
		_grpEnemies.forEachExists(killEnemies);
		
		_player.health += 1.5;
		
		if (direction == FlxObject.UP)
		{
			curLevel += 1;
		}
		else
		{
			curLevel -= 1;
		}
		
		if (curLevel >= levelsArray.length)
		{
			FlxG.switchState(new Ending());
		}
		
		_map = new TiledLevel(levelsArray[curLevel], this);
		_grpEnemies.forEach(bulletSet);
		
		if (direction == FlxObject.UP)
		{
			_player.setPosition(player_start.x, player_start.y);
		}
		else
		{
			_player.setPosition(levelExit.x, levelExit.y);
		}
		
		add(_map.backgroundLayer);
		add (_map.imagesLayer);
		//the _map.foregroundLayer is added later so that it's above the enemies and shit
		add(_map.BGObjects);
		add(_map.foregroundObjects);
		add(_map.objectsLayer);
		
		add(_map.foregroundTiles);
		
		add(_grpHUDShit);
		
		FlxG.log.add("load levels?");
		
	}
	
	private function killEnemies(e:Enemy):Void
	{
		_grpEnemies.remove(e);
	}
	
	private function initHUD():Void
	{
		_grpHUDShit = new FlxGroup();
		add(_grpHUDShit);
		
		_dialogueListener = new DialogueListener(0, 0);
		_dialogueListener.scrollFactor.set();
		_grpHUDShit.add(_dialogueListener);
		
		txtHealth = new FlxText(10, 44, 0, "", 32);
		txtHealth.scrollFactor.set(0, 0);
		_grpHUDShit.add(txtHealth);
		
		txtTimer = new FlxText(FlxG.width * 0.65, 10, 0, "", 32);
		txtTimer.scrollFactor.set(0, 0);
		_grpHUDShit.add(txtTimer);
		
		txtEnemies = new FlxText(10, 10, 0, "", 32);
		txtEnemies.scrollFactor.set();
		_grpHUDShit.add(txtEnemies);
	}
	
	private function bulletSet(e:Enemy):Void
	{
		e.bulletArray = enemyBullets;
	}
	
	private function finishMusic():Void
	{
		FlxG.sound.playMusic(FlxG.random.getObject(musicArray), 0.45);
	}

	override public function update(elapsed:Float):Void
	{
		if (!FlxG.sound.music.playing || FlxG.keys.justPressed.E)
		{
			finishMusic();
		}
		
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
		
		
		txtHealth.text = Std.string(FlxMath.roundDecimal(FlxMath.remapToRange(FlxMath.roundDecimal(_player.health, 2), 0, 4.5, 0, 10), 2)) + " HP";
		
		txtEnemies.text = Std.string(numEnemies + "/" + totalEnemeis + " enemies killed");
		
		if (FlxG.overlap(_player, levelExit) && numEnemies >= totalEnemeis || FlxG.keys.justPressed.UP)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.3, false, function()
			{
				reloadMap(FlxObject.UP);
				FlxG.camera.fade(FlxColor.BLACK, 0.3, true);
			});
		}
		
		if (!_player.alive || FlxG.keys.justPressed.R)
		{
			if (API.isNewgrounds)
			{
				API.unlockMedal("Deadzo");
			}
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
			switch(b.touching)
			{
				case FlxObject.LEFT:
					impact.angle = 180;
				case FlxObject.RIGHT:
					impact.x -= 29;
				case FlxObject.UP:
					impact.angle = -90;
				case FlxObject.DOWN:
					impact.angle = 90;
					impact.y -= 29;
			}
			
			//impact.angle = b.angle;
			_grpEffects.add(impact);
			
			b.kill();
		}
		
		if (FlxG.overlap(b, _player) && b.bType == "Enemy")
		{
			
			var impact:BulletStuff = new BulletStuff(b.x, b.y, "impact");
			
			impact.angle = b.angle;
			_grpEffects.add(impact);
			
			_player.velocity.x += b.velocity.x * 0.2;
			_player.velocity.y += b.velocity.y * 0.2;
			
			
			
			b.kill();
			_player.hurt(FlxG.random.float(0.5, 1.5));
		}
		
		for (i in 0..._grpEnemies.members.length)
		{
			var enemy = _grpEnemies.members[i];
			
			if (FlxG.overlap(b, enemy) && b.bType == "Player" && !enemy.isDead)
			{
				FlxG.sound.play("assets/sounds/killImpact.wav");
				var healthAdd = FlxG.random.float(0.45, 0.85);
				_player.health += healthAdd;
				enemy.health -= 1;
				enemy.shot(b.velocity.x, b.velocity.y);
				numEnemies += 1;
				if (numEnemies >= totalEnemeis)
				{
					FlxG.sound.play("assets/sounds/unlock.wav");
				}
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