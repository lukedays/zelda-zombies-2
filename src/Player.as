package {
	import org.flixel.*;
	
	public class Player extends FlxSprite {
		[Embed(source = "sprites/link.png")] protected var LinkImg:Class;
		
		protected var _jumpVel:Number = 500;
		protected var _runVel:Number = 250;
		protected var _hurtTimeout:Number = 1;
		protected var _hurtTimer:Number = _hurtTimeout;
		protected var _attackTimeout:Number = 1;
		protected var _attackTimer:Number = _attackTimeout;
		public var isAttacking:Boolean = false;

		public function Player(x:Number, y:Number) {
			super(x, y);
			loadGraphic(LinkImg, true, true, 96, 64);
			
			health = 3;
			maxVelocity.x = _runVel;
			maxVelocity.y = _jumpVel;
			drag.x = _runVel * 10;
			acceleration.y = 800;
			
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2], 12);
			addAnimation("jump", [3]);
			addAnimation("hurt", [4, 4, 4], 1);
			addAnimation("stab", [5, 6], 8);
		}
		
		override public function update():void {
			acceleration.x = 0;
			width = 32;
			
			if (FlxG.keys.LEFT) {
				facing = LEFT;
				acceleration.x -= drag.x;
			}
			else if (FlxG.keys.RIGHT) {
				facing = RIGHT;
				acceleration.x += drag.x;
			}
			
			if (FlxG.keys.justPressed("X") && !velocity.y) velocity.y = -_jumpVel;
			
			if (_hurtTimer < _hurtTimeout) _hurtTimer += FlxG.elapsed;
			if (_attackTimer < _attackTimeout) _attackTimer += FlxG.elapsed;

			if (facing == RIGHT) offset.x = 16;
			else offset.x = 48;
			
			if (FlxG.keys.C) {
				_attackTimer = 0;
				width = 64;
				
				if (facing == RIGHT) offset.x = 14;
				else offset.x = 50;
				
				play("stab");
			}
			else if (velocity.y) play("jump");
			else if (!velocity.x) play("idle");
			else play("run");
		}
		
		override public function hurt(damage:Number):void {
			if (_hurtTimer >= _hurtTimeout) {
				_hurtTimer = 0;
				flicker(1);
				super.hurt(damage);
			}
		}
	}
}