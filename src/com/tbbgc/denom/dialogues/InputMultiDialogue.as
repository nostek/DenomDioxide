package com.tbbgc.denom.dialogues {
	import fl.controls.Button;
	import fl.controls.TextArea;

	import org.osflash.signals.Signal;

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
	public class InputMultiDialogue extends BaseDialogue {
		private var _onOK:Signal;

		private var _label:TextField;
		private var _button:Button;
		private var _input:TextArea;

		public function InputMultiDialogue(caption : String, text : String, start : String = null) {
			const WIDTH:int = 300;
			const HEIGHT:int = 500;

			super(caption, false, true, true, true);
			
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

			_input = new TextArea();
			if( start != null ) _input.text = start;
			_input.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			container.addChild(_input);

			_onOK = new Signal( String );

			init(WIDTH, HEIGHT);

			setTimeout( onFocusSet, 150 );
		}

		override protected function onResize( width:int, height:int ):void {
			_label.width = width;

			_button.x = width/2 - _button.width/2;
			_button.y = height - _button.height;

			_input.width = width;
			_input.y = _label.y + _label.height + 10;
			_input.height = _button.y - _input.y - 10;
		}

		private function onFocusSet():void {
			_input.setFocus();
		}

		override protected function close():void {
			_input.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);

			super.close();
		}

		public function get onOK():Signal { return _onOK; }

		private function onButton(e:MouseEvent):void {
			_onOK.dispatch( _input.text );

			close();
		}

		private function onKeyUp(e:KeyboardEvent):void {
			if( e.keyCode == Keyboard.ESCAPE ) {
				close();
			}
		}
	}
}
