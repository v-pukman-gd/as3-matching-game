package game 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author [V.I.C]
	 */
	public class DebugGrid 
	{
		private var grid:Sprite;
		private var textField:TextField;
		private var mousePosText:TextField;
		public function DebugGrid(numColumns:Number, numRows:Number, cellHeight:Number, cellWidth:Number) 
		{
			grid = new Sprite();
			grid.graphics.clear();
			grid.graphics.lineStyle(1, 0x000000);

			for (var col:Number = 0; col < numColumns + 1; col++)
			{
				for (var row:Number = 0; row < numRows + 1; row++)
				{
					grid.graphics.moveTo(col * cellWidth, 0);
					grid.graphics.lineTo(col * cellWidth, cellHeight * numRows);
					grid.graphics.moveTo(0, row * cellHeight);
					grid.graphics.lineTo(cellWidth * numColumns, row * cellHeight);
					
					textField = new TextField();
					textField.selectable = false;
					textField.textColor = 0xFFFFFF;		
					textField.x = col * cellWidth;
					textField.y = row * cellHeight - 5;					
					
					if (col == numColumns - 1) {					
						textField.text = (row * cellHeight).toString();
					    grid.addChild(textField);
					}
					
					if (row == numRows - 1) {					
						textField.text = (col * cellWidth).toString();
					    grid.addChild(textField);
					}
				}
			}
			
			grid.visible = false;
			
			mousePosText = new TextField();
			mousePosText.textColor = 0xFFFFFF;
			mousePosText.selectable = false;
			grid.addChild(mousePosText);
		}
		
		
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.G) {
				grid.visible = !grid.visible;
			}
		}
		private function onMouseMove(e:MouseEvent):void 
		{
			mousePosText.x = e.stageX;
			mousePosText.y = e.stageY;
			mousePosText.text = "x:" + e.stageX + " y:" + e.stageY;
		}
		
		public function add(target:DisplayObjectContainer, pos:Point = null):void {
			target.addChild(grid);
			target.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			target.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			if(pos!=null){
				target.x = pos.x;
				target.y = pos.y;
			}
		}
		
		
		public function remove():void {
			grid.parent.removeChild(grid);
			
		}
		
		
	}

}