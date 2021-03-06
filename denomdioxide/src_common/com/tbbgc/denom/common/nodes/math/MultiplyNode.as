package com.tbbgc.denom.common.nodes.math {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class MultiplyNode extends BaseNode implements INode {
		private var _get:NodeInput;

		private var _a:NodeInput;
		private var _b:NodeInput;

		public function MultiplyNode() {
			_get = new NodeInput(this, "GET", onGet);

			_a = new NodeInput(this, "A", null, true);
			_b = new NodeInput(this, "B", null, true);

			left( _get );

			right( _a, _b );

			super();
		}

		override public function test() : void {
			this.logText( "Value: " + onGet() );
		}

		public function get nodeName() : String {
			return "MULTIPLY";
		}

		private function onGet():* {
			if( _a.haveConnections && _b.haveConnections ) {
				return (_a.runFirst() as Number) * (_b.runFirst() as Number);
			}
			return 0;
		}
	}
}
