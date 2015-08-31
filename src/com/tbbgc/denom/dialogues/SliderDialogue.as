package com.tbbgc.denom.dialogues {
	import com.tbbgc.denom.interfaces.INodeParameter;
	import com.tbbgc.denom.nodes.parameters.ParameterNode;
	import fl.controls.Button;
	import fl.controls.ScrollBar;
	import fl.controls.ScrollBarDirection;
	import fl.events.ComponentEvent;
	import fl.events.ScrollEvent;


	/**
	 * @author simonrodriguez
	 */
	public class SliderDialogue extends BaseDialogue {
		private var _node:ParameterNode;

		private var _slider:ScrollBar;

		private var _close:Button;

		public function SliderDialogue( node:ParameterNode, x:Number, y:Number ) {
			const WIDTH:int = 300;
			const HEIGHT:int = 70;

			_node = node;

			_slider = new ScrollBar();
			_slider.addEventListener(ScrollEvent.SCROLL, onScroll);
			_slider.direction = ScrollBarDirection.HORIZONTAL;
			_slider.minScrollPosition = 0;
			_slider.maxScrollPosition = 10000;
			_slider.scrollPosition = 0;
			addChild(_slider);

			_close = new Button();
			_close.label = "Close";
			_close.height = BaseDialogue.EDGE;
			_close.addEventListener(ComponentEvent.BUTTON_DOWN, onClose);
			addChild(_close);

			super(WIDTH, HEIGHT, "Slider [" + (node as INodeParameter).parameterName + "]", true, false, true);

			this.x = x;
			this.y = y;

			_slider.scrollPosition = 10000 * node.getParameter(null);
		}

		override protected function resize( width:int, height:int ):void {
			_slider.x = _slider.y = 10;
			_slider.width = width - 20;

			_close.x = 10;
			_close.y = height - _close.height;

			super.resize(width, height);
		}

		private function onClose(e:ComponentEvent):void {
			close();
		}

		private function onScroll(e:ScrollEvent):void {
			_node.setParameter(null, _slider.scrollPosition / 10000);
		}
	}
}
