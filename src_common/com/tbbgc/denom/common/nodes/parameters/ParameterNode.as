package com.tbbgc.denom.common.nodes.parameters {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.common.interfaces.INodeParameter;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class ParameterNode extends BaseNode implements INode, INodeParameter {
		private var _get:NodeInput;

		private var _onChanged:NodeInput;

		private var _name:NodeParameter;
		private var _value:NodeParameter;

		public function ParameterNode() {
			_get = new NodeInput(this, "GET", onGet);

			_onChanged = new NodeInput(this, "ON_CHANGED", null);

			_name = new NodeParameter("NAME", "undefined");
			_value = new NodeParameter("VALUE", 0, onChange);

			left( _get );

			right( _onChanged );

			parameters( _value, _name );

			super();
		}

		public function get nodeName() : String {
			return "CODE PARAMETER";
		}

		private function onGet(...args):* {
			return _value.value;
		}

		private function onChange():void {
			_onChanged.runConnections();
		}

		public function get parameterName() : String {
			return _name.value as String;
		}

		public function set parameter(value : *) : void {
			_value.value = value;
		}

		public function get parameter() : * {
			return _value.value;
		}
	}
}
