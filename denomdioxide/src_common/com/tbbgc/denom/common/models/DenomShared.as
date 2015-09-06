package com.tbbgc.denom.common.models {
	import com.tbbgc.denom.common.interfaces.IFileManager;
	import com.tbbgc.denom.common.nodes.PluginNode;

	import org.osflash.signals.OnceSignal;
	import org.osflash.signals.Signal;

	import flash.utils.Dictionary;
	/**
	 * @author simon
	 */
	public class DenomShared {
		private var _onLoaded:OnceSignal;
		private var _onMainEnterFrame:Signal;
		private var _onEnterFrame:Signal;
		private var _onPostEvent:Signal;

		private var _fileManager:IFileManager;

		private var _globalParameters:Dictionary;
		private var _parameters:Dictionary;
		private var _plugins:Dictionary;

		private var _count:int;

		public function DenomShared( onMainEnterFrame:Signal, fileManager:IFileManager, globalParameters:Dictionary, plugins:Dictionary ) {
			_onMainEnterFrame = onMainEnterFrame;
			_fileManager = fileManager;
			_globalParameters = globalParameters;
			_plugins = plugins;

			_onEnterFrame = new Signal();
			_onLoaded = new OnceSignal();
			_onPostEvent = new Signal(String, Array);

			_parameters = new Dictionary();

			_count = 0;

			_onMainEnterFrame.add(update);
		}

		public function dispose():void {
			_onMainEnterFrame.remove(update);
			_onMainEnterFrame = null;

			_onEnterFrame.removeAll();
			_onLoaded.removeAll();
			_onPostEvent.removeAll();

			_fileManager = null;
			_globalParameters = null;
			_parameters = null;
			_plugins = null;
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

		public function get fileManager():IFileManager {
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

		private function update():void {
			_onEnterFrame.dispatch();
		}
	}
}
