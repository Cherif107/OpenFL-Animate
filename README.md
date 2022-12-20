# OpenFL-Animate
A very simple Animated sprites class in openfl (using flixel for helper functions)

#example:
```hx
var animatedSprite:AnimatedSprite = AnimatedSprite.fromSparrow(Assets.playerSparrow);
animatedSprite.animation.addByPrefix('walk', 'walkAnimation', 24, true);
animatedSprite.animation.play('walk');

animatedSprite.animation.addByIndices('jumpLow', 'jump', [0, 1, 2, 3, 2, 1, 0], "", 24, false);
animatedSprite.animation.play('jumpLow');
```
