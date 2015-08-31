package com.tbbgc.denom.node {
	import com.tbbgc.denom.flow.DenomFlow;
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.managers.FileManager;
	import com.tbbgc.denom.parameters.NodeParameter;

	import org.osflash.signals.Signal;
	/**
	 * @author simonrodriguez
	 */
	public class BaseNode {
		public static var FILE:FileManager;

		public static var ENTER_FRAME:Signal;

		protected var _flow:DenomFlow;

		private var _left:Vector.<NodeInput>;
		private var _right:Vector.<NodeInput>;
		private var _parameters:Vector.<NodeParameter>;

		public function BaseNode() {

		}

		public function set flow(flow:DenomFlow):void {
			_flow = flow;
		}

		protected function left( ...args ):void {
			const len:int = args.length;

			_left = new Vector.<NodeInput>( len, true );

			for( var i:int = 0; i < len; i++ ) {
				_left[i] = args[i] as NodeInput;
			}
		}

		protected function right( ...args ):void {
			const len:int = args.length;

			_right = new Vector.<NodeInput>( len, true );

			for( var i:int = 0; i < len; i++ ) {
				_right[i] = args[i] as NodeInput;
			}
		}

		protected function parameters( ...args ):void {
			const len:int = args.length;

			_parameters = new Vector.<NodeParameter>( len, true );

			for( var i:int = 0; i < len; i++ ) {
				_parameters[i] = args[i] as NodeParameter;
			}
		}

		public function setParameter(name : String, value : *) : void {
			if( _parameters != null && _parameters.length > 0 ) {
				if( _parameters.length == 1 || _parameters[0].name == name  || name == null ) {
					_parameters[0].value = value;
				} else {
					for each( var param:NodeParameter in _parameters ) {
						if( param.name == name ) {
							param.value = value;
							return;
						}
					}
				}
			}
		}

		public function getParameter(name : String) : * {
			if( _parameters != null && _parameters.length > 0 ) {
				if( _parameters.length == 1 || _parameters[0].name == name || name == null) {
					return _parameters[0].value;
				} else {
					for each( var param:NodeParameter in _parameters ) {
						if( param.name == name ) {
							return param.value;
						}
					}
				}
			}
			return null;
		}

		protected static function get enterFrame():Signal {
			return ENTER_FRAME;
		}

		public function reset():void {

		}

		public function test():void {

		}

		protected function logText( text:* ):void {
			trace( "LogNode:", text );
		}

		public function getLeft():Vector.<NodeInput> { return _left; }
		public function getRight():Vector.<NodeInput> { return _right; }
		public function getParameters():Vector.<NodeParameter> { return _parameters; }
	}
}
