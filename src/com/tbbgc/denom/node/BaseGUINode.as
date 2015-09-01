package com.tbbgc.denom.node {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.common.interfaces.INodeEvent;
	import com.tbbgc.denom.common.models.AvailableNodes;
	import com.tbbgc.denom.common.nodes.NoteNode;
	import com.tbbgc.denom.common.nodes.conditional.OverLevelValueNode;
	import com.tbbgc.denom.common.nodes.events.EventNode;
	import com.tbbgc.denom.common.nodes.events.PostEventNode;
	import com.tbbgc.denom.common.nodes.parameters.ParameterNode;
	import com.tbbgc.denom.common.nodes.selectors.SelectRandomNode;
	import com.tbbgc.denom.common.nodes.selectors.SelectRandomWeightNode;
	import com.tbbgc.denom.common.nodes.selectors.SelectSwitchValueNode;
	import com.tbbgc.denom.common.nodes.sound.AdvancedSoundNode;
	import com.tbbgc.denom.common.nodes.sound.MusicNode;
	import com.tbbgc.denom.common.nodes.sound.SoundNode;
	import com.tbbgc.denom.common.nodes.values.BooleanNode;
	import com.tbbgc.denom.common.nodes.values.GraphNode;
	import com.tbbgc.denom.common.nodes.values.NumberNode;
	import com.tbbgc.denom.common.nodes.values.TextNode;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.dialogues.BaseDialogue;
	import com.tbbgc.denom.dialogues.GraphDialogue;
	import com.tbbgc.denom.dialogues.SliderDialogue;
	import com.tbbgc.denom.models.DataModel;
	import com.tbbgc.denom.models.UI;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * @author simon
	 */
	public class BaseGUINode extends Sprite {
		private static var _draggers:Array;
		private static var _oldX:Number, _oldY:Number;

		private var _background:Background;

		private var _lines:Vector.<Sprite>;

		private var _pending:NodeInput;

		private var _menu:ContextMenu;

		private var _leftConnections:Vector.<DisplayObject>;
		private var _rightConnections:Vector.<DisplayObject>;

		public function BaseGUINode() {
			super();

			draw();

			_pending = null;

			_lines = new Vector.<Sprite>();

			this.mouseChildren = false;
			this.doubleClickEnabled = true;

			var ctxtest:ContextMenuItem = new ContextMenuItem("Test");
			ctxtest.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onTest);

			var ctxstart:ContextMenuItem = new ContextMenuItem("Start");
			ctxstart.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onEventStart);
			var ctxstop:ContextMenuItem = new ContextMenuItem("Stop");
			ctxstop.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onEventStop);

			var ctxdelete:ContextMenuItem = new ContextMenuItem("Delete");
			ctxdelete.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onDelete);

			var ctxextra:ContextMenuItem;

			var c:Class;

			for each( var testc:Class in AvailableNodes.AVAILABLE_NODES ) {
				if( this is testc ) {
					c = testc;
					break;
				}
			}

			switch( c ) {
				case GraphNode:
					ctxextra = new ContextMenuItem("Editor");
					ctxextra.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onEditor);
				break;

				case ParameterNode:
					ctxextra = new ContextMenuItem("Slider");
					ctxextra.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onSlider);
				break;

				case EventNode:
				case PostEventNode:
				case BooleanNode:
				case NumberNode:
				case TextNode:
				case AdvancedSoundNode:
				case SoundNode:
				case MusicNode:
				case SelectRandomWeightNode:
				case SelectSwitchValueNode:
				case SelectRandomNode:
				case OverLevelValueNode:
				case NoteNode:
					ctxextra = new ContextMenuItem("Change: [" + (this as BaseNode).getParameters()[0].name + "]");
					ctxextra.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onChangeParameter);
				break;

				default: break;
			}

			_menu = new ContextMenu();
			if( c != EventNode ) {
				_menu.items = ctxextra != null ? [ ctxextra, ctxtest, ctxdelete ] : [ ctxtest, ctxdelete ];
			} else {
				_menu.items = [ ctxextra, ctxstart, ctxstop, ctxdelete ];
			}

			this.addEventListener(MouseEvent.MOUSE_DOWN, onNodeMouseDown);
			this.addEventListener(MouseEvent.DOUBLE_CLICK, onNodeDblClick);
			this.addEventListener(MouseEvent.RIGHT_CLICK, onNodeRightClick);

			DataModel.SELECTED_NODE.onChanged.add( onSelectedNode );
			DataModel.DRAW_LINES.add( updateLines );
			DataModel.DELETE_ALL.add( onDelete );
			DataModel.DRAW.add( draw );
		}

		private function onSelectedNode():void {
			this.filters = [];

			if( DataModel.SELECTED_NODE.value as INode == this ) {
				this.filters = [ new GlowFilter(0xff0000aa,1,6,6,2,1,false) ];
			}
		}

		protected function draw():void {
			this.removeChildren();

			_background = new Background();
			addChild(_background);

			var fmtmain:TextFormat = new TextFormat("Verdana", 10, 0xffffffff, null, false, null, null, null, TextFormatAlign.CENTER);
			var fmt:TextFormat = new TextFormat("Verdana", 9, 0xffffffff, true, false, null, null, null, TextFormatAlign.LEFT);

			var _text:TextField = new TextField();
			_text.autoSize = TextFieldAutoSize.CENTER;
			_text.selectable = false;
			_text.defaultTextFormat = fmtmain;
			_text.y = _background.padding;
			addChild(_text);

			if( this is NoteNode ) {
				_text.width = 300;
				_text.multiline = true;
				_text.wordWrap = true;
			}

			_text.text = (this as INode).nodeName;
			if( (this as BaseNode).getParameters() != null ) {
				var pval:String;
				
				_text.appendText("\n");
				for each( var param:NodeParameter in (this as BaseNode).getParameters() ) {
					pval = param.value;
					
					if (!(this is NoteNode) && pval.length > 25) {
						pval = "..." + pval.substr(pval.length-25);
					}
					
					_text.appendText("\n[" + param.name + "]: " + pval);
				}
			}

			var minleft:int = 0, maxright:int = 0, maxheight:int = _text.y + _text.height;

			var i:int;
			var nname:TextField;
			var nodeconn:Shape;

			var left:Vector.<NodeInput> = (this as BaseNode).getLeft();
			var right:Vector.<NodeInput> = (this as BaseNode).getRight();

			if( left != null ) {
				const llen:int = left.length;

				_leftConnections = new Vector.<DisplayObject>( llen, true );

				for( i = 0; i < llen; i++ ) {
					nodeconn = new ConnectionLeft();
					nodeconn.x = -nodeconn.width/2;
					nodeconn.y = _background.padding + (30 * i) - nodeconn.height/2;
					addChild(nodeconn);

					_leftConnections[i] = nodeconn;

					maxheight = Math.max( maxheight, nodeconn.y + nodeconn.height );

					nname = new TextField();
					nname.defaultTextFormat = fmt;
					nname.selectable = false;
					nname.autoSize = TextFieldAutoSize.LEFT;
					nname.text = left[i].name;
					nname.y = _background.padding + (30 * i) - nname.height/2;
					nname.x = _background.padding;
					addChild(nname);

					minleft = Math.max( minleft, nname.x + nname.width + 20 );
				}
			}

			_text.x = Math.max( _background.padding, minleft);

			if( right != null ) {
				const rlen:int = right.length;

				_rightConnections = new Vector.<DisplayObject>( rlen, true );

				for( i = 0; i < rlen; i++ ) {
					nname = new TextField();
					nname.defaultTextFormat = fmt;
					nname.selectable = false;
					nname.autoSize = TextFieldAutoSize.LEFT;
					nname.text = right[i].name;
					maxright = Math.max( maxright, nname.width + 20 );
				}

				for( i = 0; i < rlen; i++ ) {
					nodeconn = new ConnectionRight();
					nodeconn.x = (20 + _text.x + _text.width + maxright) - nodeconn.width/2;
					nodeconn.y = _background.padding + (30 * i) - nodeconn.height/2;
					addChild(nodeconn);

					_rightConnections[i] = nodeconn;

					maxheight = Math.max( maxheight, nodeconn.y + nodeconn.height );

					nname = new TextField();
					nname.defaultTextFormat = fmt;
					nname.selectable = false;
					nname.autoSize = TextFieldAutoSize.LEFT;
					nname.text = right[i].name;
					nname.y = _background.padding + (30 * i) - nname.height/2;
					nname.x = (_text.x + _text.width + maxright) - nname.width;
					addChild(nname);
				}
			}

			_background.width = 20 + _text.x + _text.width + maxright;
			_background.height = maxheight + _background.padding;

			updateLines();
		}

		private function updateLines():void {
			for each( var line:LineSprite in _lines ) {
				if( line.parent == this ) {
					this.removeChild( line );
				}
			}

			_lines = new Vector.<Sprite>();

			var right:Vector.<NodeInput> = (this as BaseNode).getRight();

			if( right ) {
				var pt:Point;
				var src:Point;
				var dest:Point;

				var index:int;

				for each( var node:NodeInput in right ) {
					pt = getConnectionPosition( node );
					src = getConnectionPosition( node, true );

					index = 0;

					for each( var child:NodeInput in node.connections ) {
						dest = (child.owner as BaseNode).getConnectionPosition(child, true);

						line = new LineSprite(node, child, index, new Point(pt.x + (dest.x-src.x)*0.5, pt.y + (dest.y-src.y)*0.5));
						_lines.push(line);
						addChild(line);

						line.graphics.lineStyle(UI.SIZE_LINE,UI.COLOR_LINE);
						line.graphics.moveTo(pt.x, pt.y);
						line.graphics.lineTo(pt.x + (dest.x-src.x), pt.y + (dest.y-src.y));

						index++;
					}
				}
			}
		}

		public function getConnection( x:Number, y:Number, side:int=0 ):NodeInput {
			var i:int;

			var d:DisplayObject;

			if( side <= 0 && _leftConnections!= null ) {
				const llen:int = _leftConnections.length;

				for( i = 0; i < llen; i++ ) {
					d = _leftConnections[i];

					if( x >= d.x && d.x <= d.x+d.width && y >= d.y && y <= d.y+d.height ) {
						return (this as BaseNode).getLeft()[i];
					}
				}
			}

			if( side >= 0 && _rightConnections != null ) {
				const rlen:int = _rightConnections.length;

				for( i = 0; i < rlen; i++ ) {
					d = _rightConnections[i];

					if( x >= d.x && d.x <= d.x+d.width && y >= d.y && y <= d.y+d.height ) {
						return (this as BaseNode).getRight()[i];
					}
				}
			}

			return null;
		}

		public function getConnectionPosition( conn:NodeInput, inclParent:Boolean=false ):Point {
			var i:int;

			var left:Vector.<NodeInput> = (this as BaseNode).getLeft();
			var right:Vector.<NodeInput> = (this as BaseNode).getRight();

			var px:Number = 0;
			var py:Number = 0;

			if( inclParent ) {
				px = this.x;
				py = this.y;
			}

			if( left != null ) {
				const llen:int = left.length;

				for( i = 0; i < llen; i++ ) {
					if( left[i] == conn ) {
						return new Point(px+_leftConnections[i].x + _leftConnections[i].width/2, py+_leftConnections[i].y + _leftConnections[i].height/2);
					}
				}
			}

			if( right != null ) {
				const rlen:int = right.length;

				for( i = 0; i < rlen; i++ ) {
					if( right[i] == conn ) {
						return new Point(px+_rightConnections[i].x + _rightConnections[i].width/2, py+_rightConnections[i].y + _rightConnections[i].height/2);
					}
				}
			}

			return null;
		}

		private function onNodeDblClick(e:MouseEvent):void {
			for each( var line:LineSprite in _lines ) {
				if( line.hitTestPoint(e.stageX, e.stageY, true) ) {
					line.src.disconnect( line.dest );
					line.dest.disconnect( line.src );

					DataModel.DRAW_LINES.dispatch();

					return;
				}
			}

			onTest(null);
		}

		private function onNodeMouseDown(e:MouseEvent):void {
			DataModel.SELECTED_NODE.value = this;

			_pending = getConnection(e.localX, e.localY, 1);

			if( _pending != null && _pending.single && _pending.connections.length >= 1 ) {
				_pending = null;
			}

			if( _pending != null ) {
				DataModel.DRAW_LINE.dispatch(getConnectionPosition(_pending, true), getConnectionPosition(_pending, true));
			} else {
				_draggers = [];
				if( !e.shiftKey ) buildDraggers( this as BaseNode, this as BaseNode );

				_oldX = this.x;
				_oldY = this.y;
				this.startDrag();
			}

			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		private static function buildDraggers( node:BaseNode, ignore:BaseNode ):void {
			if( _draggers.indexOf( node ) < 0 ) {
				if( node != ignore ) _draggers.push( node );

				for each( var input:NodeInput in node.getRight() ) {
					for each( var conn:NodeInput in input.connections ) {
						buildDraggers( conn.owner as BaseNode, ignore);
					}
				}
			}
		}

		private function onMouseUp(e:MouseEvent):void {
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			DataModel.DRAW_LINE.dispatch(null, null);

			if( _draggers != null ) {
				this.stopDrag();
				_draggers = null;
				return;
			}

			if( e.target is BaseNode ) {
				var node:BaseNode = e.target as BaseNode;

				if( _pending != null ) {
					if( node != this ) {
						var conn:NodeInput = node.getConnection(e.localX, e.localY, -1);

						if( conn != null ) {
							_pending.connect( conn );
							conn.connect( _pending );

							DataModel.DRAW_LINES.dispatch();
						}
					}
				}
			}
		}

		private function onMouseMove(e:MouseEvent):void {
			if( _draggers != null ) {
				var dtx:Number = this.x - _oldX;
				var dty:Number = this.y - _oldY;

				_oldX = this.x;
				_oldY = this.y;

				for each( var node:BaseNode in _draggers ) {
					node.x += dtx;
					node.y += dty;
				}

				DataModel.DRAW_LINES.dispatch();
			}

			if( _pending != null ) {
				DataModel.DRAW_LINE.dispatch(	getConnectionPosition(_pending, true),
												this.parent.globalToLocal( new Point(e.stageX, e.stageY)));
			}
		}

		private function onNodeRightClick(e:MouseEvent):void {
			_menu.display(BaseDialogue.DIALOGUES.stage, e.stageX, e.stageY);
		}

		private function onTest(e:ContextMenuEvent):void {
			(this as BaseNode).test();
		}

		private function onEventStart(e:ContextMenuEvent):void {
			(this as INodeEvent).start();
		}
		private function onEventStop(e:ContextMenuEvent):void {
			(this as INodeEvent).stop();
		}

		protected function onDelete(e:ContextMenuEvent=null):void {
			this.parent.removeChild(this);

			DataModel.SELECTED_NODE.onChanged.remove( onSelectedNode );
			DataModel.DRAW_LINES.remove( updateLines );
			DataModel.DELETE_ALL.remove( onDelete );
			DataModel.DRAW.remove( draw );

			DataModel.DRAW_LINES.dispatch();
		}

		private function onEditor(e:ContextMenuEvent):void {
			new GraphDialogue(this as GraphNode, BaseDialogue.DIALOGUES.stage.mouseX, BaseDialogue.DIALOGUES.stage.mouseY);
		}

		private function onSlider(e:ContextMenuEvent):void {
			if( (this as BaseNode).getParameters()[0].value is Number ) {
				new SliderDialogue(this as ParameterNode, BaseDialogue.DIALOGUES.stage.mouseX, BaseDialogue.DIALOGUES.stage.mouseY);
			}
		}

		private function onChangeParameter(e:ContextMenuEvent):void {
			DataModel.EDIT_PARAMETER.dispatch( this, (this as BaseNode).getParameters()[0] );
		}
	}
}



