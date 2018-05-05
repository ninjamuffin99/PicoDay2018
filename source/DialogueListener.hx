package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
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
	private var dialogueText:FlxTypeText;
	
	public function new(X:Float=0, Y:Float=0, MaxSize:Int=0) 
	{
		super(X, Y, MaxSize);
		
		dialogueBox = new FlxSprite(0, FlxG.height);
		dialogueBox.makeGraphic(FlxG.width, 100, FlxColor.BLACK);
		add(dialogueBox);
		
		dialogueText = new FlxTypeText(dialogueBox.x + 32, dialogueBox.y + 32, Std.int(dialogueBox.width - 32), "WASD to move. \nMouse to shoot\n Kill all enemies then head to stairs", 16);
		add(dialogueText);
	}
	
	public function newDialogue():Void
	{
		FlxTween.tween(dialogueBox, {y:FlxG.height - 100}, 0.65, {ease:FlxEase.quartOut});
		FlxTween.tween(dialogueText, {y:FlxG.height - 90}, 0.80, {ease:FlxEase.quartOut});
		dialogueText.start(0.05);
		runningText = true;
	}
	
	public function endDialogue():Void
	{
		FlxTween.tween(dialogueBox, {y:FlxG.height}, 0.65, {ease:FlxEase.quartOut});
		FlxTween.tween(dialogueText, {y:FlxG.height + 32}, 0.80, {ease:FlxEase.quartOut});
		runningText = false;
	}
	
}