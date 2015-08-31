package com.tbbgc.denom {
	import com.stardoll.codebase.layout.CB_layoutDB;
	import com.tbbgc.denom.flow.DenomFlow;
	import com.tbbgc.denom.managers.FileManager;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.nodes.carbon.CarbonNode;
	import com.tbbgc.denom.nodes.starling.ScreenSizeNode;
	import com.tbbgc.denom.ns.DenomPrivate;
	import com.tbbgc.denom.utils.Load;

	import org.osflash.signals.Signal;
	/**
	 * @author simonrodriguez
	 */
	public class Denom {
		private var _load:Load;

		private var _flows:Vector.<FlowModel>;

		private var _references:Vector.<DenomFlow>;

		public function Denom( enableReload:Boolean=true ) {
			if( enableReload ) {
				_references = new Vector.<DenomFlow>();
			}

			_load = new Load();
		}

		public function registerFileManager( base:String, remote:String=null):void {
			BaseNode.FILE = new FileManager();
			BaseNode.FILE.base = base;
			BaseNode.FILE.remote = remote;
		}

		public function registerEnterFrame( signal:Signal ):void {
			BaseNode.ENTER_FRAME = signal;
		}

		public function registerScreenSize( width:int, height:int ):void {
			ScreenSizeNode.WIDTH = width;
			ScreenSizeNode.HEIGHT = height;
		}

		public function registerLayoutDB( layoutDB:CB_layoutDB ):void {
			CarbonNode.LAYOUTDB = layoutDB;
		}

		public function setJSON( json:Object ):void {
			var len:int = 0;
			for each( var obj:Object in json["views"] ) {
				len++;
			}

			_flows = new Vector.<FlowModel>( len, true );

			var model:FlowModel;

			len = 0;
			for each( obj in json["views"] ) {
				model = new FlowModel;
				model.name = obj["name"];
				model.nodes = obj["nodes"];

				_flows[len] = model;

				len++;
			}

			if( enabledReload ) {
				for( len = _references.length-1; len >= 0; len-- ) {
					if( _references[len].isDisposed ) {
						_references.splice(len, 1);
					} else {
						_references[len].DenomPrivate::setup( _load.run( getFlowData(_references[len].name), _references[len] ) );
					}
				}
			}
		}

		public function getFlow( name:String ):DenomFlow {
			var data:Array = getFlowData( name );
			if( data != null ) {
				var flow:DenomFlow = new DenomFlow( enabledReload ? name : null );
				flow.DenomPrivate::setup( _load.run( data, flow ) );

				if( enabledReload ) {
					_references.push( flow );
				}

				return flow;
			}

			return null;
		}

		private function get enabledReload():Boolean { return (_references!=null); }

		private function getFlowData( name:String ):Array {
			const len:int = _flows.length;
			for( var i:int = 0; i < len; i++ ) {
				if( _flows[i].name == name ) {
					return _flows[i].nodes;
				}
			}

			return null;
		}
	}
}



internal class FlowModel {
	public var name:String;
	public var nodes:Array;
}