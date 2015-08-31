package com.tbbgc.denom.dialogues {
	import com.tbbgc.denom.models.DataModel;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author simonrodriguez
	 */
	public class BaseDialogue extends Sprite {
		private var _noclick:Sprite;
		private var _topic:TextField;

		public static const HEADER:int = 20;

		public static const EDGE:int = 30;

		private var _canScale:Boolean;
		private var _doScale:Boolean;
		private var _sx:Number;
		private var _sy:Number;

		public function BaseDialogue( width:int, height:int, caption:String, canMinimize:Boolean=true, disableStage:Boolean=true, canScale:Boolean=true ) {
			var stage:Stage = DataModel.dialogues.stage;

			if( disableStage ) {
				_noclick = new Sprite();
				with( _noclick.graphics ) {
					beginFill( 0xffffff, 0.8 );
					drawRect(0, 0, stage.stageWidth, stage.stageHeight);
					endFill();
				}
				DataModel.dialogues.addChild(_noclick);
			}

			var fmt:TextFormat = new TextFormat("Verdana", 10, 0xffffffff, null, true);

			_topic = new TextField();
			_topic.mouseEnabled = false;
			_topic.autoSize = TextFieldAutoSize.LEFT;
			_topic.selectable = false;
			_topic.defaultTextFormat = fmt;
			_topic.text = caption;
			addChild(_topic);

			DataModel.dialogues.addChild(this);

			this.doubleClickEnabled = canMinimize;

			this.addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
			this.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			this.addEventListener(MouseEvent.DOUBLE_CLICK, onDblClick);

			_doScale = false;
			_canScale = canScale;

			super();

			resize( width, height );

			this.x = stage.stageWidth/2 - width/2;
			this.y = stage.stageHeight/2 - height/2;
		}

		protected function close():void {
			if( _noclick != null ) {
				_noclick.parent.removeChild(_noclick);
			}

			this.parent.removeChild(this);
		}

		protected function resize( width:int, height:int ):void {
			height += HEADER;

			const len:int = this.numChildren;
			for( var i:int = 0; i < len; i++ ) {
				this.getChildAt(i).y += HEADER;
			}

			with( this.graphics ) {
				clear();

				lineStyle(1,0xffffff,0.5,true,"normal",null,null,15);

				beginFill(0x000044);
					drawRoundRect(0, 0, width, height, 16);
				endFill();

				beginFill(0x000000);
					drawRoundRect(0, 0, width, HEADER, 16);

					if( _canScale ) {
						drawCircle(width-EDGE/2, height-EDGE/2, EDGE/2);
					}
				endFill();
			}

			_topic.y = 2;
			_topic.x = width/2 - _topic.width/2;
		}

		private function onStartDrag(e:MouseEvent):void {
			if( e.target == this ) {
				if( _canScale && this.scrollRect == null && e.localX > this.width-EDGE && e.localY > this.height-EDGE ) {
					_sx = e.stageX;
					_sy = e.stageY;
					_doScale = true;

					stage.addEventListener(MouseEvent.MOUSE_UP, onStopScale);
					stage.addEventListener(MouseEvent.MOUSE_MOVE, onDoScale);
				} else {
					this.startDrag();

					this.parent.setChildIndex(this, this.parent.numChildren-1);
				}
			}
		}

		private function onStopDrag(e:MouseEvent):void {
			if( !_doScale ) {
				this.stopDrag();
			}
		}

		private function onDoScale(e:MouseEvent):void {
			if( _doScale ) {
				var w:int = this.width + (e.stageX - _sx);
				var h:int = this.height + (e.stageY - _sy);

				_sx = e.stageX;
				_sy = e.stageY;

				resize(w, h-HEADER);
			}
		}

		private function onStopScale(e:MouseEvent):void {
			if( _doScale ) {
				_doScale = false;

				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDoScale);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onStopScale);
			}
		}

		private function onDblClick(e:MouseEvent):void {
			if( e.target == this && e.localY < HEADER ) {
				if( this.scrollRect == null ) {
					minimize();
				} else {
					maximize();
				}
			}
		}

		public function minimize():void {
			this.scrollRect = new Rectangle(0, 0, this.width, HEADER);
		}

		public function maximize():void {
			this.scrollRect = null;
		}
	}
}
