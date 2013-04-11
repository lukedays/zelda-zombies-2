package {
	import org.flixel.*;
	[SWF(width = "960", height = "576", backgroundColor = "#000000")]
	
	public class Main extends FlxGame {
		public function Main() {
			super(960, 576, MenuState, 1);
			forceDebugger = true;
		}
	}
}