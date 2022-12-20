package display.animation;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxFrame;
import flixel.graphics.frames.FlxFramesCollection;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;

class AnimatedSprite extends Sprite {
    public var animation:AnimationController;
    public var frames(get, set):Array<Frame>;
    public var bitmap:Bitmap = new Bitmap();

    private var curBitmap:BitmapData;
    private var focusLost:Bool = false;
    public function new(?frames:Array<Frame>){
        super();
		animation = new AnimationController(this);
        addChild(bitmap);
        addEventListener(Event.ENTER_FRAME, updateBitmap);
		addEventListener(Event.DEACTIVATE, function(_) {
			focusLost = true;
		});
		addEventListener(Event.ACTIVATE, function(_) {
			focusLost = false;
		});

        if (frames != null) this.frames = frames;
    }

    public function updateBitmap(_){
        if (!focusLost){
            if (animation != null && animation.curAnim != null){
                if (curBitmap != frames[animation.curAnim.curIndex].bitmap){
			    	curBitmap = frames[animation.curAnim.curIndex].bitmap;
                    bitmap.bitmapData = curBitmap;
					trace(animation.name);
                }
            }
        }
    }
    public function set_frames(Frames:Array<Frame>):Array<Frame>{
        animation.frames = Frames;
        return Frames;
    }
	public function get_frames():Array<Frame> {
		return animation.frames;
	}

	public static function fromFramesCollection(framesCollection:FlxFramesCollection):AnimatedSprite
	{
		var frames:Array<Frame> = [];
        for (frame in framesCollection.frames)
            frames.push(new Frame(frame.name, frame.paint()));
        return new AnimatedSprite(frames);
	}
    public static function fromSparrow(image:String, path:String):AnimatedSprite{ // forgive me for these
		return AnimatedSprite.fromFramesCollection(image, path);
    }
	public static function fromSpriteSheetPacker(image:String, path:String):AnimatedSprite {
		return AnimatedSprite.fromFramesCollection(image, path);
	}
	public static function fromTexturePackerXml(image:String, path:String):AnimatedSprite {
		return AnimatedSprite.fromFramesCollection(image, path);
	}
	public static function fromTexturePackerJson(image:String, path:String):AnimatedSprite {
		return AnimatedSprite.fromFramesCollection(image, path);
	}
}
