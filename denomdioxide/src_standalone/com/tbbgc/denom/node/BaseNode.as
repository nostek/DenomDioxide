package com.tbbgc.denom.node {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.models.DenomShared;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	/**
	 * @author simonrodriguez
	 */
	public class BaseNode {
		private var _shared:DenomShared;

		private var _left:Vector.<NodeInput>;
		private var _right:Vector.<NodeInput>;
		private var _parameters:Vector.<NodeParameter>;

		public function BaseNode() {

		}

		////////////////////////////////

		public function set shared(shared:DenomShared):void {
			_shared = shared;
		}

		public function get shared():DenomShared {
			return _shared;
		}

		////////////////////////////////

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

		////////////////////////////////

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

		public function getParameterByName(name:String):NodeParameter {
			const len:int = _parameters.length;
			for (var i:int = 0; i < len; i++) {
				if (_parameters[i].name == name) {
					return _parameters[i];
				}
			}
			return null;
		}

		public function getLeftByName(name:String):NodeInput {
			const len:int = _left.length;
			for (var i:int = 0; i < len; i++) {
				if (_left[i].name == name) {
					return _left[i];
				}
			}
			return null;
		}

		public function getRightByName(name:String):NodeInput {
			const len:int = _right.length;
			for (var i:int = 0; i < len; i++) {
				if (_right[i].name == name) {
					return _right[i];
				}
			}
			return null;
		}

		public function getLeft():Vector.<NodeInput> { return _left; }
		public function getRight():Vector.<NodeInput> { return _right; }
		public function getParameters():Vector.<NodeParameter> { return _parameters; }

		////////////////////////////////

		public function reset():void {

		}

		public function test():void {

		}

		protected function logText( text:* ):void {
			trace( "LogNode:", text );
		}
	}
}
