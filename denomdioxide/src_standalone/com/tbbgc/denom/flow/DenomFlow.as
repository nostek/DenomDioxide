package com.tbbgc.denom.flow {
	import com.tbbgc.denom.common.interfaces.INodeEvent;
	import com.tbbgc.denom.common.models.DenomShared;
	import com.tbbgc.denom.node.BaseNode;

	import org.osflash.signals.OnceSignal;
	import org.osflash.signals.Signal;

	import flash.utils.Dictionary;
	/**
	 * @author simonrodriguez
	 */
	public class DenomFlow {
		private var _shared:DenomShared;

		private var _nodes:Vector.<BaseNode>;
		private var _hashEvent:Dictionary;

		public function DenomFlow( shared:DenomShared, nodes:Vector.<BaseNode> ) {
			_shared = shared;

			setup( nodes );
		}

		public function dispose():DenomFlow {
			const len:int = _nodes.length;
			for( var i:int = 0; i < len; i++ ) {
				_nodes[i].reset();
			}

			_nodes = null;
			_hashEvent = null;

			_shared.dispose();
			_shared = null;

			return null;
		}

		private function setup( nodes:Vector.<BaseNode> ):void {
			_nodes = nodes;

			_hashEvent = new Dictionary();

			const len:int = _nodes.length;
			for (var i:int = 0; i < len; i++) {
				if (_nodes[i] is INodeEvent) {
					_hashEvent[ (_nodes[i] as INodeEvent).eventName ] = _nodes[i];
				}
			}
		}

		public function get onLoaded():OnceSignal { return _shared.onLoaded; }

		public function get isDisposed():Boolean { return (_nodes==null); }
		public function get isLoaded():Boolean { return _shared.isLoaded; }

		//Listen with: onFlowEvent( id:String, values:Array ):void
		public function get onPostEvent():Signal { return _shared.onPostEvent; }

		public function haveEvent( name:String ):Boolean {
			var node:INodeEvent = _hashEvent[ name ] as INodeEvent;
			return (node != null);
		}

		public function start( name:String ):void {
			var node:INodeEvent = _hashEvent[ name ] as INodeEvent;
			if( node != null ) {
				node.start();
			}
		}

		public function stop( name:String ):void {
			var node:INodeEvent = _hashEvent[ name ] as INodeEvent;
			if( node != null ) {
				node.stop();
			}
		}

		public function isStarted( name:String ):Boolean {
			var node:INodeEvent = _hashEvent[ name ] as INodeEvent;
			if( node != null ) {
				return node.isStarted;
			}
			return false;
		}

		public function setGlobalParameter( id:String, value:* ):void {
			_shared.setParameter(id, true, value);
		}

		public function setParameter( id:String, value:* ):void {
			_shared.setParameter(id, false, value);
		}
	}
}
