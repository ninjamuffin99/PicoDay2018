package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class DialogueListener extends FlxSpriteGroup 
{
	public var runningText:Bool = false;
	private var dialogueBox:FlxSprite;
	
	public function new(X:Float=0, Y:Float=0, MaxSize:Int=0) 
	{
		super(X, Y, MaxSize);
		
		dialogueBox = new FlxSprite(0, FlxG.height);
		dialogueBox.makeGraphic(FlxG.width, 100, FlxColor.BLACK);
		add(dialogueBox);
	}
	
	public function newDialogue():Void
	{
		FlxTween.tween(dialogueBox, {y:FlxG.height - 100}, 0.65, {ease:FlxEase.quartOut});
		runningText = true;
	}
	
}