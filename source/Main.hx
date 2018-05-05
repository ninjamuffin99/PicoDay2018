package;

import flixel.FlxGame;
import openfl.display.Sprite;
import com.newgrounds.*;
import com.newgrounds.components.*;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, LevelBaseState));
		
		var medalPopup:MedalPopup = new MedalPopup();
		medalPopup.x = 20;
		medalPopup.y = 20;
		addChild(medalPopup);
	}
}