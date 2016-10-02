+ Peer {

	addEffect {|key, effect| this.effectList.addEffect(key, effect)}

	listEffects { ^this.effectList.list }

	effectNames { ^this.effectList.names }

	effectBusIndex {|key| ^this.effectList.busIndex(key)}

	effectBus {|key| ^this.effectList.bus(key)}

	effectFree {|key| ^this.effectList.effectFree(key)}

	effectSet {|key, control, value| this.effectList.effectSet(key, control, value);}

}