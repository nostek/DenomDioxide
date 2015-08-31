package com.tbbgc.denom.nodes.math {
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class InvertNode extends BaseNode implements INode {
		private var _get:NodeInput;

		private var _value:NodeInput;

		public function InvertNode() {
			_get = new NodeInput(this, "GET", onGet);

			_value = new NodeInput(this, "VALUE", null, true);

			left( _get );

			right( _value );

			super();
		}

		override public function test() : void {
			this.logText( "Value: " + onGet() );
		}

		public function get nodeName() : String {
			return "INVERT";
		}
		
		private function onGet(...args):* {
			if( _value.haveConnections ) {
				return (-(_value.runFirst() as Number)) as Number;
			}
			return 0;
		}
	}
}
