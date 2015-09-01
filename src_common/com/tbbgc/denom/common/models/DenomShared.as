package com.tbbgc.denom.common.models {
	import com.tbbgc.denom.common.managers.DenomFileManager;

	import org.osflash.signals.Signal;

	import flash.utils.Dictionary;
	/**
	 * @author simon
	 */
	public class DenomShared {
		private var _onEnterFrame:Signal;
		
		private var _onPostEvent:Signal;

		private var _fileManager:DenomFileManager;
		
		private var _globalParameters:Dictionary;
		private var _parameters:Dictionary;

		public function DenomShared( onEnterFrame:Signal, fileManager:DenomFileManager, globalParameters:Dictionary ) {
			_onEnterFrame = onEnterFrame;
			_fileManager = fileManager;
			_globalParameters = globalParameters;
			
			_onPostEvent = new Signal(String, Array);
			
			_parameters = new Dictionary();
		}

		public function get onEnterFrame():Signal {
			return _onEnterFrame;
		}
		
		public function get onPostEvent():Signal {
			return _onPostEvent;
		}

		public function get fileManager():DenomFileManager {
			return _fileManager;
		}

		public function incLoad() : void {
			
		}

		public function decLoad():void {
			
		}
		
		public function setParameter( id:String, global:Boolean, value:* ):void {
			((!global) ? _parameters : _globalParameters)[id] = value;
		}
		
		public function getParameter( id:String, global:Boolean ):* {
			return (!global) ? _parameters[id] : _globalParameters[id];
		}
	}
}
