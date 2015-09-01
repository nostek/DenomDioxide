package com.tbbgc.denom.saveload {
	import com.tbbgc.denom.common.input.NodeInput;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.models.DataModel;
	import com.tbbgc.denom.models.FlowModel;
	import com.tbbgc.denom.node.BaseNode;

	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.getQualifiedClassName;
	/**
	 * @author simonrodriguez
	 */
	public class Save {
		private static var _flows:Vector.<FlowModel>;
		private static var _strings:Array;

		public static function run( lastFile:File ):void {
			if( lastFile != null ) {
				onSelect(null, lastFile );
			} else {
				var f:File = new File();
				f.addEventListener(Event.SELECT, onSelect);
				f.browseForSave("Save");
			}
		}

		private static function onSelect( e:Event, last:File=null ):void {
			var f:File = (last!=null) ? last : e.target as File;

			_flows = new Vector.<FlowModel>();
			_strings = [];

			DataModel.RUN_SAVE.dispatch( add );

			save( f );

			_flows = null;
			_strings = null;
		}

		private static function add( node:BaseNode ):void {
			var flow:FlowModel;
			
			const len:int = _flows.length;
			for (var i:int = 0; i < len; i++) {
				flow = _flows[i];
				if (flow.name == node.parent.name) {
					flow.nodes.splice(0, 0, node);
					return;
				}
			}

			flow = new FlowModel();
			flow.name = node.parent.name;
			flow.nodes = new Vector.<BaseNode>();
			flow.nodes.push( node );

			_flows.splice(0, 0, flow);
		}

		private static function save( f:File ):void {
			var views:Array = [];

			var flow:FlowModel;
			var node:BaseNode;
			var nodes:Array;
			var blen:int;
			var o:Object;
			var inputs:Array;
			var params:Object;
			
			const len:int = _flows.length;
			for (var i:int = 0; i < len; i++) {
				flow = _flows[i];
				
				nodes = [];

				blen = flow.nodes.length;
				
				if( blen > 0 ) {
					for (var b:int = 0; b < blen; b++) {
						node = flow.nodes[b];
						
						o = {};
						o[SLKeys.NODE_ID] = packString(nodeName(node));
						o[SLKeys.NODE_X] = node.x;
						o[SLKeys.NODE_Y] = node.y; 
						
						inputs = saveInputs(flow, node);
						if (inputs != null) {
							o[SLKeys.NODE_INPUTS] = inputs;
						}
						
						params = saveParameters(node);
						if (params != null) {
							o[SLKeys.NODE_PARAMS] = params;
						}
						
						nodes.push( o );
					}

					o = {};
					o[SLKeys.FLOW_NAME] = packString(flow.name);
					o[SLKeys.FLOW_NODES] = nodes; 
					views.push(o);
				}
			}

			o = {};
			o[SLKeys.MAIN_VERSION] 	= 2;
			o[SLKeys.MAIN_VIEWS] 	= views;
			o[SLKeys.MAIN_STRINGS] 	= _strings;
			o[SLKeys.MAIN_RANDOM]	= getRandomCharacters();

			var stream:FileStream = new FileStream();
			stream.open( f, FileMode.WRITE);
			stream.writeUTFBytes(JSON.stringify(o));
			stream.close();
		}

		private static function saveInputs( flow:FlowModel, node:BaseNode ):Array {
			var a:Array = [];

			var c:Array;
			var o:Object;

			for each( var input:NodeInput in node.getRight() ) {
				if( input.connections.length > 0 ) {
					c = [];

					for each( var conn:NodeInput in input.connections ) {
						o = {};
						o[SLKeys.CONNECTION_NAME] = packString(conn.name);
						o[SLKeys.CONNECTION_INDEX] = getIndex( flow, conn.owner as BaseNode );  
						c.push(o);
					}

					o = {};
					o[SLKeys.INPUT_NAME] = packString(input.name);
					o[SLKeys.INPUT_CONNECTIONS] = c; 
					a.push(o);
				}
			}
			
			if (a.length == 0) {
				return null;
			}

			return a;
		}

		private static function saveParameters( node:BaseNode ):Object {
			var o:Object = {};
			var c:Boolean = false;

			for each( var param:NodeParameter in node.getParameters() ) {
				o[ packString(param.name) ] = packString(param.value);
				c = true;
			}
			
			if (!c) {
				return null;
			}

			return o;
		}

		private static function nodeName( node:BaseNode ):String {
			var className : String = getQualifiedClassName(node);
			return className.slice(className.lastIndexOf("::") + 2);
		}

		private static function getIndex( flow:FlowModel, node:BaseNode ):int {
			const len:int = flow.nodes.length;

			for( var i:int = 0; i < len; i++ ) {
				if( flow.nodes[i] == node ) {
					return i;
				}
			}

			return -1;
		}

		private static function getRandomCharacters():String {
			var r:String ="";
			for( var i:int = 0; i < 32; i++ ) {
				r += String.fromCharCode( int(65 + ((90-65)*Math.random())) );
			}
			return r;
		}
		
		private static function packString( s:* ):int {
			const len:int = _strings.length;
			for (var i:int = 0; i < len; i++) {
				if( _strings[i] == s) {
					return i;
				}
			}
			
			_strings.push(s);
			
			return _strings.length-1;
		}
	}
}
