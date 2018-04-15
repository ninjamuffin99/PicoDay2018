package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxPath;

/**
 * ...
 * @author ninjaMuffin
 */
class Enemy extends Character 
{
	public var reactionTime:Float = 0.3;
	public var seesPlayer:Bool = false;
	private var pathSpeed:Float = 200;
	
	public function new(?X:Float=0, ?Y:Float=0, Path:FlxPath) 
	{
		super(X, Y);
		
		if (Path != null)
		{
			path = Path;
			path.start(null, pathSpeed, FlxPath.LOOP_FORWARD);
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (path != null)
		{
			if (seesPlayer)
			{
				path.cancel();
			}
			else if (!path.active)
			{
				path.start(null, pathSpeed, FlxPath.LOOP_FORWARD);
			}
		}
	}
}