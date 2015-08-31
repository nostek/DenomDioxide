package com.tbbgc.denom.nodes.conditional {
	import com.tbbgc.denom.parameters.NodeParameter;
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.interfaces.INode;

	/**
	 * @author simonrodriguez
	 */
	public class OverLevelValueNode extends BaseNode implements INode {
		private var _get:NodeInput;

		private var _onOver:NodeInput;

		private var _value:NodeParameter;

		public function OverLevelValueNode() {
			_get = new NodeInput(this, "GET", onGet);

			_onOver = new NodeInput(this, "ON_OVER", null);

			_value = new NodeParameter("VALUE", 0);

			left( _get );
			right( _onOver );
			parameters( _value );

			super();
		}

		public function get nodeName() : String {
			return "OVER_LEVEL";
		}

		override public function test():void {
			_onOver.runConnections();
		}

		private function onGet(...args):* {
			if( args.length == 2 ) {
				const value:Number = args[0] as Number;
				const last:Number = args[1] as Number;
				const curr:Number = _value.value as Number;

				if( !isNaN(value) && !isNaN(last) && !isNaN(curr) ) {
					if( last < curr && value >= curr ) {
						_onOver.runConnections();
					}
				}
			}
		}
	}
}
