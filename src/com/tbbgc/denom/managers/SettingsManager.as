package com.tbbgc.denom.managers {
	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;
	/**
	 * @author simonrodriguez
	 */
	public class SettingsManager {
		public static const SETTINGS_WINDOW:String 		= "window";
		public static const SETTINGS_SOUNDS:String 		= "sounds";
		public static const SETTINGS_SOUNDS_DLG:String 	= "sounds_dlg";
		public static const SETTINGS_PARAMS_DLG:String 	= "params_dlg";
		public static const SETTINGS_JSON:String 		= "json";

		private static var _data:Object;

		public function SettingsManager() {
			load();
		}

		private static function load():void {
			_data = {};

			var ba:ByteArray = EncryptedLocalStore.getItem("denom");

			if( ba != null ) {
				ba.position = 0;
				_data = JSON.parse( ba.readUTFBytes( ba.length ) );
			}
		}

		private static function save():void {
			var ba:ByteArray = new ByteArray();

			ba.writeUTFBytes( JSON.stringify(_data) );

			EncryptedLocalStore.setItem("denom", ba);
		}

		//////////////////////////////

		public static function setItem( key:String, data:Object ):void {
			_data[ key ] = data;

			save();
		}

		public static function getItem( key:String ):Object {
			if( _data[ key ] == null ) {
				return {};
			}
			return _data[ key ];
		}

		public static function haveItem( key:String ):Boolean {
			return (_data[ key ] != null);
		}
	}
}
