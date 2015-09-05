package com.tbbgc.denom.managers {
	import com.tbbgc.denom.models.DataModel;

	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	/**
	 * @author Simon
	 */
	public class PluginManager {
		private static var _plugins:Vector.<Object>;

		public function PluginManager() {
			_plugins = new Vector.<Object>();
		}

		public static function get plugins():Vector.<Object> {
			return _plugins;
		}

		public static function getPluginName(data:Object):String {
			return data["name"];
		}

		public static function getPluginByName(name:String):Object {
			const len:int = _plugins.length;
			for (var i:int = 0; i < len; i++) {
				if (PluginManager.getPluginName(_plugins[i]) == name) {
					return _plugins[i];
				}
			}

			return null;
		}

		public static function runFirst():void {
			if (SettingsManager.haveItem( SettingsManager.SETTINGS_PLUGINS )) {
				var path:String = SettingsManager.getItem( SettingsManager.SETTINGS_PLUGINS ) as String;

				parse( path );
			}
		}

		////////////////////////

		public static function askFolder():void {
			var f:File = new File();
			f.addEventListener(Event.SELECT, onFolderSelected);
			f.browseForDirectory("Select plugins directory");
		}

		private static function onFolderSelected(e:Event):void {
			var file:File = e.target as File;

			const path:String = file.nativePath + "/";

			PluginManager.parse( path );
		}

		////////////////////////

		private static function parse( path:String ):void {
			var file:File = new File( path );

			_plugins = new Vector.<Object>();

			parseFolder( file, file );

			SettingsManager.setItem( SettingsManager.SETTINGS_PLUGINS, path );

			DataModel.ON_PLUGINS_SET.dispatch();
		}

		private static function parseFolder( file:File, base:File ):void {
			var files:Array = file.getDirectoryListing();

			for each (var f:File in files) {
				if (!f.isDirectory) {
					if (f.extension.toLowerCase() == "json") {
						parseFile(f);
					}
				} else if (f.isDirectory) {
					parseFolder( f, base );
				}
			}
		}

		private static function parseFile(file:File):void {
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);

			fs.position = 0;
				var data:String = fs.readUTFBytes(fs.bytesAvailable);
			fs.close();

			if (data != null && data.length > 0) {
				try {
					var json:Object = JSON.parse(data);

					if (json["denom_plugin"] == null) {
						return;
					}

					_plugins.push( json );
				} catch (e:*) {
					//Could not load file.
				}
			}
		}
	}
}
