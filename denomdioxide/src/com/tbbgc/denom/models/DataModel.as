package com.tbbgc.denom.models {
	import com.tbbgc.denom.common.interfaces.INode;
	import com.tbbgc.denom.common.models.DenomShared;
	import com.tbbgc.denom.common.parameters.NodeParameter;
	import com.tbbgc.denom.utils.ValueSignal;

	import org.osflash.signals.Signal;

	import flash.geom.Point;
	/**
	 * @author simonrodriguez
	 */
	public class DataModel {
		public static var shared:DenomShared;

		public static var ENTER_FRAME:Signal = new Signal();

		public static var DRAW:Signal = new Signal();

		public static var DRAW_LINE:Signal = new Signal(Point, Point);

		public static var DRAW_LINES:Signal = new Signal();

		public static var SELECTED_NODE:ValueSignal = new ValueSignal(null);

		public static var RUN_SAVE:Signal = new Signal( Function );

		public static var DELETE_ALL:Signal = new Signal();

		public static var EDIT_PARAMETER:Signal = new Signal( INode, NodeParameter );

		public static var ON_SOUNDS_SET:Signal = new Signal();
		
		public static var ON_PLUGINS_SET:Signal = new Signal();
	}
}
