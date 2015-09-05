package com.tbbgc.denom.dialogues {
	import fl.controls.Button;
	import fl.controls.List;
	import fl.events.ComponentEvent;

	import org.osflash.signals.OnceSignal;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author simonrodriguez
	 */
	public class ManageDialogue extends BaseDialogue {
		private var _flowcontainer:Sprite;

		private var _onClose:OnceSignal;

		private var _rename:Button;
		private var _delete:Button;
		private var _list:List;

		public function ManageDialogue( flowcontainer:Sprite ) {
			const WIDTH:int = 400;
			const HEIGHT:int = 500;
			
			super("Manage", false, true, false, false);

			_flowcontainer = flowcontainer;

			_onClose = new OnceSignal();

			_rename = new Button();
			_rename.label = "Rename";
			_rename.addEventListener(ComponentEvent.BUTTON_DOWN, onRename);
			container.addChild(_rename);

			_delete = new Button();
			_delete.label = "Delete";
			_delete.addEventListener(ComponentEvent.BUTTON_DOWN, onDelete);
			container.addChild(_delete);

			_list = new List();
			container.addChild(_list);

			init(WIDTH, HEIGHT);

			buildList();
		}
		
		override protected function onResize( width:int, height:int ):void {
			_rename.x = width - _rename.width;

			_list.y = _rename.y + _rename.height + 10;
			_list.width = width;
			_list.height = height - _list.y;
		}
		
		override protected function close():void {
			_onClose.dispatch();
			
			super.close();
		}

		public function get onClose():OnceSignal { return _onClose; }

		private function buildList():void {
			_list.removeAll();

			const len:int = _flowcontainer.numChildren;
			for( var i:int = 0; i < len; i++ ) {
				_list.addItem({label: _flowcontainer.getChildAt(i).name});
			}
		}

		private function onRename(e:ComponentEvent):void {
			if( _list.selectedIndex >= 0 ) {
				const name:String = _list.selectedItem["label"];

				var d:DisplayObject = _flowcontainer.getChildByName( name );
				if( d != null ) {
					var dlg:InputDialogue = new InputDialogue("Rename Flow", "Enter name:", d.name);
					dlg.onOK.addOnce( onRenameFlow );
				}
			}
		}

		private function onRenameFlow( text:String ):void {
			const name:String = _list.selectedItem["label"];
			var d:DisplayObject = _flowcontainer.getChildByName( name );

			d.name = text;

			buildList();
		}

		private function onDelete(e:ComponentEvent):void {
			if( _list.selectedIndex >= 0 ) {
				const name:String = _list.selectedItem["label"];

				var d:DisplayObject = _flowcontainer.getChildByName( name );
				if( d != null ) {
					_flowcontainer.removeChild( d );
				}
			}

			buildList();
		}
	}
}
