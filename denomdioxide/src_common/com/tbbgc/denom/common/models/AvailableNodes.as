package com.tbbgc.denom.common.models {
	import com.tbbgc.denom.common.nodes.NoteNode;
	import com.tbbgc.denom.common.nodes.PluginNode;
	import com.tbbgc.denom.common.nodes.ProxyNode;
	import com.tbbgc.denom.common.nodes.conditional.IfNode;
	import com.tbbgc.denom.common.nodes.conditional.IsBetweenNode;
	import com.tbbgc.denom.common.nodes.debug.LogNode;
	import com.tbbgc.denom.common.nodes.events.EventNode;
	import com.tbbgc.denom.common.nodes.events.PostEventNode;
	import com.tbbgc.denom.common.nodes.math.AddNode;
	import com.tbbgc.denom.common.nodes.math.Deg2RadNode;
	import com.tbbgc.denom.common.nodes.math.InvertNode;
	import com.tbbgc.denom.common.nodes.math.MultiplyNode;
	import com.tbbgc.denom.common.nodes.math.RoundNode;
	import com.tbbgc.denom.common.nodes.math.SubtractNode;
	import com.tbbgc.denom.common.nodes.parameters.AsPointNode;
	import com.tbbgc.denom.common.nodes.parameters.ParameterNode;
	import com.tbbgc.denom.common.nodes.selectors.SelectRandomNode;
	import com.tbbgc.denom.common.nodes.selectors.SelectRandomWeightNode;
	import com.tbbgc.denom.common.nodes.selectors.SelectSequenceNode;
	import com.tbbgc.denom.common.nodes.selectors.SelectSwitchNode;
	import com.tbbgc.denom.common.nodes.selectors.SelectSwitchValueNode;
	import com.tbbgc.denom.common.nodes.sound.AdvancedSoundNode;
	import com.tbbgc.denom.common.nodes.sound.MusicNode;
	import com.tbbgc.denom.common.nodes.sound.PlaySoundNode;
	import com.tbbgc.denom.common.nodes.sound.SoundNode;
	import com.tbbgc.denom.common.nodes.time.OverTimeNode;
	import com.tbbgc.denom.common.nodes.time.WaitNode;
	import com.tbbgc.denom.common.nodes.values.BetweenNode;
	import com.tbbgc.denom.common.nodes.values.BooleanNode;
	import com.tbbgc.denom.common.nodes.values.GraphNode;
	import com.tbbgc.denom.common.nodes.values.NumberNode;
	import com.tbbgc.denom.common.nodes.values.RandomNode;
	import com.tbbgc.denom.common.nodes.values.TextNode;
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
			SelectSequenceNode,
			SelectSwitchNode,
			SelectSwitchValueNode,
			AsPointNode,
			IsBetweenNode,
			RoundNode,
			Deg2RadNode,
			NoteNode,
			PluginNode
		]);
	}
}
