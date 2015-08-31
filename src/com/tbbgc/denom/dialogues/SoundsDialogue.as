package com.tbbgc.denom.dialogues {
	import fl.controls.Button;
	import fl.controls.List;
	import fl.events.ListEvent;

	import com.tbbgc.denom.managers.SettingsManager;
	import com.tbbgc.denom.models.DataModel;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.nodes.sound.AdvancedSoundNode;
	import com.tbbgc.denom.nodes.sound.MusicNode;
	import com.tbbgc.denom.nodes.sound.SoundNode;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	/**
	 * @author simonrodriguez
	 */
	public class SoundsDialogue extends BaseDialogue {
		private var _list:List;

		private var _folder:Button;

		public function SoundsDialogue() {
			const WIDTH:int = 300;
			const HEIGHT:int = 450;

			_list = new List();
			_list.allowMultipleSelection = false;
			_list.componentInspectorSetting = true;
			_list.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, onEditParameter);
			addChild( _list );

			_folder = new Button();
			_folder.label = "Select Folder";
			_folder.addEventListener(MouseEvent.CLICK, onFolderClick);
			addChild( _folder );

			super(WIDTH, HEIGHT, "Sounds", true, false, true);

			DataModel.ON_FIRST_RUN.add( onFirst );

			this.x = 20;
			this.y = 40;
		}

		override protected function resize( width:int, height:int ):void {
			_folder.width = width - 20;
			_folder.x = 10;
			_folder.y = height - BaseDialogue.EDGE - _folder.height;

			_list.x = _list.y = 10;
			_list.width = width - 20;
			_list.height = _folder.y - 20;

			super.resize(width, height);
		}

		private function onFirst():void {
			if( SettingsManager.haveItem( SettingsManager.SETTINGS_SOUNDS ) ) {
				var path:String = SettingsManager.getItem( SettingsManager.SETTINGS_SOUNDS ) as String;

				var file:File = new File( path );

				parseFolder( file, file );

				DataModel.shared.fileManager.base = path;
			}
		}

		private function onFolderClick(e:Event):void {
			var f:File = new File();
			f.addEventListener(Event.SELECT, onFolderSelected);
			f.browseForDirectory("Select sound directory");
		}

		private function onFolderSelected(e:Event):void {
			_list.removeAll();

			var file:File = e.target as File;

			const path:String = file.nativePath + "/";

			SettingsManager.setItem( SettingsManager.SETTINGS_SOUNDS, path );

			parseFolder( file, file );

			DataModel.shared.fileManager.base = path;
		}

		private function parseFolder( file:File, base:File ):void {
			var files:Array = file.getDirectoryListing();

			const baseurl:String = base.url;
			const fileurl:String = file.url;
			const padurl:String = (baseurl.length!=fileurl.length) ? fileurl.substr(baseurl.length+1) + "/" : "";

			var ext:String;

			for each( var f:File in files ) {
				if( !f.isDirectory ) {
					ext = f.extension.toLowerCase();
					if( ext == "mp3" || ext == "wav" ) {
						_list.addItem( {label: padurl + f.name, ext: ext} );
					}
				}
				if( f.isDirectory ) {
					parseFolder( f, base );
				}
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
