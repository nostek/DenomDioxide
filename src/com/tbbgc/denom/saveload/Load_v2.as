package com.tbbgc.denom.saveload {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.models.AvailableNodes;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.models.FlowModel;
	import com.tbbgc.denom.node.BaseNode;

	import flash.utils.getQualifiedClassName;
	/**
	 * @author Simon
	 */
	public class Load_v2 {
		private static var _strings:Array;
		
		public static function run(data:Object):Vector.<FlowModel> {
			var flows:Vector.<FlowModel> = new Vector.<FlowModel>();
			
			_strings = data[SLKeys.MAIN_STRINGS];

			var views:Array = data[SLKeys.MAIN_VIEWS];

			var flow:FlowModel;
			var obj:Object;
			var c:Class;
			var node:BaseNode;
			var a:Array;
			var len:int;
			var i:int;

			for each( var view:Object in views ) {
				flow = new FlowModel();
				flow.name = unpackString(view[SLKeys.FLOW_NAME]);

				flow.nodes = new Vector.<BaseNode>();
				
				a = view[SLKeys.FLOW_NODES];
				len = a.length;
				
				for (i = 0; i < len; i++) {
					obj = a[i];
					
					c = getClass( unpackString(obj[SLKeys.NODE_ID]) );
					
					node = new c();
					node.x = obj[SLKeys.NODE_X];
					node.y = obj[SLKeys.NODE_Y];
					flow.nodes.push(node);

					if (obj[SLKeys.NODE_PARAMS] != null) {
						loadParameters(node, obj[SLKeys.NODE_PARAMS]);
					}
				}
				
				for (i = 0; i < len; i++) {
					obj = a[i];

					node = flow.nodes[i];

					if (obj[SLKeys.NODE_INPUTS] != null) {
						loadInputs(node, obj[SLKeys.NODE_INPUTS], flow.nodes);
					}
				}

				flows.push( flow );
			}
			
			_strings = null;
			
			return flows;
		}
		
		private static function loadInputs( node:BaseNode, data:Object, nodes:Vector.<BaseNode> ):void {
			var name:String, cname:String;
			var input:NodeInput, cinput:NodeInput;;
			var child:BaseNode;
			var conn:Object;

			for each( var obj:Object in data ) {
				name = unpackString(obj[SLKeys.INPUT_NAME]);

				for each( input in node.getRight() ) {
					if( input.name == name ) {
						for each( conn in obj[SLKeys.INPUT_CONNECTIONS] ) {
							child = nodes[ conn[SLKeys.CONNECTION_INDEX] ];
							cname = unpackString(conn[SLKeys.CONNECTION_NAME]);

							for each( cinput in child.getLeft() ) {
								if( cinput.name == cname ) {
									input.connect( cinput );
									cinput.connect( input );
								}
							}
						}
					}
				}
			}
		}

		private static function loadParameters( node:BaseNode, data:Object ):void {
			for( var key:int in data ) {
				for each( var param:NodeParameter in node.getParameters() ) {
					if( param.name == unpackString(key) ) {
						param.value = unpackString(data[key]);
					}
				}
			}
		}

		private static function getClass( name:String ):Class {
			for each( var c:Class in AvailableNodes.AVAILABLE_NODES ) {
				if( nodeName(c) == name ) {
					return c;
				}
			}

			return null;
		}

		private static function nodeName( c:Class ):String {
			var className : String = getQualifiedClassName(c);
			return className.slice(className.lastIndexOf("::") + 2);
		}
		
		private static function unpackString( i:int ):* {
			return _strings[i];
		}
	}
}
