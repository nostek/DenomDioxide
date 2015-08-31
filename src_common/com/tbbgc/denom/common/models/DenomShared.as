package com.tbbgc.denom.common.models {
	import com.tbbgc.denom.common.managers.DenomFileManager;

	import org.osflash.signals.Signal;
	/**
	 * @author simon
	 */
	public class DenomShared {
		private var _onEnterFrame:Signal;

		private var _fileManager:DenomFileManager;

		public function DenomShared( onEnterFrame:Signal, fileManager:DenomFileManager ) {
			_onEnterFrame = onEnterFrame;
			_fileManager = fileManager;
		}

		public function get onEnterFrame():Signal {
			return _onEnterFrame;
		}

		public function get fileManager():DenomFileManager {
			return _fileManager;
		}

		public function incLoad() : void {
		}

		public function decLoad():void {
		}
	}
}
