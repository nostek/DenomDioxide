package com.tbbgc.denom.common.input {
	import com.tbbgc.denom.common.interfaces.INode;
	/**
	 * @author Simon
	 */
	public class NodeInputPlugin extends NodeInput {
		private var _id:String;
		
		public function NodeInputPlugin( owner:INode, name:String, run:Function, id:String, single:Boolean=false ):void {
			super(owner, name, run, single);
			
			_id = id;
		}

		override public function run(...args):* {
			if (_run != null) {
				return _run( _id, args );
			}
		}
	}
}
