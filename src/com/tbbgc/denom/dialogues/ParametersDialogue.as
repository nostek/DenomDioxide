package com.tbbgc.denom.dialogues {
	import fl.controls.List;
	import fl.events.ListEvent;

	import com.tbbgc.denom.interfaces.INode;
	import com.tbbgc.denom.models.DataModel;
	import com.tbbgc.denom.node.BaseNode;
	import com.tbbgc.denom.nodes.NoteNode;
	import com.tbbgc.denom.nodes.parameters.ParameterNode;
	import com.tbbgc.denom.parameters.NodeParameter;


	/**
	 * @author simonrodriguez
	 */
	public class ParametersDialogue extends BaseDialogue {
		private var _list:List;

		private var _selectedNode:INode;
		private var _selectedParameter:NodeParameter;

		public function ParametersDialogue() {
			const WIDTH:int = 300;
			const HEIGHT:int = 450;

			_list = new List();
			_list.allowMultipleSelection = false;
			_list.componentInspectorSetting = true;
			_list.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, onEditParameter);
			addChild( _list );

			super(WIDTH, HEIGHT, "Parameters", true, false, true);

			this.x = 20;
			this.y = 20;

			DataModel.SELECTED_NODE.onChanged.add( buildList );
			DataModel.EDIT_PARAMETER.add( onSetEditParameter );

			minimize();
		}

		override protected function resize( width:int, height:int ):void {
			_list.x = _list.y = 10;
			_list.width = width - 20;
			_list.height = height - BaseDialogue.EDGE - _list.y;

			super.resize(width, height);
		}

		private function buildList():void {
			_list.removeAll();

			var base:BaseNode = DataModel.SELECTED_NODE.value as BaseNode;

			if( base != null ) {
				var parameters:Vector.<NodeParameter> = base.getParameters();

				for each( var param:NodeParameter in parameters ) {
					_list.addItem({param:param, label:"["+param.name+"]: " + param.value});
				}
			}
		}

		private function onSetEditParameter( node:INode, parameter:NodeParameter ):void {
			onEditParameter(null, node, parameter);
		}

		private function onEditParameter(e:ListEvent, node:INode=null, parameter:NodeParameter=null):void {
			_selectedNode = node || DataModel.SELECTED_NODE.value as INode;

			if( _selectedNode != null ) {
				_selectedParameter = parameter || e.item["param"] as NodeParameter;

				var dlg:InputDialogue;
				var mdlg:InputMultiDialogue;

				if( _selectedNode is NoteNode ) {
					mdlg = new InputMultiDialogue("Edit parameter", _selectedParameter.name+":", _selectedParameter.value);
					mdlg.onOK.addOnce( onEditText );
					return;
				}

				if( _selectedNode is ParameterNode ) {
					dlg = new InputDialogue("Edit parameter", _selectedParameter.name+":", _selectedParameter.value);
					dlg.onOK.addOnce( onEditText );
					return;
				}

				if( _selectedParameter.value is Boolean ) {
					_selectedNode.setParameter(_selectedParameter.name, !(_selectedParameter.value as Boolean));
					buildList();
					return;
				}
				if( _selectedParameter.value is String ) {
					dlg = new InputDialogue("Edit parameter", _selectedParameter.name+":", _selectedParameter.value);
					dlg.onOK.addOnce( onEditText );
					return;
				}
				if( _selectedParameter.value is Number ) {
					dlg = new InputDialogue("Edit parameter", _selectedParameter.name+":", _selectedParameter.value);
					dlg.onOK.addOnce( onEditNumber );
					return;
				}
			}
		}

		private function onEditText( text:String ):void {
			_selectedNode.setParameter(_selectedParameter.name, text);

			buildList();
		}

		private function onEditNumber( text:String ):void {
			var n:Number = Number(text);

			if( isNaN(n) ) return;

			_selectedNode.setParameter(_selectedParameter.name, n);

			buildList();
		}
	}
}
