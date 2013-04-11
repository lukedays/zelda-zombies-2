package {
	import org.flixel.*;
	
	public class PlayState extends FlxState {
		[Embed(source = "tilesets/tileset.png")] protected var Tileset:Class;
		[Embed(source = "tilesets/map.csv", mimeType = "application/octet-stream")] protected var MapData:Class;
		[Embed(source = "tilesets/overlay1.csv", mimeType = "application/octet-stream")] protected var OverlayData1:Class;
		[Embed(source = "tilesets/overlay2.csv", mimeType = "application/octet-stream")] protected var OverlayData2:Class;
		
		protected var _enemy:Enemy;
		protected var _blocks:FlxGroup;
		protected var _enemies:FlxGroup;
		protected var _time:FlxText;
		protected var _timeValue:Number = 0;
		protected var _score:FlxText;
		protected var _scoreValue:Number = 0;
		protected var _enemyKilled:Boolean = false;
		protected var _maxEnemies:Number = 10;
		
		override public function create():void {
			_enemies = new FlxGroup();
			
			addBlocks();
			addHUD();
			spawnPlayer();
			spawnEnemy();
			
			FlxG.camera.setBounds(0, 0, 1920, 576, true);
			FlxG.camera.follow(Registry.player, FlxCamera.STYLE_PLATFORMER);
		}
		
		override public function update():void {
			if (!Registry.player.health) {
				FlxG.switchState(new GameOverState());
			}
			
			super.update();
			
			FlxG.collide(Registry.player, _blocks);
			FlxG.collide(_enemies, _blocks);
			FlxG.overlap(Registry.player, _enemies, playerHurtsEnemies);

			if (_enemyKilled) {
				_enemyKilled = false;
				spawnEnemy();
				spawnEnemy();

				_scoreValue++;
				_score.text = _scoreValue.toString();
			}
			
			_enemies.callAll("updatePath");
			
			_timeValue += FlxG.elapsed;
			_time.text = Math.round(_timeValue).toString();
		}
		
		protected function addBlocks():void {
			// Background
			add(new Background(0, 0, 0));
			
			// Boundaries
			var left:FlxTileblock = new FlxTileblock(0, 0, 1, 576);
			var right:FlxTileblock = new FlxTileblock(1919, 0, 1, 576);
			var top:FlxTileblock = new FlxTileblock(0, 0, 1920, 1);
			var bottom:FlxTileblock = new FlxTileblock(0, 575, 1920, 1);
			
			_blocks = new FlxGroup();
			_blocks.add(left);
			_blocks.add(right);
			_blocks.add(top);
			_blocks.add(bottom);

			// Tilesets
			Registry.map = new FlxTilemap;
			var overlay1:FlxTilemap = new FlxTilemap;
			var overlay2:FlxTilemap = new FlxTilemap;
			
			Registry.map.loadMap(new MapData, Tileset, 48, 48);
			overlay1.loadMap(new OverlayData1, Tileset, 48, 48);
			overlay2.loadMap(new OverlayData2, Tileset, 48, 48);
			
			_blocks.add(Registry.map);
			
			add(_blocks);
			add(overlay1);
			add(overlay2);
		}
		
		protected function spawnPlayer():void {
			var pos:FlxPoint = randomPosition();
			var player:Player = new Player(pos.x, pos.y);
			Registry.player = player;
			add(Registry.player);
		}
		
		protected function spawnEnemy():void {
			var pos:FlxPoint = randomPosition();
			var enemy:Enemy = _enemies.getFirstAvailable(Enemy) as Enemy;

			if (!enemy && _enemies.length < _maxEnemies) {
				enemy = new Enemy(pos.x, pos.y);
			}
			else if (enemy) {
				enemy.reset(pos.x, pos.y);
			}
			else {
				return;
			}
			
			while (Math.abs(enemy.x - Registry.player.x) > 200 && Math.abs(enemy.y - Registry.player.y) > 200) {
				pos = randomPosition();
				enemy.reset(pos.x, pos.y);
			}
			
			_enemies.add(enemy);
			add(enemy);
		}
		
		
		protected function addHUD():void {
			// Score
			var text:FlxText = new FlxText(-100, 10, 960, "score");
			text.setFormat("zelda", 25, 0xFFFFFFFF, "right", 0xFF000000);
			text.scrollFactor.x = text.scrollFactor.y = 0;
			add(text);
			
			_score = new FlxText(-10, 10, 960, _scoreValue.toString());
			_score.setFormat("zelda", 25, 0xFFFFFFFF, "right", 0xFF000000);
			_score.scrollFactor.x = _score.scrollFactor.y = 0;
			add(_score);
			
			// Time
			text = new FlxText(-100, 35, 960, "time");
			text.setFormat("zelda", 25, 0xFFFFFFFF, "right", 0xFF000000);
			text.scrollFactor.x = text.scrollFactor.y = 0;
			add(text);
						
			_time = new FlxText(-10, 35, 960, "123");
			_time.setFormat("zelda", 25, 0xFFFFFFFF, "right", 0xFF000000);
			_time.scrollFactor.x = _time.scrollFactor.y = 0;
			add(_time);
			
			add(new Hearts(10, 10));
		}
		
		protected function playerHurtsEnemies(player:FlxSprite, enemy:FlxSprite):void {
			if (FlxG.keys.C) {
				enemy.kill();
				_enemyKilled = true;
			}
			else {
				player.hurt(1);
			}
		}
		
		protected function randomPosition():FlxPoint {
			var pos:FlxPoint = new FlxPoint(random(24, 1872), random(24, 528));
			
			// Checks if position is not overlapping a tile
			while (Registry.map.getTile(Math.round(pos.x / 48), Math.round(pos.y / 48))) {
				pos = new FlxPoint(random(24, 1872), random(24, 528));
			}
			
			return pos;
		}
		
		protected function random(start:Number, end:Number):Number {
			return Math.round(start + (end - start) * Math.random());
		}
	}
}