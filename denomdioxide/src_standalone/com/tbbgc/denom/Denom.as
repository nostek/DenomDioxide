package com.tbbgc.denom {
	import com.tbbgc.denom.common.managers.DenomFileManager;
	import com.tbbgc.denom.common.models.DenomShared;
	import com.tbbgc.denom.flow.DenomFlow;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.saveload.Load_v2;
	import com.tbbgc.denom.saveload.SLKeys;

	import org.osflash.signals.Signal;

	import flash.utils.Dictionary;
	/**
	 * @author simonrodriguez
	 */
	public class Denom {
		public static const IS_EDITOR:Boolean = false;

		private var _fileManager:DenomFileManager;

		private var _onEnterFrame:Signal;
		private var _globalParameters:Dictionary;
		private var _plugins:Dictionary;

		private var _version:int;
		private var _strings:Array;
		private var _flows:Dictionary;

		public function Denom() {
			_onEnterFrame = new Signal();
			_globalParameters = new Dictionary();
			_plugins = new Dictionary();
		}

		public function dispose():void {
			_onEnterFrame.removeAll();
		}

		public function set fileManager(files:DenomFileManager):void {
			_fileManager = files;
		}

		public function onEnterFrame():void {
			_onEnterFrame.dispatch();
		}

		public function load( data:Object ):void {
			_version = data[SLKeys.MAIN_VERSION];

			if (_version == 2) {
				_strings = data[SLKeys.MAIN_STRINGS];

				_flows = new Dictionary();

				for each (var o:Object in data[SLKeys.MAIN_VIEWS]) {
					_flows[ _strings[o[SLKeys.FLOW_NAME]] ] = o[SLKeys.FLOW_NODES];
				}
			}
		}

		public function getFlow( name:String ):DenomFlow {
			var data:Array = _flows[name];

			if( data != null ) {
				var shared:DenomShared = new DenomShared(_onEnterFrame, _fileManager, _globalParameters, _plugins);

				var nodes:Vector.<BaseNode> = null;

				if (_version == 2) {
					nodes = Load_v2.run(shared, _strings, data);
				}

				if (nodes ) {
					var flow:DenomFlow = new DenomFlow(shared, nodes);

					return flow;
				}
			}

			return null;
		}

		public function registerPlugin( id:String, callback:Function ):void {
			_plugins[id] = callback;
		}
	}
}
