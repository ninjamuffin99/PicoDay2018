//SHOUTOUTS TO GAMEPOPPER FOR THE BALLIN TUTORIAL
//https://gamepopper.co.uk/2014/08/26/haxeflixel-making-a-custom-preloader/


package;

import flixel.system.FlxBasePreloader;
import flash.display.*;
import flash.text.*;
import flash.Lib;
import flixel.text.FlxText;
import lime.audio.FlashAudioContext;
import openfl.display.Sprite;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import com.newgrounds.*;
import com.newgrounds.components.*;

@:bitmap("assets/images/prealoderImage.png") class LogoImage extends BitmapData { }
class Preloader extends FlxBasePreloader 
{

	private var logo:Sprite;
	
	public function new(MinDisplayTime:Float=2, ?AllowedURLs:Array<String>) 
	{
		super(MinDisplayTime, AllowedURLs);
	}

	override function create():Void 
	{	
		this._width = Lib.current.stage.stageWidth;
		this._height = Lib.current.stage.stageHeight;
		
		logo = new Sprite();
		logo.scaleX = 0;
		logo.addChild(new Bitmap(new LogoImage(0, 0))); //Sets the graphic of the sprite to a bitmap object, which uses our embedded bitmapData class
		addChild(logo);
		
		var ratio:Float = this._width / 800; //This allows us to scale assets depending on the size of the screen.
		#if (flash)
			var newgrounds:NGAPI = new NGAPI(APIStuff.apiKey, APIStuff.encKey);
			//API.connect(root, APIStuff.apiKey, APIStuff.encKey);
		#end
		
		super.create();
	}
	
	
	override public function update(Percent:Float):Void 
	{
		super.update(Percent);
		
		logo.scaleX = Percent;
	}
	
}
