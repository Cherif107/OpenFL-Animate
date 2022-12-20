package display.animation;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.utils.Timer;

class Animation {
	public var frameRate(default, set):Int;
	public var curFrame(default, set):Int = 0;
	public var maxFrames:Int;
	public var frames:Array<Int>;
	public var curIndex:Int = 0;

	public var finished:Bool = true;
	public var looped:Bool = true;
	public var paused:Bool = true;

	public var name:String;
	public var onFinish:Void->Void;

	private var delayTimer:Timer;

	public function new(Name:String, Frames:Array<Int>, FrameRate:Int = 0, Looped:Bool = true) {
		delayTimer = new Timer(1 / frameRate * 1000);
		delayTimer.addEventListener('timer', updateFrame);
		delayTimer.stop();

		name = Name;
		frames = Frames;
		frameRate = FrameRate;
		looped = Looped;
	}

	public function updateFrame(_) {
		if (finished || paused)
			return;
		if (looped && curFrame == frames.length - 1)
			curFrame = 0;
		else
			curFrame++;
	}

	public function play(Force:Bool = false, StartFrame:Int = 0) {
		if (!Force) {
			resume();
			finished = false;
			return;
		}

		resume();
		if (StartFrame < 0)
			StartFrame = 0;
		else if (StartFrame > frames.length - 1)
			StartFrame = frames.length;
		curFrame = StartFrame;
	}

	public function stop() {
		finished = true;
		pause();
	}

	public function finish() {
		stop();
		curFrame = 0;
	}

	public function pause() {
		delayTimer.stop();
		paused = true;
	}

	public function resume() {
		delayTimer.start();
		paused = false;
	}

	public function set_frameRate(frameRate:Int):Int {
		delayTimer.delay = 1 / frameRate * 1000;
		return frameRate;
	}

	public function set_curFrame(Frame:Int):Int {
		if (Frame >= 0) {
			if (!looped && Frame > frames.length - 1) {
				finished = true;
				curFrame = frames.length - 1;
			} else
				curFrame = Frame;
		} else
			curFrame = 0;
		curIndex = frames[curFrame];

		if (finished && onFinish != null)
			onFinish();

		return Frame;
	}
}