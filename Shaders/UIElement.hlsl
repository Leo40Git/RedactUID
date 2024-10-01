// Based on https://github.com/SinsOfSeven/SliderImpact/blob/main/ResponsiveUI/draw_2d.hlsl, by SinsOfSeven

Texture1D<float4> IniParams : register(t120);

#define Position IniParams[0].xy
#define Size IniParams[0].zw

struct vs2ps {
	float4 pos : SV_Position0;
	float2 uv : TEXCOORD1;
};

#ifdef VERTEX_SHADER

void main(
		out vs2ps output,
		uint vertex : SV_VertexID)
{
	float2 base, offset;
	offset.x = Position.x * 2 - 1;
	offset.y = (1 - Position.y) * 2 - 1;
	base.xy = float2(2 * Size.x, 2 * (-Size.y));
	
	// not using vertex buffers, so manufacture our own coordinates
	switch (vertex) {
	case 0:
		output.pos.xy = float2(base.x + offset.x, base.y + offset.y);
		output.uv = float2(1, 0);
		break;

	case 1:
		output.pos.xy = float2(base.x + offset.x, 0 + offset.y);
		output.uv = float2(1, 1);
		break;

	case 2:
		output.pos.xy = float2(0 + offset.x, base.y + offset.y);
		output.uv = float2(0, 0);
		break;

	case 3:
		output.pos.xy = float2(0 + offset.x, 0 + offset.y);
		output.uv = float2(0, 1);
		break;

	default:
		output.pos.xy = 0;
		output.uv = float2(0, 0);
		break;
	};
	
	output.pos.zw = float2(0, 1);
}

#endif

#ifdef PIXEL_SHADER

Texture2D<float4> Texture : register(t0);

void main(
		vs2ps input,
		out float4 result : SV_Target0)
{
	float2 dims;
	Texture.GetDimensions(dims.x, dims.y);
	if (!dims.x || !dims.y)
		discard;

	input.uv.y = 1 - input.uv.y;
	result = Texture.Load(int3(input.uv.xy * dims.xy, 0));
}

#endif
