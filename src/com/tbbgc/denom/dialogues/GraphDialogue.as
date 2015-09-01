package com.tbbgc.denom.dialogues {
	import com.tbbgc.denom.common.nodes.values.GraphNode;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;


	/**
	 * @author simonrodriguez
	 */
	public class GraphDialogue extends BaseDialogue {
		private var _node:GraphNode;

		private var _graph:Sprite;

		private var _width:int;
		private var _height:int;

		private var _dragging:Sprite;

		private var _hint:TextField;

		public function GraphDialogue( node:GraphNode, x:Number, y:Number ) {
			const WIDTH:int = 300;
			const HEIGHT:int = 150;
			
			super("Graph", true, false, true, true);

			_node = node;

			_graph = new Sprite();
			_graph.doubleClickEnabled = true;
			_graph.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			container.addChild(_graph);

			_hint = new TextField();
			_hint.autoSize = TextFieldAutoSize.LEFT;
			_hint.defaultTextFormat = new TextFormat("Verdana", 10, 0xff000000, null, true);
			_hint.background = true;
			_hint.backgroundColor = 0xeeee00;
			_hint.selectable = false;

			init(WIDTH, HEIGHT);

			this.x = x;
			this.y = y;

			drawGraph();
		}
		
		override protected function onResize( width:int, height:int ):void {
			_width = width;
			_height = height;

			drawGraph();
		}

		private function drawGraph():void {
			const w:Number = _width;
			const h:Number = _height;

			_graph.removeChildren();

			var points:Array = _node.getParameter("POINTS") as Array;

			var dot:Sprite;

			for each( var a:Array in points ) {
				dot = addDot( w * a[0], h * (1-a[1]) );
				_graph.addChild(dot);
			}

			drawGraphLines();
		}

		private function drawGraphLines():void {
			const w:Number = _width;
			const h:Number = _height;

			with( _graph.graphics ) {
				clear();

				lineStyle(1, 0x000000, 1);

				beginFill(0xffffff, 1);
				drawRect(0, 0, w, h);
				endFill();

				lineStyle(1,0x000000, 0.5);
				moveTo(0, h/2);
				lineTo(w, h/2);

				lineStyle(1,0x000000, 0.25);
				moveTo(0, h/4);
				lineTo(w, h/4);
				moveTo(0, (h/4)*3);
				lineTo(w, (h/4)*3);
			}

			var p1:DisplayObject;
			var p2:DisplayObject;

			const len:int = _graph.numChildren;
			for( var i:int = 0; i < len-1; i++ ) {
				p1 = _graph.getChildAt(i);
				p2 = _graph.getChildAt(i+1);

				_graph.graphics.moveTo(p1.x, p1.y);
				_graph.graphics.lineTo(p2.x, p2.y);
			}
		}

		private function addDot(x:Number, y:Number):Sprite {
			var dot:Sprite = new Sprite();
			with( dot.graphics ) {
				lineStyle(1, 0x000000, 1);
				beginFill(0x990000,1);
				drawCircle(0, 0, 5);
				endFill();
			}
			dot.doubleClickEnabled = true;
			dot.buttonMode = true;
			dot.x = x;
			dot.y = y;
			dot.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			dot.addEventListener(MouseEvent.DOUBLE_CLICK, onDotDoubleClick);
			dot.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			dot.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			return dot;
		}

		private function onMouseOver(e:MouseEvent):void {
			if( _dragging != null ) return;

			const w:Number = _width;
			const h:Number = _height;

			var dragging:Sprite = e.target as Sprite;

			const a:Number = _node.getParameter("FROM") as Number;
			const b:Number = _node.getParameter("TO") as Number;
			const val:Number = a + (b - a) * (1-(dragging.y / h));

			_hint.text = 	"T: " + (dragging.x / w).toFixed(4) +
							"\nV: " + val.toFixed(4);
			_hint.x = e.stageX + 25;
			_hint.y = e.stageY + 25;
			BaseDialogue.DIALOGUES.addChild(_hint);
		}

		private function onMouseOut(e:MouseEvent):void {
			if( _dragging != null ) return;

			if( _hint.parent != null ) {
				BaseDialogue.DIALOGUES.removeChild(_hint);
			}
		}

		private function onMouseDown(e:MouseEvent):void {
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			const w:Number = _width;
			const h:Number = _height;

			_dragging = e.target as Sprite;

			var r:Rectangle = new Rectangle(0,0,w,h);

			if( _dragging.x == 0 || _dragging.x == r.width) {
				if( _dragging.x == 0 ) {
					r.x = 0;
					r.width = 0;
				} else {
					r.x = r.width;
					r.width = 0;
				}
			} else {
				r.x += 0.01;
				r.width -= 0.02;

				if( e.shiftKey ) {
					r.x = _dragging.x;
					r.width = 0;
				}
				if( e.controlKey || e.commandKey ) {
					r.y = _dragging.y;
					r.height = 0;
				}
			}

			_dragging.startDrag(false, r);

			const a:Number = _node.getParameter("FROM") as Number;
			const b:Number = _node.getParameter("TO") as Number;
			const val:Number = a + (b - a) * (1-(_dragging.y / h));

			_hint.text = 	"T: " + (_dragging.x / w).toFixed(4) +
							"\nV: " + val.toFixed(4);
			_hint.x = e.stageX + 25;
			_hint.y = e.stageY + 25;
			BaseDialogue.DIALOGUES.addChild(_hint);
		}

		private function onMouseMove(e:MouseEvent):void {
			sort();
			drawGraphLines();

			const w:Number = _width;
			const h:Number = _height;

			const a:Number = _node.getParameter("FROM") as Number;
			const b:Number = _node.getParameter("TO") as Number;
			const val:Number = a + (b - a) * (1-(_dragging.y / h));

			_hint.text = 	"T: " + (_dragging.x / w).toFixed(4) +
							"\nV: " + val.toFixed(4);
			_hint.x = e.stageX + 25;
			_hint.y = e.stageY + 25;
		}

		private function onMouseUp(e:MouseEvent):void {
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			_dragging.stopDrag();
			_dragging = null;

			BaseDialogue.DIALOGUES.removeChild(_hint);

			save();
		}

		private function onDoubleClick(e:MouseEvent):void {
			if( e.target != _graph ) return;

			const w:Number = _width;
			const h:Number = _height;

			var x:Number = Math.max( 0.1, Math.min( w-0.1, e.localX ) );
			var y:Number = Math.max( 0.1, Math.min( h-0.1, e.localY ) );

			var dot:Sprite = addDot(x, y);
			_graph.addChild(dot);

			sort();
			save();
			drawGraph();
		}

		private function onDotDoubleClick(e:MouseEvent):void {
			var dot:Sprite = e.target as Sprite;

			dot.parent.removeChild(dot);

			sort();
			save();
			drawGraph();
		}

		private function sort():void {
			var found:Boolean = true;

			const len:int = _graph.numChildren-1;
			var i:int;

			while( found ) {
				found = false;

				for( i = len; i >= 1; i-- ) {
					if( _graph.getChildAt(i).x < _graph.getChildAt(i-1).x ) {
						_graph.swapChildrenAt(i, i-1);
						found = true;
					}
				}
			}
		}

		private function save():void {
			const w:Number = _width;
			const h:Number = _height;

			var a:Array = [];

			var dot:Sprite;

			const len:int = _graph.numChildren;
			for( var i:int = 0; i < len; i++ ) {
				dot = _graph.getChildAt(i) as Sprite;

				a.push( [dot.x/w, 1-dot.y/h] );
			}

			_node.setParameter("POINTS", a);
		}
	}
}
