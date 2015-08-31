package com.tbbgc.denom.managers {
	import org.osflash.signals.Signal;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	/**
	 * @author simonrodriguez
	 */
	public class DenomFileManager {
		private var _base:String;

		private var _onLoad:Signal;

		public function DenomFileManager() {
			_onLoad = new Signal( String, ByteArray );
		}

		public function set base(url:String):void {
			_base = url;
		}

		public function get onLoad():Signal {
			return _onLoad;
		}

		public function getFullURL( file:String ):String {
			return File.applicationDirectory.resolvePath(_base + file).url;
		}

		public function getFile( file:String ):void {
			var f:File = new File( _base + file );

			var ba:ByteArray = new ByteArray();

			var stream:FileStream = new FileStream;
			stream.open(f, FileMode.READ);
			stream.readBytes(ba, 0, stream.bytesAvailable);
			stream.close();

			_onLoad.dispatch( file, ba );
		}
	}
}
