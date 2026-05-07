package objects;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class AfterImage extends FlxSprite
{
	public var finishCallback:AfterImage->Void;

	public function new()
	{
		super();
	}

	public function setup(source:FlxSprite, color:FlxColor = FlxColor.WHITE, time:Float = 0.5):Void
	{
		FlxTween.globalManager.cancelTweensOf(this);
		
		loadGraphicFromSprite(source);
		x = source.x;
		y = source.y;
		scale.set(source.scale.x, source.scale.y);
		offset.set(source.offset.x, source.offset.y);
		origin.set(source.origin.x, source.origin.y);
		updateHitbox();
		
		angle = source.angle;
		alpha = 0.5;
		antialiasing = source.antialiasing;
		this.color = color;
		
		flipX = source.flipX;
		flipY = source.flipY;
		scrollFactor.copyFrom(source.scrollFactor);

		FlxTween.tween(this, {alpha: 0}, time, {
			onComplete: function(twn:FlxTween)
			{
				kill();
				if (finishCallback != null) finishCallback(this);
			}
		});
	}
}
