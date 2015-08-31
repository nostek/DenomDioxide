package com.tbbgc.denom.nodes.values {
	import com.tbbgc.denom.parameters.NodeParameter;
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.interfaces.INode;

	/**
	 * @author simonrodriguez
	 */
	public class GraphNode extends BaseNode implements INode {
		private var _get:NodeInput;

		private var _t:NodeInput;

		private var _points:NodeParameter;

		private var _from:NodeParameter;
		private var _to:NodeParameter;

		////

		private var _data:Vector.<GraphPoint>;

		public function GraphNode() {
			_get = new NodeInput(this, "GET", onGet);

			_t = new NodeInput(this, "T", null, true);

			_points = new NodeParameter("POINTS", [[0,0], [1,1]], onPointsChanged);

			_from = new NodeParameter("FROM", 0);
			_to = new NodeParameter("TO", 1);

			left( _get );

			right( _t );

			parameters( _points, _from, _to );

			super();

			_data = Vector.<GraphPoint>([ new GraphPoint(0, 0), new GraphPoint(1, 1) ]);
		}

		public function get nodeName() : String {
			return "GRAPH";
		}

		private function onGet(...args):* {
			var t:Number = (_t.haveConnections ? _t.runFirst() as Number : 0.5);

			const a:Number = _from.value as Number;
			const b:Number = _to.value as Number;

			const len:int = _data.length-1;

			var val:Number;

			if( t == 0 ) {
				val = a + (b - a) * _data[0].x;
				return val;
			}

			if( t == 1 ) {
				val = a + (b - a) * _data[len].x;
				return val;
			}

			for( var i:int = len; i >= 0; i-- ) {
				if( t >= _data[i].t ) {
					val =  a + (b - a) * (_data[i].x + (_data[i+1].x - _data[i].x) * ( (t-_data[i].t) / (_data[i+1].t-_data[i].t) ));
					return val;
				}
			}

			return 0;
		}

		private function onPointsChanged():void {
			var a:Array = _points.value as Array;

			_data = new Vector.<GraphPoint>( a.length, true );

			const len:int = a.length;
			for( var i:int = 0; i < len; i++ ) {
				_data[i] = new GraphPoint(a[i][0], a[i][1]);
			}
		}
	}
}

internal class GraphPoint {
	public var t:Number;
	public var x:Number;

	public function GraphPoint( t:Number, x:Number ) {
		this.t = t;
		this.x = x;
	}
}
