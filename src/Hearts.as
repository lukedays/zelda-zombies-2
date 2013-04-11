package  
{
	import org.flixel.*;
	public class Hearts extends FlxSprite {
		[Embed(source = "sprites/hearts.png")] protected var HeartsImg:Class;
		
		public function Hearts(x:Number, y:Number) {
			super(x, y);
			loadGraphic(HeartsImg, true, true, 144, 48);
			scrollFactor.x = scrollFactor.y = 0;
			
			addAnimation("3", [0]);
			addAnimation("2", [1]);
			addAnimation("1", [2]);
			addAnimation("0", [3]);
		}
		
		override public function update():void {
			if (Registry.player.health == 3) {
				play("3");
			}
			else if (Registry.player.health == 2) {
				play("2");
			}
			else if (Registry.player.health == 1) {
				play("1");
			}
			else {
				play("0");
			}
		}
	}
}