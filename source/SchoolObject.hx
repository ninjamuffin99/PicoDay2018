package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class SchoolObject extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0, type:String = "") 
	{
		super(X, Y);
		
		switch(type)
		{
			case "toilet":
				loadGraphic("assets/images/bathroomSheet.png", false, 43, 64);
		}
		
		setGraphicSize(Std.int(width * 2));
		updateHitbox();
		immovable = true;
	}
	
}