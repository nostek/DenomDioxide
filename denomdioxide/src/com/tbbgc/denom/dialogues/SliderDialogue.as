package com.tbbgc.denom.dialogues {
	import fl.controls.ScrollBar;
	import fl.controls.ScrollBarDirection;
	import fl.events.ScrollEvent;

	import com.tbbgc.denom.common.interfaces.INodeParameter;
	import com.tbbgc.denom.common.nodes.parameters.ParameterNode;


	/**
	 * @author simonrodriguez
	 */
	public class SliderDialogue extends BaseDialogue {
		private var _node:ParameterNode;

		private var _slider:ScrollBar;

		public function SliderDialogue( node:ParameterNode, x:Number, y:Number ) {
			const WIDTH:int = 300;
			const HEIGHT:int = 70;

			super("Slider [" + (node as INodeParameter).parameterName + "]", true, false, true, true);

			_node = node;

			_slider = new ScrollBar();
			_slider.addEventListener(ScrollEvent.SCROLL, onScroll);
			_slider.direction = ScrollBarDirection.HORIZONTAL;
			_slider.minScrollPosition = 0;
			_slider.maxScrollPosition = 10000;
			_slider.scrollPosition = 0;
			container.addChild(_slider);

			init(WIDTH, HEIGHT);

			this.x = x;
			this.y = y;

			_slider.scrollPosition = 10000 * node.getParameter(null);
		}

		override protected function onResize( width:int, height:int ):void {
			_slider.width = width;
		}

		private function onScroll(e:ScrollEvent):void {
			_node.setParameter(null, _slider.scrollPosition / 10000);
		}
	}
}
