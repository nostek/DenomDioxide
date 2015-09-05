package com.tbbgc.denom.flow {
	import com.tbbgc.denom.interfaces.INode;
	import com.tbbgc.denom.interfaces.INodeEvent;
	import com.tbbgc.denom.interfaces.INodeParameter;
	import com.tbbgc.denom.ns.DenomPrivate;

	import org.osflash.signals.OnceSignal;
	import org.osflash.signals.Signal;

	import flash.utils.Dictionary;
	/**
	 * @author simonrodriguez
	 */
	public class DenomFlow {
		private var _name:String;

		private var _loading:int;

		private var _onLoaded:OnceSignal;
		private var _onEvent:Signal;

		private var _nodes:Vector.<INode>;
		private var _hashEvent:Dictionary;
		private var _hashParameters:Dictionary;

		public function DenomFlow( name:String ) {
			_name = name;

			_loading = 0;

			_onLoaded = new Signal();
			_onEvent = new Signal( String, Array );
		}

		public function dispose():DenomFlow {
			const len:int = _nodes.length;
			for( var i:int = 0; i < len; i++ ) {
				_nodes[i].reset();
			}

			_nodes = null;
			_hashEvent = null;
			_hashParameters = null;

			_onEvent.removeAll();
			_onLoaded.removeAll();

			return null;
		}

		DenomPrivate function setup( nodes:Vector.<INode> ):void {
			if( _nodes != null ) {
				var old:Vector.<INode> = _nodes;
				_nodes = nodes;

				generateDictionarys();

				var param:INodeParameter;
				var event:INodeEvent;

				const len:int = old.length;
				for( var i:int = 0; i < len; i++ ) {
					if( old[i] is INodeEvent ) {
						event = _hashEvent[ (old[i] as INodeEvent).eventName ];
						if( event != null ) {
							event.isStarted = (old[i] as INodeEvent).isStarted;
						}
					}

					if( old[i] is INodeParameter ) {
						param = _hashParameters[ (old[i] as INodeParameter).parameterName ];
						if( param != null ) {
							param.parameter = (old[i] as INodeParameter).parameter;
						}
					}

					old[i].reset();
				}
			} else {
				_nodes = nodes;

				generateDictionarys();
			}
		}

		private function generateDictionarys():void {
			_hashEvent = new Dictionary();
			_hashParameters = new Dictionary();

			const len:int = _nodes.length;
			for( var i:int = 0; i < len; i++ ) {
				if( _nodes[i] is INodeEvent ) {
					_hashEvent[ (_nodes[i] as INodeEvent).eventName ] = _nodes[i];
				}
				if( _nodes[i] is INodeParameter ) {
					_hashParameters[ (_nodes[i] as INodeParameter).parameterName ] = _nodes[i];
				}
			}
		}

		public function get onLoaded():OnceSignal { return _onLoaded; }

		public function get name():String { return _name; }

		public function get isDisposed():Boolean { return (_nodes==null); }
		public function get isLoaded():Boolean { return (_loading==0); }

		//Listen with: onFlowEvent( id:String, values:Array ):void
		public function get onEvent():Signal { return _onEvent; }

		public function haveEvent( name:String ):Boolean {
			var node:INodeEvent = _hashEvent[ name ] as INodeEvent;
			return (node != null);
		}

		public function haveParameter( name:String ):Boolean {
			var node:INodeParameter = _hashParameters[ name ] as INodeParameter;
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

		public function setParameter( name:String, value:* ):void {
			var param:INodeParameter = _hashParameters[ name ] as INodeParameter;
			if( param != null ) {
				param.parameter = value;
			}
		}

		/////////////////////////

		DenomPrivate function incLoad() : void {
			_loading++;
		}

		DenomPrivate function decLoad():void {
			_loading--;

			if( _loading == 0 ) {
				_onLoaded.dispatch();
			}
		}
	}
}
