package com.tbbgc.denom.common.models {
	import com.tbbgc.denom.common.managers.DenomFileManager;
	import com.tbbgc.denom.common.nodes.PluginNode;

	import org.osflash.signals.OnceSignal;
	import org.osflash.signals.Signal;

	import flash.utils.Dictionary;
	/**
	 * @author simon
	 */
	public class DenomShared {
		private var _onLoaded:OnceSignal;
		private var _onEnterFrame:Signal;
		private var _onPostEvent:Signal;

		private var _fileManager:DenomFileManager;

		private var _globalParameters:Dictionary;
		private var _parameters:Dictionary;
		private var _plugins:Dictionary;

		private var _count:int;

		public function DenomShared( onEnterFrame:Signal, fileManager:DenomFileManager, globalParameters:Dictionary, plugins:Dictionary ) {
			_onEnterFrame = onEnterFrame;
			_fileManager = fileManager;
			_globalParameters = globalParameters;
			_plugins = plugins;

			_onLoaded = new OnceSignal();
			_onPostEvent = new Signal(String, Array);

			_parameters = new Dictionary();

			_count = 0;
		}

		public function dispose():void {
			_parameters = null;
			_plugins = null;

			_onLoaded.removeAll();
			_onPostEvent.removeAll();
		}

		public function get onEnterFrame():Signal {
			return _onEnterFrame;
		}

		public function get onPostEvent():Signal {
			return _onPostEvent;
		}

		public function get onLoaded():OnceSignal {
			return _onLoaded;
		}

		public function get fileManager():DenomFileManager {
			return _fileManager;
		}

		public function get isLoaded() : Boolean {
			return (_count == 0);
		}

		public function incLoad() : void {
			_count++;
		}

		public function decLoad():void {
			_count--;

			if (_count == 0) {
				_onLoaded.dispatch();
			}
		}

		public function setParameter( id:String, global:Boolean, value:* ):void {
			((!global) ? _parameters : _globalParameters)[id] = value;
		}

		public function getParameter( id:String, global:Boolean ):* {
			return (!global) ? _parameters[id] : _globalParameters[id];
		}

		public function runPlugin( id:String, node:PluginNode ):* {
			var f:Function = _plugins[id];
			if (f != null) {
				return f(node);
			}
			return null;
		}
	}
}
