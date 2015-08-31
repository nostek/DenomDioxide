package com.tbbgc.denom.models {
	import com.tbbgc.denom.nodes.GetSetNode;
	import com.tbbgc.denom.nodes.NoteNode;
	import com.tbbgc.denom.nodes.ProxyNode;
	import com.tbbgc.denom.nodes.conditional.IfNode;
	import com.tbbgc.denom.nodes.conditional.IsBetweenNode;
	import com.tbbgc.denom.nodes.conditional.IsOverLevelNode;
	import com.tbbgc.denom.nodes.conditional.OverLevelValueNode;
	import com.tbbgc.denom.nodes.debug.LogNode;
	import com.tbbgc.denom.nodes.events.EventNode;
	import com.tbbgc.denom.nodes.events.PostEventNode;
	import com.tbbgc.denom.nodes.math.AddNode;
	import com.tbbgc.denom.nodes.math.Deg2RadNode;
	import com.tbbgc.denom.nodes.math.InvertNode;
	import com.tbbgc.denom.nodes.math.MultiplyNode;
	import com.tbbgc.denom.nodes.math.RoundNode;
	import com.tbbgc.denom.nodes.math.SubtractNode;
	import com.tbbgc.denom.nodes.parameters.AsPointNode;
	import com.tbbgc.denom.nodes.parameters.ParameterNode;
	import com.tbbgc.denom.nodes.selectors.SelectRandomNode;
	import com.tbbgc.denom.nodes.selectors.SelectRandomWeightNode;
	import com.tbbgc.denom.nodes.selectors.SelectSequenceNode;
	import com.tbbgc.denom.nodes.selectors.SelectSwitchNode;
	import com.tbbgc.denom.nodes.selectors.SelectSwitchValueNode;
	import com.tbbgc.denom.nodes.sound.AdvancedSoundNode;
	import com.tbbgc.denom.nodes.sound.MusicNode;
	import com.tbbgc.denom.nodes.sound.PlaySoundNode;
	import com.tbbgc.denom.nodes.sound.SoundNode;
	import com.tbbgc.denom.nodes.time.OverTimeNode;
	import com.tbbgc.denom.nodes.time.WaitNode;
	import com.tbbgc.denom.nodes.values.BetweenNode;
	import com.tbbgc.denom.nodes.values.BooleanNode;
	import com.tbbgc.denom.nodes.values.GraphNode;
	import com.tbbgc.denom.nodes.values.NumberNode;
	import com.tbbgc.denom.nodes.values.RandomNode;
	import com.tbbgc.denom.nodes.values.TextNode;
	/**
	 * @author simonrodriguez
	 */
	public class AvailableNodes {
		public static const AVAILABLE_NODES:Vector.<Class> = Vector.<Class>([
			EventNode,
			PostEventNode,
			LogNode,
			WaitNode,
			TextNode,
			NumberNode,
			BooleanNode,
			RandomNode,
			BetweenNode,
			ProxyNode,
			ParameterNode,
			SelectRandomNode,
			SelectRandomWeightNode,
			PlaySoundNode,
			SoundNode,
			AdvancedSoundNode,
			MusicNode,
			GraphNode,
			AddNode,
			SubtractNode,
			MultiplyNode,
			InvertNode,
			OverTimeNode,
			IfNode,
			GetSetNode,
			SelectSequenceNode,
			SelectSwitchNode,
			SelectSwitchValueNode,
			AsPointNode,
			IsBetweenNode,
			RoundNode,
			IsOverLevelNode,
			OverLevelValueNode,
			Deg2RadNode,
			NoteNode
		]);
	}
}
