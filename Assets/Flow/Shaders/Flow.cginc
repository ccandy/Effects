#if !defined(FLOW_INCLUDED)
#define FLOW_INCLUDED

float3 FlowUVW(float2 uv, float2 flowVector, float time, bool flowB)
{
	float phase = flowB ? 0.5 : 0;
	float progress = frac(time + phase);
	float3 uvw;
	uvw.xy = uv - flowVector * progress + phase;
	uvw.z = 1 - abs(1- 2 * progress);
	return uvw;
}

#endif
