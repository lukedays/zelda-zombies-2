package {
	import org.flixel.*;
	
	public class Enemy extends FlxSprite {
		[Embed(source = "sprites/zombie.png")] protected var ZombieImg:Class;
		
		protected var _random:Number = Math.random();
		protected var _jumpVel:Number= 500 + 100 * _random;
		protected var _runVel:Number = 80 + 100 * _random;
		protected var _jumpTimeout:Number = 2 + _random;
		protected var _jumpTimer:Number = _jumpTimeout;
		protected var _isJumping:Boolean;
		
		public function Enemy(x:Number, y:Number) {
			super(x, y);
			
			loadGraphic(ZombieImg, true, true, 64, 64);
			
			health = 1;
			maxVelocity.x = _runVel;
			maxVelocity.y = _jumpVel;
			drag.x = _runVel * 10;
			acceleration.y = 800;
			color = 0xFF000000 + 0xFF0000 * _random + 0xFF00 * _random + 0xFF * _random;
			
			addAnimation("idle", [0]);
			addAnimation("run", [0, 1], 12);
			addAnimation("jump", [5]);
		}
		
		override public function update():void {			
			width = 32;
			
			if (isTouching(FlxObject.DOWN)) _isJumping = false;
			
			if (_jumpTimer < _jumpTimeout) _jumpTimer += FlxG.elapsed;
			
			if (velocity.x < 0) facing = LEFT;
			else facing = RIGHT;
	
			if (facing == RIGHT) offset.x = 0;
			else offset.x = 32;
			
			if (velocity.y) play("jump");
			else if (!velocity.x) play("idle");
			else play("run");
		}
		
		public function updatePath():void {
			if (!_isJumping && _jumpTimer >= _jumpTimeout && y > Registry.player.y) {
				_isJumping = true;
				_jumpTimer = 0;
				velocity.y = -_jumpVel;		
			}
			
			if (enemyPath) stopFollowingPath(true);
			var pathStart:FlxPoint = new FlxPoint(x + width / 2, y + height / 2);
			var pathEnd:FlxPoint = new FlxPoint(Registry.player.x + Registry.player.width / 2, Registry.player.y + Registry.player.height / 2);
			try {
				var enemyPath:FlxPath = Registry.map.findPath(pathStart, pathEnd);
			}
			catch (e:TypeError) {
				
			}
			if (enemyPath) followPath(enemyPath, _runVel, FlxObject.PATH_HORIZONTAL_ONLY);
		}
	}
}