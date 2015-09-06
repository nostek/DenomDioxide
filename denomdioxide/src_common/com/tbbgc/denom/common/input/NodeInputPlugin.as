package com.tbbgc.denom.common.input {
	import com.tbbgc.denom.common.interfaces.INode;
	/**
	 * @author Simon
	 */
	public class NodeInputPlugin extends NodeInput {
		private var _id:String;
		private var _def:*;

		public function NodeInputPlugin( owner:INode, name:String, run:Function, id:String, def:*=null ):void {
			super(owner, name, run, single);

			_id = id;
			_def = def;
		}

		public function get id():String {
			return _id;
		}

		public function get def():* {
			return _def;
		}

		override public function run():* {
			if (_run != null) {
				return _run(_id);
			}
		}
	}
}
