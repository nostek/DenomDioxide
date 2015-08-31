package com.tbbgc.denom.dialogues {
	import fl.controls.Button;

	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author simonrodriguez
	 */
	public class PopupDialogue extends BaseDialogue {
		public function PopupDialogue( caption:String, text:String ) {
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

			var button:Button = new Button();
			button.label = "OK";
			button.x = WIDTH/2 - button.width/2;
			button.y = HEIGHT - (button.height + 10);
			button.addEventListener(MouseEvent.CLICK, onButton);
			addChild(button);

			super(WIDTH, HEIGHT, caption, false, true, false);
		}

		private function onButton(e:MouseEvent):void {
			close();
		}
	}
}
