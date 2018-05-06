package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import io.newgrounds.NG;

/**
 * ...
 * @author
 */
class Ending extends FlxState
{

	private var ending:FlxText;
	private var instructions:FlxText;

	override public function create():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 4, true);

		ending = new FlxText(75, 0, FlxG.width, "PICO REACHES THE TOP OF THE SCHOOL, REALIZES HE WAS THE MONSTER THE WHOLE TIME, THEN KILLS HIMSELF LOL\nTHE END\nMADE BY NINJAMUFFIN99", 38);
		ending.screenCenter(Y);
		add(ending);
		
		instructions = new FlxText(0, FlxG.height - 34, FlxG.width, "Press ENTER to go back to the main menu", 32);
		instructions.screenCenter(X);
		add(instructions);
		
		#if (flash)
				var winMedal = NG.core.medals.get(54811);
				if (!winMedal.unlocked)
					winMedal.sendUnlock();
		#end

		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.camera.fade(FlxColor.BLACK, 5, false, function(){FlxG.switchState(new MenuState()); });
		}
		
		super.update(elapsed);
	}
}