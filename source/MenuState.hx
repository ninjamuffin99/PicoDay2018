package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	private var titleText:FlxText;
	private var instructionText:FlxText;
	
	override public function create():Void
	{
		
		titleText = new FlxText(0, 0, 0, "PICO RISING", 32);
		titleText.screenCenter();
		add(titleText);
		
		instructionText = new FlxText(0, FlxG.height * 0.65, 0, "Click to start", 18);
		instructionText.screenCenter(X);
		add(instructionText);
		
		FlxG.sound.playMusic("assets/music/621467_FD---Picos-Dream.mp3", 0.6);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.mouse.justPressed)
		{
			FlxG.sound.music.fadeOut(1, 0);
			FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
			{
				FlxG.switchState(new LevelBaseState());
				FlxG.sound.music.stop();
			});
			
		}
	}
}