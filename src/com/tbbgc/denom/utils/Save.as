package com.tbbgc.denom.utils {
	import com.tbbgc.denom.input.NodeInput;
	import com.tbbgc.denom.models.DataModel;
	import com.tbbgc.denom.models.FlowModel;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.parameters.NodeParameter;

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

			DataModel.RUN_SAVE.dispatch( add );

			save( f );

			_flows = null;
		}

		private static function add( node:BaseNode ):void {
			for each( var flow:FlowModel in _flows ) {
				if( flow.name == node.parent.name ) {
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

			var nodes:Array;

			for each( var flow:FlowModel in _flows ) {
				nodes = [];

				if( flow.nodes.length > 0 ) {
					for each( var node:BaseNode in flow.nodes ) {
						nodes.push( {
							index: getIndex(flow, node),

							id: nodeName(node),

							x: node.x,
							y: node.y,

							inputs: saveInputs(flow, node),

							params: saveParameters(node)
						} );
					}

					views.push( { name: flow.name, nodes:nodes } );
				}
			}

			var json:String = JSON.stringify( {
				version: 1,
				views: views,
				random: getRandomCharacters()
			} );

			var stream:FileStream = new FileStream();
			stream.open( f, FileMode.WRITE);
			stream.writeUTFBytes(json);
			stream.close();
		}

		private static function saveInputs( flow:FlowModel, node:BaseNode ):Array {
			var a:Array = [];

			var c:Array;

			for each( var input:NodeInput in node.getRight() ) {
				if( input.connections.length > 0 ) {
					c = [];

					for each( var conn:NodeInput in input.connections ) {
						c.push( {
							index: getIndex( flow, conn.owner as BaseNode ),
							name: conn.name
						} );
					}

					a.push( {
						name: input.name,
						connections: c
					} );
				}
			}

			return a;
		}

		private static function saveParameters( node:BaseNode ):Object {
			var o:Object = {};

			for each( var param:NodeParameter in node.getParameters() ) {
				o[ param.name ] = param.value;
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
	}
}
