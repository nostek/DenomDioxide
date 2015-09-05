package com.tbbgc.denom.saveload {
	import com.tbbgc.denom.managers.SettingsManager;
	import com.tbbgc.denom.models.FlowModel;

	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	/**
	 * @author simonrodriguez
	 */
	public class Load {
		private static var _lastUsedFile:File;

		private static var _onComplete:Function;
		private static var _onPreLoad:Function;

		public static function get lastUsedFile():File { return _lastUsedFile; }

		public static function runFirst( onPreLoad:Function, onComplete:Function ):void {
			if( SettingsManager.haveItem( SettingsManager.SETTINGS_JSON) ) {
				_onPreLoad = onPreLoad;
				_onComplete = onComplete;

				var path:String = SettingsManager.getItem( SettingsManager.SETTINGS_JSON ) as String;

				onFileSelect( null, path );
			}
		}

		public static function run( onPreLoad:Function, onComplete:Function ):void {
			_onPreLoad = onPreLoad;
			_onComplete = onComplete;

			var jsons:FileFilter = new FileFilter("Json", "*.json");
			var f:File = new File();
			f.addEventListener(Event.SELECT, onFileSelect);
			f.browseForOpen("Open denom flow", [jsons]);
		}

		private static function onFileSelect( e:Event, path:String=null ):void {
			_onPreLoad();

			var f:File;

			if( path != null ) {
				f = new File( path );
			} else {
				f = e.target as File;
			}

			var stream:FileStream = new FileStream();
			stream.open(f, FileMode.READ);
			var json:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();

			load( JSON.parse(json) );

			SettingsManager.setItem( SettingsManager.SETTINGS_JSON, f.nativePath );

			_lastUsedFile = f;
		}

		private static function load( data:Object ):void {
			var flows:Vector.<FlowModel> = null;
			
			if (data["version"] == 1) {
				flows = Load_v1.run(data);	
			}
			if (data["version"] == 2) {
				flows = Load_v2.run(data);	
			}

			_onComplete( flows );
		}
	}
}
