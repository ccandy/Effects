Shader "Effects/FlowShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _FlowMap("FlowMap(RG) A Noise", 2D) = "black"{}
        _Color("Color", color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            #include "Flow.cginc"
            struct VertData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct FragData
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex,_FlowMap;
            float4 _MainTex_ST;
            float4 _Color;

            FragData vert (VertData input)
            {
                FragData output;
                output.vertex = UnityObjectToClipPos(input.vertex);
                output.uv = TRANSFORM_TEX(input.uv, _MainTex);
                
                return output;
            }

            float4 frag(FragData i) : SV_Target
            {
                float2 flowVector = tex2D(_FlowMap, i.uv).rg * 2 - 1;
                float noise = tex2D(_FlowMap, i.uv).a;
                float time = noise + _Time.y;

                float3 uvwA = FlowUVW(i.uv, flowVector, time, true);
                float4 colA = tex2D(_MainTex, uvwA.xy) * uvwA.z;

                float3 uvwB = FlowUVW(i.uv, flowVector, time, false);
                float4 colB = tex2D(_MainTex, uvwB.xy) * uvwB.z;
                
                float4 finalColor = (colA + colB) * _Color;

                return finalColor;
            }
            ENDCG
        }
    }
}
