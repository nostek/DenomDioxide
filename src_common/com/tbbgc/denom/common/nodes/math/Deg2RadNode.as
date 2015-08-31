package com.tbbgc.denom.common.nodes.math {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.node.BaseNode;

	/**
	 * @author simonrodriguez
	 */
	public class Deg2RadNode extends BaseNode implements INode {
		private var _get:NodeInput;

		private var _value:NodeInput;

		public function Deg2RadNode() {
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
			return "DEG2RAD";
		}

		private function onGet(...args):* {
			if( _value.haveConnections ) {
				return deg2rad(_value.runFirst() as Number);
			}
			return 0;
		}

	    /** Converts an angle from degrees into radians. */
	    public function deg2rad(deg:Number):Number
	    {
			return deg / 180.0 * Math.PI;
	    }
	}
}
