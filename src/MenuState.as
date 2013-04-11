package {
	import org.flixel.*;
	
	public class MenuState extends FlxState {
		[Embed(source = "sprites/zombie.ttf", fontFamily = "zombie", embedAsCFF = "false")] public var ZombieFont:String;
		[Embed(source = "sprites/zelda.ttf", fontFamily = "zelda", embedAsCFF = "false")] public var ZeldaFont:String;
		
		override public function create():void {
			var text:FlxText = new FlxText(0, 50, 960, "Zelda Zombies 2");
			text.setFormat("zombie", 80, 0xFFCC0E0E, "center", 0xFF705D5D);
			add(text);
			
			text = new FlxText(0, 180, 960, "Objective: survive...\n\nArrows: move\nX: jump\nC: attack\n\n\npress any key to continue");
			text.setFormat("zelda", 40, 0xFFFFFFFF, "center", 0xFF705D5D);
			add(text);
		}
		
		override public function update():void {
			super.update();
			
			if (FlxG.keys.any()) FlxG.switchState(new PlayState());
		}
	}
}