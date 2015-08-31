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
		private var _onYes:OnceSignal;

		public function YesNoDialogue( caption:String, text:String ) {
			const WIDTH:int = 300;
			const HEIGHT:int = 150;

			var fmt:TextFormat = new TextFormat("Verdana", 10, 0xffffffff, null, true, null, null, null, TextFormatAlign.CENTER);

			var label:TextField = new TextField();
			label.autoSize = TextFieldAutoSize.LEFT;
			label.selectable = false;
			label.wordWrap = true;
			label.width = WIDTH - 20;
			label.defaultTextFormat = fmt;
			label.text = text;
			label.y = HEIGHT/2 - label.height/2;
			label.x = WIDTH/2 - label.width/2;
			addChild(label);

			var button_yes:Button = new Button();
			button_yes.label = "YES";
			button_yes.x = ((WIDTH/2) - button_yes.width)/2;
			button_yes.y = HEIGHT - (button_yes.height + 10);
			button_yes.addEventListener(MouseEvent.CLICK, onButtonYes);
			addChild(button_yes);

			var button_no:Button = new Button();
			button_no.label = "NO";
			button_no.x = (WIDTH/2) + (((WIDTH/2) - button_no.width)/2);
			button_no.y = HEIGHT - (button_no.height + 10);
			button_no.addEventListener(MouseEvent.CLICK, onButtonNo);
			addChild(button_no);

			_onYes = new OnceSignal();

			super(WIDTH, HEIGHT, caption, false, true, false);
		}

		public function get onYes():OnceSignal { return _onYes; }

		private function onButtonYes(e:MouseEvent):void {
			_onYes.dispatch();

			onButtonNo(null);
		}

		private function onButtonNo(e:MouseEvent):void {
			_onYes.removeAll();

			close();
		}
	}
}
