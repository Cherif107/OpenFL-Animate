# OpenFL-Animate
A very simple Animated sprites class in openfl (using flixel for helper functions)

example:
```hx
		var animatedSprite:AnimatedSprite = AnimatedSprite.fromSparrow(Assets.playerSparrow);
		animatedSprite.animation.addByPrefix('walk', 'walkAnimation', 24, true);
		animatedSprite.animation.play('walk');
```