import com.tbbgc.denom.common.input.NodeInput;
import com.tbbgc.denom.models.UI;

import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;



internal class Background extends Shape {
	public function Background() {
		with (this.graphics) {
			clear();

			beginFill(UI.COLOR_NODE, 1);
			drawRect(0, 0, 100, 100);
			endFill();
		}
	}

	public function get padding():int { return UI.SIZE_NODE_PADDING; }
}



internal class ConnectionLeft extends Shape {
	public function ConnectionLeft() {
		with (this.graphics) {
			clear();

			beginFill(UI.COLOR_NODE_LEFT, 1);
			drawCircle(UI.SIZE_NODE_LEFT, UI.SIZE_NODE_LEFT, UI.SIZE_NODE_LEFT);
			endFill();
		}
	}
}



internal class ConnectionRight extends Shape {
	public function ConnectionRight() {
		with (this.graphics) {
			clear();

			beginFill(UI.COLOR_NODE_RIGHT, 1);
			drawCircle(UI.SIZE_NODE_RIGHT, UI.SIZE_NODE_RIGHT, UI.SIZE_NODE_RIGHT);
			endFill();
		}
	}
}



internal class LineSprite extends Sprite {
	public var src:NodeInput;
	public var dest:NodeInput;

	public function LineSprite( src:NodeInput, dest:NodeInput, index:int, textpos:Point) {
		this.src = src;
		this.dest = dest;

		this.mouseChildren = false;

		var fmt:TextFormat = new TextFormat("Verdana", UI.SIZE_LINE_TEXT, UI.COLOR_LINE_TEXT, true, false, null, null, null, TextFormatAlign.CENTER);

		var tf:TextField = new TextField();
		tf.background = true;
		tf.backgroundColor = UI.COLOR_LINE_TEXT_BACKGROUND;
		tf.autoSize = TextFieldAutoSize.LEFT;
		tf.defaultTextFormat = fmt;
		tf.selectable = false;
		tf.text = index.toString();
		tf.x = textpos.x;
		tf.y = textpos.y - tf.textHeight/2;
		addChild(tf);
	}
}
