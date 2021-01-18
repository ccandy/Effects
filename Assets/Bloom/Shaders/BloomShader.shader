Shader "Effects/BloomShader"
{
	Properties
	{
		_MainTex("Main Tex", 2D) = "White"
	}
	CGINCLUDE
		#include "UnityCG.cginc"
		sampler2D _MainTex, _SourceTex;
		float4 _MainTex_TexelSize;
		
		struct VertexData {
			float4 vertex:POSITION;
			float2 uv:TEXCOORD0;
		};

		struct FragData 
		{
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
		};

		float3 Sample(float2 uv) 
		{
			return tex2D(_MainTex, uv);
		}

		float3 BoxSampler(float2 uv,float delta) 
		{
			float4 o = _MainTex_TexelSize.xyxy * float2(-delta, delta).xxyy;
			float3 s =
				Sample(uv + o.xy) + Sample(uv + o.zy) +
				Sample(uv + o.xw) + Sample(uv + o.zw);
			return s * 0.25f;
		}

		FragData VertexProgram(VertexData input) 
		{
			FragData output;
			output.pos = UnityObjectToClipPos(input.vertex);
			output.uv = input.uv;

			return output;
		}

		ENDCG
		SubShader
		{
			Cull Off
			ZTest Always
			ZWrite Off

			Pass //pass 0
			{
				CGPROGRAM
				#pragma vertex VertexProgram
				#pragma fragment FragProgram

				float4 FragProgram(FragData input) :SV_TARGET
				{

					float3 col = BoxSampler(input.uv,1);
					return float4(col, 1);
				}
				
				ENDCG
			}
			/*
			Pass //pass 1
			{
				Blend One One
				CGPROGRAM
				#pragma vertex VertexProgram
				#pragma fragment FragProgram

				float4 FragProgram(FragData input) :SV_TARGET
				{

					float3 col = BoxSampler(input.uv,0.5);
					return float4(col, 1);
				}

				ENDCG
			}*/

			Pass { // 2
			CGPROGRAM
				#pragma vertex VertexProgram
				#pragma fragment FragProgram

				float4 FragProgram(FragData input) : SV_Target {
					half4 c = tex2D(_SourceTex, input.uv);
					c.rgb += BoxSampler(input.uv, 0.5);
					return c;
				}
			ENDCG
		}
			

			

		}
	
}
