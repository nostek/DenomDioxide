package com.tbbgc.denom.dialogues {
	import fl.controls.Button;
	import fl.controls.List;
	import fl.events.ComponentEvent;

	import org.osflash.signals.Signal;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author simonrodriguez
	 */
	public class ManageDialogue extends BaseDialogue {
		private var _container:Sprite;

		private var _onClose:Signal;

		private var _list:List;

		public function ManageDialogue( container:Sprite ) {
			const WIDTH:int = 400;
			const HEIGHT:int = 500;

			_container = container;

			var button:Button = new Button();
			button.label = "Close";
			button.x = WIDTH/2 - button.width/2;
			button.y = HEIGHT - (button.height + 10);
			button.addEventListener(MouseEvent.CLICK, onButtonClose);
			addChild(button);

			var rename:Button = new Button();
			rename.label = "Rename";
			rename.x = WIDTH - 10 - rename.width;
			rename.y = 10;
			rename.addEventListener(ComponentEvent.BUTTON_DOWN, onRename);
			addChild(rename);

			var del:Button = new Button();
			del.label = "Delete";
			del.x = rename.x;
			del.y = rename.y + rename.height + 10;
			del.addEventListener(ComponentEvent.BUTTON_DOWN, onDelete);
			addChild(del);

			_list = new List();
			_list.x = 10;
			_list.y = 10;
			_list.width = rename.x - 20;
			_list.height = HEIGHT - 30 - rename.height;
			addChild(_list);

			buildList();

			super(WIDTH, HEIGHT, "Manage Flows", false, true, false);

			_onClose = new Signal();
		}

		public function get onClose():Signal { return _onClose; }

		private function onButtonClose(e:MouseEvent):void {
			_onClose.dispatch();

			close();
		}

		private function buildList():void {
			_list.removeAll();

			const len:int = _container.numChildren;
			for( var i:int = 0; i < len; i++ ) {
				_list.addItem({label: _container.getChildAt(i).name});
			}
		}

		private function onRename(e:ComponentEvent):void {
			if( _list.selectedIndex >= 0 ) {
				const name:String = _list.selectedItem["label"];

				var d:DisplayObject = _container.getChildByName( name );
				if( d != null ) {
					var dlg:InputDialogue = new InputDialogue("Rename Flow", "Enter name:", d.name);
					dlg.onOK.addOnce( onRenameFlow );
				}
			}
		}

		private function onRenameFlow( text:String ):void {
			const name:String = _list.selectedItem["label"];
			var d:DisplayObject = _container.getChildByName( name );

			d.name = text;

			buildList();
		}

		private function onDelete(e:ComponentEvent):void {
			if( _list.selectedIndex >= 0 ) {
				const name:String = _list.selectedItem["label"];

				var d:DisplayObject = _container.getChildByName( name );
				if( d != null ) {
					_container.removeChild( d );
				}
			}

			buildList();
		}
	}
}
