package com.tbbgc.denom.dialogues {
	import fl.controls.Button;

	import org.osflash.signals.OnceSignal;

	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author simonrodriguez
	 */
	public class YesNoDialogue extends BaseDialogue {
		private var _label:TextField;
		private var _yes:Button;
		private var _no:Button;

		private var _onYes:OnceSignal;
		private var _onNo:OnceSignal;

		private var _data:Object;

		public function YesNoDialogue( caption:String, text:String, data:Object=null ) {
			const WIDTH:int = 300;
			const HEIGHT:int = 150;

			_data = data;

			super(caption, false, true, false, false);

			var fmt:TextFormat = new TextFormat("Verdana", 10, 0xffffffff, null, true, null, null, null, TextFormatAlign.CENTER);

			_onYes = new OnceSignal();
			_onNo = new OnceSignal();

			_label = new TextField();
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.selectable = false;
			_label.wordWrap = true;
			_label.defaultTextFormat = fmt;
			_label.text = text;
			container.addChild(_label);

			_yes = new Button();
			_yes.label = "YES";
			_yes.addEventListener(MouseEvent.CLICK, onButtonYes);
			container.addChild(_yes);

			_no = new Button();
			_no.label = "NO";
			_no.addEventListener(MouseEvent.CLICK, onButtonNo);
			container.addChild(_no);

			init(WIDTH, HEIGHT);
		}

		public function get onYes():OnceSignal { return _onYes; }
		public function get onNo():OnceSignal { return _onNo; }

		override protected function onResize( width:int, height:int ):void {
			_no.x = width - _no.width;

			_yes.y = _no.y = height - _yes.height;

			_label.width = width;
			_label.y = _yes.y/2 - _label.height/2;
		}

		private function onButtonYes(e:MouseEvent):void {
			if( _data != null ) {
				_onYes.dispatch( _data );
			} else {
				_onYes.dispatch();
			}
			close();
		}

		private function onButtonNo(e:MouseEvent):void {
			if( _data != null ) {
				_onNo.dispatch( _data );
			} else {
				_onNo.dispatch();
			}
			close();
		}
	}
}
