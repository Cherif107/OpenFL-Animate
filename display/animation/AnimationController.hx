package display.animation;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;


class Frame {
    public var bitmap:BitmapData;
    public var name:String;

    public function new(Name:String, bitmap:BitmapData){
        name = Name;
        this.bitmap = bitmap;
    }
    
	public static function sort(frames:Array<Frame>, prefixLength:Int, postPrefixLength:Int){
		haxe.ds.ArraySort.sort(frames, sortByName.bind(_, _, prefixLength, postPrefixLength));
    }
    public static function sortByName(frame1:Frame, frame2:Frame, prefixLength:Int, postPrefixLength:Int){
		var name1:String = frame1.name;
		var name2:String = frame2.name;
		var num1:Null<Int> = Std.parseInt(name1.substring(prefixLength, name1.length - postPrefixLength));
		var num2:Null<Int> = Std.parseInt(name2.substring(prefixLength, name2.length - postPrefixLength));
		if (num1 == null)
			num1 = 0;
		if (num2 == null)
			num2 = 0;

		return num1 - num2;
    }
}
class AnimationController {
    public var parent:Sprite;
	public var curAnim:Animation;
    public var curFrame:Int = 0;

    public var name(get, set):String;
    public var paused(get, set):Bool;
    public var finished(get, set):Bool;

	public var frames:Array<Frame>;
    public var animations:Map<String, Animation>;

    public function new(parent:Sprite){
        this.parent = parent;
		animations = new Map<String, Animation>();
    }

    public function exists(name:String)
        return animations.exists(name);
    public function clear(){
        curAnim = null;
        animations = new Map<String, Animation>();
    }
    public function add(Name:String, Frames:Array<Int>, FrameRate:Int = 24, Looped:Bool = true){
        var framesArray:Array<Int> = Frames;
        var i:Int = framesArray.length-1;
        while (i >= 0){
            if (framesArray[i] >= frames.length){
                if (framesArray == Frames) framesArray = Frames.copy();
                framesArray.splice(i, 1);
            }
            i--;
        }
        if (framesArray.length > 0)
            animations.set(Name, new Animation(Name, framesArray, FrameRate, Looped));
    }
    public function remove(Name:String){
        if (animations.exists(Name))
            animations.remove(Name);
    }

    public function getFrameIndex(Frame:Frame):Int
        return frames.indexOf(Frame);

    function findFrame(Prefix:String, Index:Int, PostFix:String):Int{
        for (i in 0...frames.length){
            if (StringTools.startsWith(frames[i].name, Prefix) && StringTools.endsWith(frames[i].name, PostFix)){
				var index:Null<Int> = Std.parseInt(frames[i].name.substring(Prefix.length, frames[i].name.length - PostFix.length));
                if (index != null && index == Index)
                    return i;
            }
        }
        return -1;
    }

    function indicesHelper(addTo:Array<Int>, Prefix:String, Indices:Array<Int>, Postfix:String){
        for (i in Indices){
            var toAdd:Int = findFrame(Prefix, i, Postfix);
            if (toAdd != -1)
                addTo.push(toAdd);
        }
    }
    function prefixHelper(addTo:Array<Int>, Frames:Array<Frame>, Prefix:String){
        var name = Frames[0].name;
        var postIndex:Int = name.indexOf(".", Prefix.length);
		var postFix:String = name.substring(postIndex == -1 ? name.length : postIndex, name.length);
        Frame.sort(Frames, Prefix.length, postFix.length);

        for (animFrame in Frames)
			addTo.push(getFrameIndex(animFrame));
    }
    function findByPrefix(Frames:Array<Frame>, Prefix:String){
        for (frame in frames)
            if (frame.name != null && StringTools.startsWith(frame.name, Prefix))
                Frames.push(frame);
    }


    public function addByPrefix(Name:String, Prefix:String, FrameRate:Int = 24, Looped:Bool = true){
        if (frames != null){
            var Frames:Array<Frame> = new Array<Frame>();
            findByPrefix(Frames, Prefix);

            if (Frames.length > 0){
                var frameIndices:Array<Int> = new Array<Int>();
                prefixHelper(frameIndices, Frames, Prefix);
                
                if (frameIndices.length > 0)
                    animations.set(Name, new Animation(Name, frameIndices, FrameRate, Looped));
            }
        }
    }
    public function addByIndices(Name:String, Prefix:String, Indices:Array<Int>, PostFix:String, FrameRate:Int = 24, Looped:Bool = true){
		if (frames != null) {
			var frameIndices:Array<Int> = new Array<Int>();
			indicesHelper(frameIndices, Prefix, Indices, PostFix);

			if (frameIndices.length > 0)
				animations.set(Name, new Animation(Name, frameIndices, FrameRate, Looped));
		}
    }

    public function play(Name:String, Force:Bool = false){
        if (Name == null){
            if (curAnim == null)
                curAnim.stop();
            curAnim = null;
        }
        if (Name == null || animations.get(Name) == null)
            return;

        curAnim = animations.get(Name);
        curAnim.play(Force);
    }

    public function get_name():String
		return if (curAnim == null) null; else curAnim.name;
	public function get_paused():Bool
		return if (curAnim == null) false; else curAnim.paused;
	public function get_finished():Bool
        return if (curAnim == null) true; else curAnim.finished;

	public function set_finished(v:Bool):Bool{
		if (curAnim != null && v)
            curAnim.finish();
        return v;
	}
	public function set_paused(v):Bool{
		if (curAnim != null){
            if (v)
                curAnim.pause();
            else 
                curAnim.resume();
        }
        return v;
	}
	public function set_name(name:String):String{
        play(name);
        return name;
    }
}