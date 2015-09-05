package com.tbbgc.denom.dialogues {
	import fl.controls.Button;
	import fl.controls.TextInput;

	import org.osflash.signals.OnceSignal;

	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;

	/**
	 * @author simonrodriguez
	 */
	public class InputDialogue extends BaseDialogue {
		private var _onOK:OnceSignal;

		private var _label:TextField;
		private var _button:Button;
		private var _input:TextInput;

		public function InputDialogue( caption:String, text:String, start:String=null ) {
			const WIDTH:int = 300;
			const HEIGHT:int = 150;

			super(caption, false, true, true, true);

			_onOK = new OnceSignal( String );

			var fmt:TextFormat = new TextFormat("Verdana", 10, 0xffffffff, null, true);

			_label = new TextField();
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.selectable = false;
			_label.wordWrap = true;
			_label.defaultTextFormat = fmt;
			_label.text = text;
			container.addChild(_label);

			_button = new Button();
			_button.label = "OK";
			_button.addEventListener(MouseEvent.CLICK, onButton);
			container.addChild(_button);

			_input = new TextInput();
			_input.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			if( start != null ) _input.text = start;
			container.addChild(_input);

			init(WIDTH, HEIGHT);

			setTimeout(onFocusSet, 150);
		}

		override protected function onResize( width:int, height:int ):void {
			_label.width = width;

			_input.width = width;
			_input.y = _label.y + _label.height + 10;

			_button.x = width/2 - _button.width/2;
			_button.y = height - _button.height;
		}

		private function onFocusSet():void {
			_input.setFocus();
		}

		override protected function close():void {
			_input.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);

			super.close();
		}

		public function get onOK():OnceSignal { return _onOK; }

		private function onButton(e:MouseEvent):void {
			_onOK.dispatch( _input.text );

			close();
		}

		private function onKeyUp(e:KeyboardEvent):void {
			if( e.keyCode == Keyboard.ENTER ) {
				onButton(null);
			}
			if( e.keyCode == Keyboard.ESCAPE ) {
				close();
			}
		}
	}
}
