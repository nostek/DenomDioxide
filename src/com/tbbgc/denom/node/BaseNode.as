package com.tbbgc.denom.node {
	import com.tbbgc.denom.dialogues.PopupDialogue;
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.models.DataModel;
	import com.tbbgc.denom.models.DenomShared;
	import com.tbbgc.denom.parameters.NodeParameter;

	import flash.events.ContextMenuEvent;

	/**
	 * @author simonrodriguez
	 */
	public class BaseNode extends BaseGUINode {
		private var _left:Vector.<NodeInput>;
		private var _right:Vector.<NodeInput>;
		private var _parameters:Vector.<NodeParameter>;

		public function BaseNode() {
			DataModel.RUN_SAVE.add( onRunSave );

			super();
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
					draw();
				} else {
					for each( var param:NodeParameter in _parameters ) {
						if( param.name == name ) {
							param.value = value;
							draw();
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

		public function reset():void {

		}

		protected function logText( text:* ):void {
			new PopupDialogue("DEBUG", text);
		}

		protected function get shared():DenomShared {
			return DataModel.shared;
		}

		public function getLeft():Vector.<NodeInput> { return _left; }
		public function getRight():Vector.<NodeInput> { return _right; }
		public function getParameters():Vector.<NodeParameter> { return _parameters; }

		/////////////////////////////////////////////

		public function test():void {

		}

		override protected function onDelete(e:ContextMenuEvent=null):void {
			var input:NodeInput;
			var child:NodeInput;

			for each( input in _left ) {
				for each( child in input.connections ) {
					child.disconnect(input);
				}
			}
			for each( input in _right ) {
				for each( child in input.connections ) {
					child.disconnect(input);
				}
			}

			DataModel.RUN_SAVE.remove( onRunSave );

			super.onDelete(e);

			reset();
		}

		private function onRunSave( func:Function ):void {
			if( this.parent == null ) return;

			func( this );
		}
	}
}
