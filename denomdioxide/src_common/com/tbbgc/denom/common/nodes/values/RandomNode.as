package com.tbbgc.denom.common.nodes.values {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class RandomNode extends BaseNode implements INode {
		private var _get:NodeInput;

		private var _from:NodeParameter;
		private var _to:NodeParameter;
		private var _round:NodeParameter;

		public function RandomNode() {
			_get = new NodeInput(this, "GET", onGet);

			_from = new NodeParameter("FROM", 0);
			_to = new NodeParameter("TO", 1);
			_round = new NodeParameter("ROUND", false);

			left( _get );

			parameters( _from, _to, _round );

			super();
		}

		override public function test() : void {
			this.logText("Random: " + onGet() as Number );
		}

		public function get nodeName() : String {
			return "RANDOM";
		}

		private function onGet(...args):* {
			const a:Number = _from.value as Number;
			const b:Number = _to.value as Number;
			const val:Number = a + (b - a) * Math.random();
			return (_round.value as Boolean) ? Math.round(val) : val;
		}
	}
}
