package com.tbbgc.denom.nodes.selectors {
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class SelectSwitchNode extends BaseNode implements INode {
		private var _get:NodeInput;

		private var _value:NodeInput;
		private var _default:NodeInput;
		private var _nodes:NodeInput;

		public function SelectSwitchNode() {
			_get = new NodeInput(this, "GET", onGet);

			_value = new NodeInput(this, "VALUE", null, true);
			_default = new NodeInput(this, "DEFAULT", null, true);
			_nodes = new NodeInput(this, "NODES", null);

			left( _get );

			right( _value, _default, _nodes );

			super();
		}

		public function get nodeName() : String {
			return "SWITCH NODE";
		}

		private function onGet(...args):* {
			if( _value.haveConnections && (_default.haveConnections || _nodes.haveConnections) ) {
				const val:* = _value.runFirst();

				var node:SelectSwitchValueNode;

				const len:int = _nodes.connections.length;
				for( var i:int = 0; i < len; i++ ) {
					node = _nodes.connections[i].owner as SelectSwitchValueNode;
					if( node != null && node.getParameter(null) == val ) {
						return _nodes.connections[i].run();
					}
				}

				if( _default.haveConnections ) {
					return _default.runFirst();
				}
			}

			return null;
		}
	}
}
