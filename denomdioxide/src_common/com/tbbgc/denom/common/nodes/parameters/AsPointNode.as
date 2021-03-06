package com.tbbgc.denom.common.nodes.parameters {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;

	import flash.geom.Point;

	/**
	 * @author simonrodriguez
	 */
	public class AsPointNode extends BaseNode implements INode {
		private var _x:NodeInput;
		private var _y:NodeInput;

		private var _target:NodeInput;

		public function AsPointNode() {
			_x = new NodeInput(this, "X", onX);
			_y = new NodeInput(this, "Y", onY);

			_target = new NodeInput(this, "TARGET", null, true);

			left( _x, _y );

			right( _target );

			super();
		}

		public function get nodeName() : String {
			return "AS POINT";
		}

		private function onX():* {
			if( _target.haveConnections ) {
				return (_target.runFirst() as Point).x;
			}
			return 0;
		}

		private function onY():* {
			if( _target.haveConnections ) {
				return (_target.runFirst() as Point).y;
			}
			return 0;
		}
	}
}
