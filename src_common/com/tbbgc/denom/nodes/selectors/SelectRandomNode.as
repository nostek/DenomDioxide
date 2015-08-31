package com.tbbgc.denom.nodes.selectors {
	import com.tbbgc.denom.parameters.NodeParameter;
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.interfaces.INode;

	/**
	 * @author simonrodriguez
	 */
	public class SelectRandomNode extends BaseNode implements INode {
		private var _get:NodeInput;

		private var _nodes:NodeInput;

		private var _allowLast:NodeParameter;

		private var _last:int;

		public function SelectRandomNode() {
			_get = new NodeInput(this, "GET", onGet);

			_nodes = new NodeInput(this, "NODES", null);

			_allowLast = new NodeParameter("ALLOW LAST", true);

			left( _get );

			right( _nodes );

			parameters( _allowLast );

			_last = -1;

			super();
		}

		public function get nodeName() : String {
			return "SELECT RANDOM";
		}

		private function onGet(...args):* {
			const len:int = _nodes.connections.length;

			if( len > 0 ) {

				var node:SelectRandomWeightNode;

				var maxValue:Number = 0;

				for( var i:int = 0; i < len; i++ ) {
					node = _nodes.connections[i].owner as SelectRandomWeightNode;
					if( node != null ) {
						maxValue += node.getParameter(null) as Number;
					}
				}

				const allowLast:Boolean = _allowLast.value as Boolean;

				while( true ) {
					var randomValue:Number = maxValue * Math.random();

					for( i = 0; i < len; i++ ) {
						node = _nodes.connections[i].owner as SelectRandomWeightNode;
						if( node != null ) {
							randomValue -= node.getParameter(null) as Number;
							if( randomValue <= 0 ) {
								if( !allowLast && _last == i ) {
									break;
								}

								_last = i;
								return _nodes.connections[i].run();
							}
						}
					}
				}
			}

			return null;
		}
	}
}
