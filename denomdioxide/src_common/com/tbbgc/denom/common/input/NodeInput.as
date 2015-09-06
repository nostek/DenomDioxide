package com.tbbgc.denom.common.input {
	import com.tbbgc.denom.common.interfaces.INode;
	/**
	 * @author simonrodriguez
	 */
	public class NodeInput {
		private var _name:String;

		private var _owner:INode;

		protected var _run:Function;

		private var _single:Boolean;

		private var _connections:Vector.<NodeInput>;

		public function NodeInput( owner:INode, name:String, run:Function, single:Boolean=false ):void {
			_owner = owner;
			_name = name;
			_single = single;
			_run = run;

			_connections = new Vector.<NodeInput>();
		}

		public function get name():String { return _name; }

		public function get owner():INode { return _owner; }

		public function get single():Boolean { return _single; }

		public function get connections():Vector.<NodeInput> { return _connections; }

		public function get haveConnections():Boolean { return (_connections.length>0); }

		public function connect( conn:NodeInput ):void {
			_connections.push( conn );
		}

		public function disconnect( conn:NodeInput ):void {
			_connections.splice( _connections.indexOf(conn), 1 );
		}

		public function run():* {
			if (_run != null) {
				return _run();
			}
		}

		public function runConnections():void {
			const len:int = _connections.length;
			for (var i:int = 0; i < len; i++) {
				_connections[i].run();
			}
		}

		public function runFirst():* {
			if (_connections.length > 0) {
				return _connections[0].run();
			}
			return null;
		}
	}
}
