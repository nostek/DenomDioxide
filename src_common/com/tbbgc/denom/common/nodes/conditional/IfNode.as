package com.tbbgc.denom.common.nodes.conditional {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class IfNode extends BaseNode implements INode {
		private var _run:NodeInput;

		private var _a:NodeInput;
		private var _b:NodeInput;

		private var _onLess:NodeInput;
		private var _onLessEqual:NodeInput;
		private var _onEqual:NodeInput;
		private var _onNotEqual:NodeInput;
		private var _onGreaterEqual:NodeInput;
		private var _onGreater:NodeInput;

		public function IfNode() {
			_run = new NodeInput(this, "RUN", onRun);

			_a = new NodeInput(this, "A", null, true);
			_b = new NodeInput(this, "B", null, true);

			_onLess 			= new NodeInput(this, "ON_LESS", null);
			_onLessEqual 		= new NodeInput(this, "ON_LESS_EQUAL", null);
			_onEqual 			= new NodeInput(this, "ON_EQUAL", null);
			_onNotEqual 		= new NodeInput(this, "ON_NOT_EQUAL", null);
			_onGreaterEqual 	= new NodeInput(this, "ON_GREATER_EQUAL", null);
			_onGreater 			= new NodeInput(this, "ON_GREATER", null);

			left( _run );

			right( _a, _b, _onLess, _onLessEqual, _onEqual, _onNotEqual, _onGreaterEqual, _onGreater );

			super();
		}

		override public function test() : void {
			onRun();
		}

		public function get nodeName() : String {
			return "IF";
		}

		private function onRun():void {
			if( _a.haveConnections && _b.haveConnections ) {
				var a:* = _a.runFirst();
				var b:* = _b.runFirst();

				if( _onLess.haveConnections && a < b ) {
					_onLess.runConnections();
				}
				if( _onLessEqual.haveConnections && a <= b ) {
					_onLessEqual.runConnections();
				}
				if( _onEqual.haveConnections && a == b ) {
					_onEqual.runConnections();
				}
				if( _onNotEqual.haveConnections && a != b ) {
					_onNotEqual.runConnections();
				}
				if( _onGreaterEqual.haveConnections && a >= b ) {
					_onGreaterEqual.runConnections();
				}
				if( _onGreater.haveConnections && a > b ) {
					_onGreater.runConnections();
				}
			}
		}
	}
}
