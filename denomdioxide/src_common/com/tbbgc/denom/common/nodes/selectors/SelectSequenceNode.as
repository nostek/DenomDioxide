package com.tbbgc.denom.common.nodes.selectors {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class SelectSequenceNode extends BaseNode implements INode {
		private var _get:NodeInput;
		private var _reset:NodeInput;

		private var _value:NodeInput;

		private var _index:int;

		public function SelectSequenceNode() {
			_get = new NodeInput(this, "GET", onGet);
			_reset = new NodeInput(this, "RESET", onReset);

			_value = new NodeInput(this, "VALUE", null);

			_index = 0;

			left( _get, _reset );

			right( _value );

			super();
		}

		public function get nodeName() : String {
			return "SELECT SEQUENCE";
		}

		private function onReset():* {
			_index = 0;
		}

		private function onGet():* {
			const len:int = _value.connections.length;

			if( len > 0 ) {
				if( _index >= len ) {
					_index = 0;
				}

				return _value.connections[_index++].run();
			}
			return null;
		}
	}
}
