package com.tbbgc.denom.dialogues {
	import fl.controls.Button;
	import fl.controls.TextArea;

	import com.tbbgc.denom.models.DataModel;

	import org.osflash.signals.Signal;

	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;

	/**
	 * @author simonrodriguez
	 */
	public class InputMultiDialogue extends BaseDialogue {
		private var _onOK:Signal;

		private var _input:TextArea;

		private var _time:uint;

		public function InputMultiDialogue(caption : String, text : String, start : String = null) {
			const WIDTH:int = 300;
			const HEIGHT:int = 500;

			var fmt:TextFormat = new TextFormat("Verdana", 10, 0xffffffff, null, true, null, null, null, TextFormatAlign.CENTER);

			var label:TextField = new TextField();
			label.autoSize = TextFieldAutoSize.LEFT;
			label.selectable = false;
			label.wordWrap = true;
			label.width = WIDTH-20;
			label.defaultTextFormat = fmt;
			label.text = text;
			label.y = 10;
			label.x = WIDTH/2 - label.width/2;
			addChild(label);

			var button:Button = new Button();
			button.label = "OK";
			button.x = WIDTH/2 - button.width/2;
			button.y = HEIGHT - (button.height + 10);
			button.addEventListener(MouseEvent.CLICK, onButton);
			addChild(button);

			var input:TextArea = new TextArea();
			input.width = WIDTH - 40;
			input.height = 400;
			input.x = WIDTH/2 - input.width/2;
			input.y = HEIGHT/2 - input.height/2;
			if( start != null ) input.text = start;
			input.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addChild(input);

			_onOK = new Signal( String );

			_input = input;

			super(WIDTH, HEIGHT, caption, false, true, false);

			_time = getTimer();
			DataModel.ENTER_FRAME.add( onFocusSet );
		}

		private function onFocusSet():void {
			if( getTimer() - _time > 150 ) {
				DataModel.ENTER_FRAME.remove( onFocusSet );

				_input.setFocus();
			}
		}

		override protected function close():void {
			super.close();

			_input.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		public function get onOK():Signal { return _onOK; }

		private function onButton(e:MouseEvent):void {
			_onOK.dispatch( _input.text );

			close();
		}

		private function onKeyUp(e:KeyboardEvent):void {
//			if( e.keyCode == Keyboard.ENTER ) {
//				onButton(null);
//			}
			if( e.keyCode == Keyboard.ESCAPE ) {
				close();
			}
		}
	}
}
