package com.tbbgc.denom.managers {
	import com.tbbgc.denom.models.DataModel;

	import flash.events.Event;
	import flash.filesystem.File;
	/**
	 * @author Simon
	 */
	public class SoundsManager {
		private static var _sounds:Vector.<Object>;
		
		public function SoundsManager() {
			_sounds = new Vector.<Object>();
		}
		
		public static function get sounds():Vector.<Object> {
			return _sounds;
		}
		
		public static function runFirst():void {
			if (SettingsManager.haveItem( SettingsManager.SETTINGS_SOUNDS )) {
				var path:String = SettingsManager.getItem( SettingsManager.SETTINGS_SOUNDS ) as String;

				parse( path );
			}
		}
		
		////////////////////////
		
		public static function askFolder():void {
			var f:File = new File();
			f.addEventListener(Event.SELECT, onFolderSelected);
			f.browseForDirectory("Select sound directory");
		}
		
		private static function onFolderSelected(e:Event):void {
			var file:File = e.target as File;

			const path:String = file.nativePath + "/";

			SoundsManager.parse( path );
		}

		////////////////////////		
		
		private static function parse( path:String ):void {
			var file:File = new File( path );
			
			_sounds = new Vector.<Object>();
			
			parseFolder( file, file );
			
			SettingsManager.setItem( SettingsManager.SETTINGS_SOUNDS, path );
			
			DataModel.shared.fileManager.base = path;
			
			DataModel.ON_SOUNDS_SET.dispatch();
		}
		
		private static function parseFolder( file:File, base:File ):void {
			var files:Array = file.getDirectoryListing();

			const baseurl:String = base.url;
			const fileurl:String = file.url;
			const padurl:String = (baseurl.length!=fileurl.length) ? fileurl.substr(baseurl.length+1) + "/" : "";

			var ext:String;

			for each (var f:File in files) {
				if (!f.isDirectory) {
					ext = f.extension.toLowerCase();
					if (ext == "mp3" || ext == "wav") {
						_sounds.push({label: padurl + f.name, ext: ext});
					}
				} else if (f.isDirectory) {
					parseFolder( f, base );
				}
			}
		}		
	}
}
