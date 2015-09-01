package com.tbbgc.denom.common.nodes.parameters {
	import com.tbbgc.denom.Denom;
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

		private var _name:NodeParameter;
		private var _value:NodeParameter;
		private var _global:NodeParameter;

		public function ParameterNode() {
			_get = new NodeInput(this, "GET", onGet);

			_name = new NodeParameter("NAME", "undefined");
			_value = new NodeParameter("VALUE", 0);
			_global = new NodeParameter("GLOBAL", false);

			left( _get );

			right();

			parameters( _value, _name, _global );

			super();
		}

		public function get nodeName() : String {
			return "CODE PARAMETER";
		}

		private function onGet(...args):* {
			if (!Denom.IS_EDITOR) {
				return this.shared.getParameter( _name.value, _global.value as Boolean );
			}
			return _value.value;
		}

		public function get parameterName() : String {
			return _name.value as String;
		}

		public function set parameter(value : *) : void {
			if (!Denom.IS_EDITOR) {
				this.shared.setParameter( _name.value, _global.value as Boolean, value );
			}
			_value.value = value;
		}

		public function get parameter() : * {
			return _value.value;
		}
	}
}
