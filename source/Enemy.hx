package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxVelocity;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
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
	private var patrolPath:FlxPath;
	private var curNode:Int = 0;
	

	
	public function new(?X:Float=0, ?Y:Float=0, Path:FlxPath) 
	{
		super(X, Y);
		
		if (Path != null)
		{
			patrolPath = Path;
			path = Path;
			path.start(null, pathSpeed, FlxPath.LOOP_FORWARD);
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (!seesPlayer && (velocity.x != 0 || velocity.y != 0))
		{
			var rads:Float = Math.atan2(velocity.y, velocity.x);
			//curRads = rads;
			
			var degs = FlxAngle.asDegrees(rads);
			//FlxG.watch.addQuick("Degs/Angle", degs);
			angle = degs + 90;
		}
		
		if (path != null && !isDead)
		{
			curNode = path.nodeIndex;
			if (seesPlayer)
			{
				path.cancel();
			}
			else if (!path.active)
			{
				path.start(null, pathSpeed, FlxPath.LOOP_FORWARD);
				//path.setNode(curNode);
			}
		}
	}
	
	public function shot(velX:Float, velY:Float):Void
	{
		makeGraphic(64, 80, FlxColor.LIME);
		velocity.x += velX;
		velocity.y += velY;
		
		width = 40;
		height = 40;
		offset.x = 12;
		offset.y = 20;
	}
}