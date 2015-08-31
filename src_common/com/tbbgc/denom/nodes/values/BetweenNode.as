package com.tbbgc.denom.nodes.values {
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class BetweenNode extends BaseNode implements INode {
		private var _get:NodeInput;

		private var _a:NodeInput;
		private var _b:NodeInput;
		private var _t:NodeInput;

		public function BetweenNode() {
			_get = new NodeInput(this, "GET", onGet);

			_a = new NodeInput(this, "A", null, true);
			_b = new NodeInput(this, "B", null, true);
			_t = new NodeInput(this, "T", null, true);

			left( _get );

			right( _a, _b, _t );

			super();
		}

		override public function test() : void {
			this.logText("Value: " + onGet());
		}

		public function get nodeName() : String {
			return "BETWEEN";
		}

		private function onGet(...args):* {
			var a:Number = _a.runFirst() as Number;
			var b:Number = _b.runFirst() as Number;
			var t:Number = _t.runFirst() as Number;

			var r:Number = a + (b - a) * t;

			return r;
		}
	}
}
