package com.tbbgc.denom.dialogues {
	import fl.controls.List;
	import fl.events.ListEvent;

	import com.tbbgc.denom.common.nodes.sound.AdvancedSoundNode;
	import com.tbbgc.denom.common.nodes.sound.MusicNode;
	import com.tbbgc.denom.common.nodes.sound.SoundNode;
	import com.tbbgc.denom.managers.SettingsManager;
	import com.tbbgc.denom.managers.SoundsManager;
	import com.tbbgc.denom.models.DataModel;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class SoundsDialogue extends BaseDialogue {
		private var _list:List;

		public function SoundsDialogue() {
			const WIDTH:int = 300;
			const HEIGHT:int = 450;

			super("Sounds", true, false, true, true);

			_list = new List();
			_list.allowMultipleSelection = false;
			_list.componentInspectorSetting = true;
			_list.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, onEditParameter);
			container.addChild( _list );

			init( WIDTH, HEIGHT, 20, 40, false );

			DataModel.ON_SOUNDS_SET.add( onSounds );

			onSounds();
		}

		override protected function get dialogueID():String { return SettingsManager.SETTINGS_SOUNDS_DLG; }

		override protected function onResize( width:int, height:int ):void {
			_list.width = width;
			_list.height = height;
		}

		override protected function close():void {
			DataModel.ON_SOUNDS_SET.remove( onSounds );

			super.close();
		}

		private function onSounds():void {
			_list.removeAll();

			var s:Vector.<Object> = SoundsManager.sounds;

			const len:int = s.length;
			for (var i:int = 0; i < len; i++) {
				_list.addItem( s[i] );
			}
		}

		private function onEditParameter(e:ListEvent):void {
			var base:BaseNode = DataModel.SELECTED_NODE.value as BaseNode;

			const file:String = e.item["label"];
			//const ext:String = e.item["ext"];

			if( base is AdvancedSoundNode || base is SoundNode || base is MusicNode ) {
				base.setParameter("URL", file);
			}
		}
	}
}
