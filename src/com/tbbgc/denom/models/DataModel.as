package com.tbbgc.denom.models {
	import com.tbbgc.denom.interfaces.INode;
	import com.tbbgc.denom.parameters.NodeParameter;
	import com.tbbgc.denom.utils.ValueSignal;

	import org.osflash.signals.Signal;

	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * @author simonrodriguez
	 */
	public class DataModel {
		public static var dialogues:Sprite;

		public static var shared:DenomShared;

		public static var ENTER_FRAME:Signal = new Signal();

		public static var DRAW:Signal = new Signal();

		public static var DRAW_LINE:Signal = new Signal(Point, Point);

		public static var DRAW_LINES:Signal = new Signal();

		public static var SELECTED_NODE:ValueSignal = new ValueSignal(null);

		public static var RUN_SAVE:Signal = new Signal( Function );

		public static var DELETE_ALL:Signal = new Signal();

		public static var EDIT_PARAMETER:Signal = new Signal( INode, NodeParameter );

		public static var ON_FIRST_RUN:Signal = new Signal();
	}
}
