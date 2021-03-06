package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class BulletStuff extends FlxSprite 
{
	private var lifeSpan = 4;
	private var counter = 0;
	
	public function new(?X:Float=0, ?Y:Float=0, type:String = "muzzFlash") 
	{
		super(X, Y);
		
		switch(type)
		{
			case "muzzFlash":
				loadGraphic("assets/images/muzzFlashSheet.png", true, 40, 40);
				animation.add('play', [0, 1, 2, 3, 4], 12, false);
				
			case "impact":
				loadGraphic("assets/images/bulletImpacSheet.png", true, 40, 40);
				animation.add("play", [0, 1, 2, 3, 4], 24, false);
		}
		
		animation.play('play');
		drag.set(10, 10);
		/*
		setGraphicSize(Std.int(width * 1.5));
		updateHitbox();
		*/
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (animation.curAnim.finished)
		{
			kill();
		}
		
	}
	
}